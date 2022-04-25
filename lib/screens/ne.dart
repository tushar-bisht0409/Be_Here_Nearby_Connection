import 'dart:convert';
import 'dart:io';

import 'package:behere/attendance.dart';
import 'package:behere/blocs/class_bloc.dart';
import 'package:behere/main.dart';
import 'package:behere/models/class_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

class TeacherAttendanceScreen extends StatefulWidget {
  var students;
  var teacher;
  var subjectID;
  TeacherAttendanceScreen(this.students, this.teacher, this.subjectID);
  @override
  State<TeacherAttendanceScreen> createState() =>
      _TeacherAttendanceScreenState();
}

class _TeacherAttendanceScreenState extends State<TeacherAttendanceScreen> {
  bool isStarted = false;
  bool isCreated = false;
  bool canChange = false;
  var nearbyService;
  var subscription;
  List<Device> devices = [];
  var studentPresent = [];
  bool isInternet = false;
  bool isLoading = false;
  bool isUploaded = false;
  bool isSaved = false;
  var classID;

  ClassInfo newClassInfo = ClassInfo();
  ClassBloc newClassBloc = ClassBloc();

  ClassInfo classInfo = ClassInfo();
  ClassBloc classBloc = ClassBloc();

  ClassInfo presentInfo = ClassInfo();
  ClassBloc presentBloc = ClassBloc();

  ClassInfo attInfo = ClassInfo();
  ClassBloc attBloc = ClassBloc();

  Future<void> startBrowsing() async {
    if (mounted) {
      setState(() {});
      await nearbyService.init(
          serviceType: 'mpconn',
          deviceName: myID,
          strategy: Strategy.P2P_CLUSTER,
          callback: (isRunning) async {
            if (isRunning) {
              await nearbyService.stopBrowsingForPeers();
              await Future.delayed(Duration(microseconds: 200));
              await nearbyService.startBrowsingForPeers();
            }
          });

      subscription =
          nearbyService.stateChangedSubscription(callback: (devicesList) {
        devicesList.forEach((element) {
          if (mounted) {
            setState(() {
              devices.clear();
              devices.addAll(devicesList);
            });
          }
        });
      });
    }
  }

  Future<void> saveAttendance() async {
    var dd;
    var ll = {
      "classID": classID.toString(),
      "subjectID": widget.subjectID,
      "teacher": widget.teacher,
      "studentPresent": studentPresent,
    };
    await getApplicationDocumentsDirectory().then((value) {
      if (mounted) {
        setState(() {
          dd = value.path;
        });
      }
    });
    var nn = '${widget.subjectID}_$classID.txt';
    await File(dd + '/' + nn).create(recursive: true).then((file) async {
      await file.writeAsString(jsonEncode(ll)).then((value) async {
        await maintainRecordsFile(classID);
        print(value.readAsString().then((value) {
          print(value);
        }));
      });
    });
    if (isInternet == false) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline_rounded,
                color: Colors.green,
                size: 50.w,
              ),
              Text(
                "Attendance Saved Successfully",
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Ok',
                style: TextStyle(color: Colors.lightBlue),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  Future<void> maintainRecordsFile(var cID) async {
    var dd;
    var oldRec;
    await getApplicationDocumentsDirectory().then((value) {
      if (mounted) {
        setState(() {
          dd = value.path;
        });
      }
    });
    var nn = '${widget.subjectID}.txt';
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (mounted) {
          setState(() {
            isInternet = true;
          });
        }
      }
    } on SocketException catch (_) {
      if (mounted) {
        setState(() {
          isInternet = false;
        });
      }
    }
    if (isInternet) {
      //upload to server
      classInfo.actions = "create";
      classInfo.subjectID = widget.subjectID;
      classInfo.classID = cID.toString();
      classInfo.studentPresent = studentPresent;
      classBloc.eventSink.add(classInfo);
    } else {
      if (await File(dd + '/' + nn).exists()) {
        print(await File(dd + '/' + nn).readAsString());
        oldRec = await jsonDecode(await File(dd + '/' + nn).readAsString());
        print('oldRec:   $oldRec');
        var newRec = [
          {
            "classID": cID.toString(),
            "subjectID": widget.subjectID,
            "fileName": '${widget.subjectID}_$cID.txt'
          }
        ];
        oldRec.forEach((element) {
          newRec.add(element);
        });
        print('newRec: $newRec');
        await File(dd + '/' + nn).writeAsString(jsonEncode(newRec)).then(
            (value) =>
                print(value.readAsString().then((value) => print(value))));
      } else {
        File(dd + '/' + nn).create(recursive: true).then((file) async {
          file
              .writeAsString(jsonEncode([
                {
                  "classID": cID.toString(),
                  "subjectID": widget.subjectID,
                  "fileName": '${widget.subjectID}_$cID.txt'
                }
              ]))
              .then((value) =>
                  print(value.readAsString().then((value) => print(value))));
        });
      }
    }
  }

  Future<void> dialogueBox() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Save Attendance',
          style: TextStyle(color: Colors.black),
        ),
        content: Text(
          "Do you want to save the attendance record",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'No',
              style: TextStyle(color: Colors.lightBlue),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(
              'Ok',
              style: TextStyle(color: Colors.lightBlue),
            ),
            onPressed: () async {
              if (mounted) {
                setState(() {
                  isLoading = true;
                });
              }
              Navigator.of(context, rootNavigator: true).pop();
              await saveAttendance().then((value) {
                if (mounted) {
                  setState(() {
                    if (isInternet == false) {
                      isLoading = false;
                      isSaved = true;
                    }
                  });
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Future<void> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (mounted) {
          setState(() {
            isInternet = true;
          });
        }
      }
    } on SocketException catch (_) {
      if (mounted) {
        setState(() {
          isInternet = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nearbyService = NearbyService();
    classID = DateTime.now().millisecondsSinceEpoch;
    newClassInfo.actions = "create";
    newClassInfo.subjectID = widget.subjectID;
    newClassInfo.classID = classID;
    newClassInfo.teacher = widget.teacher;
    newClassInfo.studentPresent = [];
    presentInfo.actions = "presentAbsentList";
    presentInfo.classID = classID;
    presentInfo.studentAbsent = [];

    attInfo.actions = 'getClass';
    attInfo.getBy = 'classID';
    attInfo.classID = classID;

    checkInternet().then((value) {
      if (isInternet) {
        newClassBloc.eventSink.add(classInfo);
      } else {
        isStarted = true;
        isCreated = true;
        startBrowsing().then((value) {
          Future.delayed(Duration(seconds: 20), () {
            if (mounted) {
              setState(() {
                nearbyService.stopBrowsingForPeers();
                nearbyService.stopAdvertisingPeer();
                presentInfo.studentPresent = studentPresent;
                presentBloc.eventSink.add(presentInfo);
                isStarted = false;
              });
            }
          });
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    nearbyService.stopBrowsingForPeers();
    nearbyService.stopAdvertisingPeer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              body: isCreated
                  ? Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: <Widget>[
                          ListView(
                            children: <Widget>[
                              StreamBuilder<dynamic>(
                                  stream: newClassBloc.classStream,
                                  builder: (ctx, ss) {
                                    if (ss.hasData) {
                                      if (ss.data['success']) {
                                        if (isStarted == false) {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            if (mounted) {
                                              setState(() {
                                                isStarted = true;
                                                isCreated = true;
                                              });
                                            }
                                            startBrowsing().then((value) {
                                              Future.delayed(
                                                  Duration(seconds: 20), () {
                                                if (mounted) {
                                                  setState(() {
                                                    nearbyService
                                                        .stopBrowsingForPeers();
                                                    nearbyService
                                                        .stopAdvertisingPeer();
                                                    isStarted = false;
                                                  });
                                                }
                                              });
                                            });
                                          });
                                        }
                                      }
                                    }
                                    return SizedBox();
                                  }),
                              StreamBuilder<dynamic>(
                                  stream: presentBloc.classStream,
                                  builder: (ctx, att) {
                                    if (att.hasData) {
                                      if (att.data['success']) {
                                        if (isStarted == false) {
                                          WidgetsBinding.instance!
                                              .addPostFrameCallback((_) {
                                            if (mounted) {
                                              setState(() {
                                                canChange = true;
                                              });
                                            }
                                          });
                                        }
                                      }
                                    }
                                    return SizedBox();
                                  }),
                              StreamBuilder<dynamic>(
                                  stream: classBloc.classStream,
                                  builder: (ctx, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data['success']) {
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) {
                                          if (mounted) {
                                            setState(() {
                                              if (isLoading) {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  useRootNavigator: true,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons
                                                              .check_circle_outline_rounded,
                                                          color: Colors.green,
                                                          size: 50.w,
                                                        ),
                                                        Text(
                                                          "Attendance Saved Successfully",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                          'Ok',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .lightBlue),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                              isLoading = false;
                                              isSaved = true;
                                            });
                                          }
                                        });
                                      }
                                    }
                                    return SizedBox();
                                  }),
                              Container(
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        width: 360.w - 2 * (50.w + 16),
                                        child: Text(
                                          'Attendance',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      isStarted
                                          ? LinearProgressIndicator(
                                              minHeight: 4.h,
                                            )
                                          : Container(
                                              height: 4.h,
                                              width: 360.w,
                                              color: appColor.wBlue,
                                            ),
                                    ],
                                  )),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 20.w),
                                  child: Column(children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          width: 100.w,
                                          alignment: Alignment.center,
                                          child: RichText(
                                              text: TextSpan(
                                                  text: 'Strength: ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        '${widget.students.length}',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w800))
                                              ])),
                                        ),
                                        Container(
                                          width: 100.w,
                                          alignment: Alignment.center,
                                          child: RichText(
                                              text: TextSpan(
                                                  text: 'Present: ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: studentPresent.isEmpty
                                                        ? '0'
                                                        : '${studentPresent.length}',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w800))
                                              ])),
                                        ),
                                        Container(
                                          width: 100.w,
                                          alignment: Alignment.center,
                                          child: RichText(
                                              text: TextSpan(
                                                  text: 'Absent: ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp),
                                                  children: <TextSpan>[
                                                TextSpan(
                                                    text: studentPresent.isEmpty
                                                        ? '${widget.students.length}'
                                                        : '${widget.students.length - studentPresent.length}',
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w800))
                                              ])),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10.h)
                                  ])),
                              Container(
                                height: 4.h,
                                width: 360.w,
                                color: appColor.wBlue,
                              ),
                              SizedBox(height: 20.h),
                              isInternet
                                  ? StreamBuilder<dynamic>(
                                      stream: attBloc.classStream,
                                      builder: (ctx, ats) {
                                        attBloc.eventSink.add(attInfo);
                                        if (ats.hasData) {
                                          if (ats.data['success']) {
                                            WidgetsBinding.instance!
                                                .addPostFrameCallback((_) {
                                              if (mounted) {
                                                setState(() {
                                                  studentPresent =
                                                      ats.data['msz'][0]
                                                          ['studentPresent'];
                                                });
                                              }
                                            });
                                            return ListView.builder(
                                                itemCount:
                                                    widget.students.length,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (ctx, index) {
                                                  WidgetsBinding.instance!
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    if (mounted) {
                                                      setState(() {
                                                        studentPresent = ats
                                                                .data['msz'][0]
                                                            ['studentPresent'];
                                                      });
                                                    }
                                                  });
                                                  var isP = false;
                                                  int ind = studentPresent
                                                      .indexWhere((element) =>
                                                          element['rollno'] ==
                                                          widget.students[index]
                                                              ['rollno']);

                                                  if (ind == -1) {
                                                    isP = false;
                                                  } else {
                                                    isP = true;
                                                  }
                                                  return Attendance(
                                                      classID,
                                                      widget.students[index],
                                                      index,
                                                      isP,
                                                      true,
                                                      isStarted);
                                                });
                                          }
                                        }
                                        return Container(
                                          padding: EdgeInsets.only(top: 100.h),
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(),
                                        );
                                      })
                                  : ListView.builder(
                                      itemCount: widget.students.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (ctx, index) {
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) {
                                          if (mounted) {
                                            setState(() {
                                              devices.forEach((element) {
                                                if (element.deviceName ==
                                                    widget.students[index]
                                                        ['rollno']) {
                                                  if (studentPresent != []) {
                                                    if (studentPresent.contains(
                                                            widget.students[
                                                                index]) ==
                                                        false) {
                                                      studentPresent.add(widget
                                                          .students[index]);
                                                    }
                                                  } else {
                                                    studentPresent.add(
                                                        widget.students[index]);
                                                  }
                                                }
                                              });
                                            });
                                          }
                                        });

                                        return studentPresent.contains(
                                                widget.students[index])
                                            ? SizedBox()
                                            : Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 10.h,
                                                    horizontal: 20.w),
                                                width: 320.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Card(
                                                      margin: EdgeInsets.zero,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.w))),
                                                      child: Container(
                                                          width: 235.w,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.w)),
                                                            gradient: LinearGradient(
                                                                colors: [
                                                                  appColor
                                                                      .lBlue,
                                                                  appColor.dBlue
                                                                ],
                                                                begin: Alignment
                                                                    .topLeft,
                                                                end: Alignment
                                                                    .bottomRight,
                                                                stops: [
                                                                  0.1,
                                                                  0.3
                                                                ]),
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5.h,
                                                                  horizontal:
                                                                      10.w),
                                                          child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: 30.w,
                                                                  child: Text(
                                                                      '${index + 1}.',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              12.sp)),
                                                                ),
                                                                Column(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      width:
                                                                          185.w,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                          '${widget.students[index]['name']}',
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w700,
                                                                              fontSize: 12.sp)),
                                                                    ),
                                                                    Container(
                                                                      width:
                                                                          185.w,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child: Text(
                                                                          '${widget.students[index]['rollno']}',
                                                                          textAlign: TextAlign
                                                                              .center,
                                                                          style: TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontSize: 10.sp)),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ])),
                                                    ),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    GestureDetector(
                                                        child: Container(
                                                          width: 75.w,
                                                          alignment:
                                                              Alignment.center,
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 5.h,
                                                                  horizontal:
                                                                      10.w),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(
                                                                      5.w)),
                                                              color: studentPresent.contains(
                                                                      widget.students[
                                                                          index])
                                                                  ? Colors.green
                                                                      .withOpacity(isStarted
                                                                          ? 0.5
                                                                          : 1)
                                                                  : Colors.red.withOpacity(
                                                                      isStarted
                                                                          ? 0.5
                                                                          : 1)),
                                                          child: Text(
                                                              studentPresent.contains(
                                                                      widget.students[
                                                                          index])
                                                                  ? 'Present'
                                                                  : 'Absent',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  fontSize:
                                                                      10.sp)),
                                                        ),
                                                        onTap: isStarted
                                                            ? null
                                                            : () {
                                                                if (mounted) {
                                                                  setState(() {
                                                                    int ind = studentPresent.indexWhere((element) =>
                                                                        element[
                                                                            'rollno'] ==
                                                                        widget.students[index]
                                                                            [
                                                                            'rollno']);
                                                                    studentPresent
                                                                        .remove(
                                                                            widget.students[index]);
                                                                    if (ind ==
                                                                        -1) {
                                                                      studentPresent.add(
                                                                          widget
                                                                              .students[index]);
                                                                    } else {
                                                                      studentPresent
                                                                          .remove(
                                                                              widget.students[index]);
                                                                    }
                                                                  });
                                                                }
                                                                print(
                                                                    studentPresent);
                                                              })
                                                  ],
                                                ),
                                              );
                                      }),
                              ListView.builder(
                                  itemCount: widget.students.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (ctx, index) {
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        setState(() {
                                          devices.forEach((element) {
                                            if (element.deviceName ==
                                                widget.students[index]
                                                    ['rollno']) {
                                              if (studentPresent != []) {
                                                if (studentPresent.contains(
                                                        widget
                                                            .students[index]) ==
                                                    false) {
                                                  studentPresent.add(
                                                      widget.students[index]);
                                                }
                                              } else {
                                                studentPresent.add(
                                                    widget.students[index]);
                                              }
                                            }
                                          });
                                        });
                                      }
                                    });

                                    return studentPresent
                                            .contains(widget.students[index])
                                        ? Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10.h,
                                                horizontal: 20.w),
                                            width: 320.w,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Card(
                                                  margin: EdgeInsets.zero,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.w))),
                                                  child: Container(
                                                      width: 235.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10.w)),
                                                        gradient: LinearGradient(
                                                            colors: [
                                                              appColor.lBlue,
                                                              appColor.dBlue
                                                            ],
                                                            begin: Alignment
                                                                .topLeft,
                                                            end: Alignment
                                                                .bottomRight,
                                                            stops: [0.1, 0.3]),
                                                      ),
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5.h,
                                                              horizontal: 10.w),
                                                      child: Row(
                                                          children: <Widget>[
                                                            Container(
                                                              width: 30.w,
                                                              child: Text(
                                                                  '${index + 1}.',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          12.sp)),
                                                            ),
                                                            Column(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  width: 185.w,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                      '${widget.students[index]['name']}',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              12.sp)),
                                                                ),
                                                                Container(
                                                                  width: 185.w,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                      '${widget.students[index]['rollno']}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize:
                                                                              10.sp)),
                                                                ),
                                                              ],
                                                            ),
                                                          ])),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                GestureDetector(
                                                    child: Container(
                                                      width: 75.w,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 5.h,
                                                              horizontal: 10.w),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      5.w)),
                                                          color: studentPresent.contains(
                                                                  widget.students[
                                                                      index])
                                                              ? Colors.green
                                                                  .withOpacity(
                                                                      isStarted
                                                                          ? 0.5
                                                                          : 1)
                                                              : Colors.red
                                                                  .withOpacity(
                                                                      isStarted ? 0.5 : 1)),
                                                      child: Text(
                                                          studentPresent.contains(
                                                                  widget.students[
                                                                      index])
                                                              ? 'Present'
                                                              : 'Absent',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              fontSize: 10.sp)),
                                                    ),
                                                    onTap: isStarted
                                                        ? null
                                                        : () {
                                                            if (mounted) {
                                                              setState(() {
                                                                int ind = studentPresent.indexWhere((element) =>
                                                                    element[
                                                                        'rollno'] ==
                                                                    widget.students[
                                                                            index]
                                                                        [
                                                                        'rollno']);
                                                                studentPresent
                                                                    .remove(widget
                                                                            .students[
                                                                        index]);
                                                                if (ind == -1) {
                                                                  studentPresent
                                                                      .add(widget
                                                                              .students[
                                                                          index]);
                                                                } else {
                                                                  studentPresent
                                                                      .remove(widget
                                                                              .students[
                                                                          index]);
                                                                }
                                                              });
                                                            }
                                                            print(
                                                                studentPresent);
                                                          })
                                              ],
                                            ),
                                          )
                                        : SizedBox();
                                  }),
                              SizedBox(
                                height: 80.h,
                              )
                            ],
                          ),
                          Positioned(
                              bottom: 0,
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 20.h, horizontal: 40.w),
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: <Widget>[
                                      isLoading
                                          ? SizedBox()
                                          : isStarted == false
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 2.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil()
                                                                .setWidth(30)),
                                                    color: isSaved
                                                        ? Colors.green
                                                        : appColor.dBlue,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        isSaved
                                                            ? Icons
                                                                .check_circle_outline_rounded
                                                            : Icons
                                                                .cloud_download,
                                                        color: isSaved
                                                            ? Colors.white
                                                            : Colors.lightBlue,
                                                        size: 20.w,
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          isSaved
                                                              ? "Saved"
                                                              : "Save",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14.sp),
                                                        ),
                                                        onPressed: () async {
                                                          if (isSaved) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                'Saved Successfully',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ));
                                                          } else {
                                                            if (mounted) {
                                                              setState(() {
                                                                isLoading =
                                                                    true;
                                                              });
                                                            }
                                                            await saveAttendance()
                                                                .then((value) {
                                                              if (mounted) {
                                                                setState(() {
                                                                  if (isInternet ==
                                                                      false) {
                                                                    isLoading =
                                                                        false;
                                                                    isSaved =
                                                                        true;
                                                                  }
                                                                });
                                                              }
                                                            });
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : SizedBox(),
                                      isStarted
                                          ? Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 2.h),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        ScreenUtil()
                                                            .setWidth(30)),
                                                color: appColor.dBlue,
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    isStarted
                                                        ? Icons.schedule_rounded
                                                        : Icons
                                                            .check_circle_rounded,
                                                    color: isStarted
                                                        ? Colors.lightBlue
                                                        : Colors.green,
                                                    size: 20.w,
                                                  ),
                                                  TextButton(
                                                    child: Text(
                                                      isStarted
                                                          ? "Taking Attendance"
                                                          : "Completed",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.sp),
                                                    ),
                                                    onPressed: () {
                                                      if (mounted) {
                                                        setState(() {
                                                          if (isStarted) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                'Taking Attendance',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.blue,
                                                            ));
                                                          } else {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                'Attendance Taken Successfully',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.green,
                                                            ));
                                                          }
                                                        });
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ),
                                            )
                                          : SizedBox(),
                                      isStarted
                                          ? SizedBox()
                                          : isLoading
                                              ? Container(
                                                  width: 100.w,
                                                  child:
                                                      LinearProgressIndicator())
                                              : Container(
                                                  margin: EdgeInsets.only(
                                                      left: 20.w),
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 2.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            ScreenUtil()
                                                                .setWidth(30)),
                                                    color: appColor.dBlue,
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.home_rounded,
                                                        color: Colors.lightBlue,
                                                        size: 20.w,
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          "Home",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14.sp),
                                                        ),
                                                        onPressed: () async {
                                                          if (isSaved) {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          } else {
                                                            await dialogueBox();
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                    ],
                                  ))),
                        ])
                  : Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    ),
            )));
  }
}
