import 'dart:convert';
import 'dart:io';

import 'package:behere/blocs/subject_bloc.dart';
import 'package:behere/drawer.dart';
import 'package:behere/main.dart';
import 'package:behere/models/subject_info.dart';
import 'package:behere/screens/allclass_screen.dart';
import 'package:behere/screens/joinAttendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class StudentCourseScreen extends StatefulWidget {
  var uInfo;
  var infoFrom;
  StudentCourseScreen(this.uInfo, this.infoFrom);
  @override
  _StudentCourseScreenState createState() => _StudentCourseScreenState();
}

class _StudentCourseScreenState extends State<StudentCourseScreen> {
  // SubjectInfo subjectInfo = SubjectInfo();
  // SubjectBloc subjectBloc = SubjectBloc();
  var myProfile;
  var lists = [];
  bool isLoading = true;

  locationPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
  }

  Future<void> readFile() async {
    var dd;
    await getApplicationDocumentsDirectory().then((value) {
      if (mounted) {
        setState(() {
          dd = value.path;
        });
      }
    });
    var nn = 'behere.txt';
    var newList = jsonDecode(await File(dd + '/' + nn).readAsString());
    if (mounted) {
      setState(() {
        newList.forEach((element) {
          for (int i = 0; i < element['students'].length; i++) {
            if (element['students'][i]['email'] == myEmail) {
              lists.add(element);
            }
          }
        });
      });
    }
  }

  String arrayToString(var arr) {
    String str = '';
    for (int i = 0; i < arr.length; i++) {
      if (i == 0) {
        str = arr[i];
      } else {
        str = str + ', ' + arr[i];
      }
    }
    return str;
  }

  @override
  void initState() {
    super.initState();
    readFile().then((value) {
      isLoading = false;
    });

    myProfile = {
      "name": myName,
      "rollno": myRollno,
      "email": myEmail,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            drawer: AppDrawer(lists),
            body: Stack(children: <Widget>[
              isLoading
                  ? Container(
                      height: 500.h,
                      width: 360.w,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator())
                  : ListView(
                      children: <Widget>[
                        SizedBox(height: 50.w + 20.h),
                        StreamBuilder<dynamic>(
                            // stream: subjectBloc.subjectStream,
                            builder: (ctx, snapshot) {
                          // if (snapshot.hasData) {
                          //   if (snapshot.data["success"]) {
                          if (lists != []) {
                            return ListView.builder(
                                itemCount:
                                    lists.length, //snapshot.data["msz"].length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  String shortName = "";
                                  shortName = lists[index]["subjectName"][0];
                                  for (int i = 0;
                                      i < lists[index]["subjectName"].length;
                                      i++) {
                                    if (lists[index]["subjectName"][i] == " ") {
                                      shortName =
                                          "$shortName${lists[index]["subjectName"][i + 1]}";
                                    }
                                  }
                                  if (shortName.length == 1) {
                                    shortName = lists[index]["subjectName"];
                                  }
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 20.h, horizontal: 20.w),
                                    width: 320.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30.w),
                                          bottomLeft: Radius.circular(30.w)),
                                      gradient: LinearGradient(colors: [
                                        appColor.wBlue,
                                        Colors.white
                                      ], stops: [
                                        0.1,
                                        0.9
                                      ]),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Card(
                                          margin: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.w))),
                                          child: Container(
                                            width: 160.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.w)),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    appColor.lBlue,
                                                    appColor.dBlue
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  stops: [0.1, 0.3]),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5.h,
                                                horizontal: 10.w),
                                            child: Column(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 25.h,
                                                ),
                                                Container(
                                                  width: 140.w,
                                                  alignment: Alignment.center,
                                                  child: Text(shortName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16.sp)),
                                                ),
                                                Container(
                                                  width: 140.w,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      lists[index]
                                                          ["subjectName"],
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10.sp)),
                                                ),
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                Container(
                                                  width: 140.w,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      '${arrayToString(lists[index]["branches"])}, Section ${arrayToString(lists[index]["sections"])}',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10.sp)),
                                                ),
                                                Container(
                                                  width: 140.w,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      '(${arrayToString(lists[index]["batches"])})',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 10.sp)),
                                                ),
                                                SizedBox(
                                                  height: 20.h,
                                                ),
                                                GestureDetector(child:
                                                    StreamBuilder<dynamic>(
                                                        // stream: enrollBloc.userStream,
                                                        builder:
                                                            (ctx, enrtollsnap) {
                                                  return Container(
                                                    width: 100.w,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5.h,
                                                            horizontal: 10.w),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        border: Border.all(
                                                            width: 0),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    5.w))),
                                                    child: Text('View Class',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12.sp)),
                                                  );
                                                }), onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (builder) => AllClassScreen(
                                                              lists[index]
                                                                  ["subjectID"],
                                                              shortName,
                                                              lists[index][
                                                                  "subjectName"],
                                                              arrayToString(lists[
                                                                      index]
                                                                  ["branches"]),
                                                              arrayToString(lists[
                                                                      index]
                                                                  ["batches"]),
                                                              arrayToString(lists[
                                                                      index]
                                                                  ["sections"]),
                                                              lists[index]
                                                                  ["students"],
                                                              myProfile)));
                                                }),
                                                SizedBox(
                                                  height: 25.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                            child: Container(
                                              width: 160.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.h,
                                                  horizontal: 10.w),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 15.h,
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .graduationCap,
                                                    size: 60.w,
                                                    color: appColor.dBlue,
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Card(
                                                      margin: EdgeInsets.zero,
                                                      elevation: 10,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5.w))),
                                                      child: Container(
                                                        width: 100.w,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5.h,
                                                                horizontal:
                                                                    8.w),
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: appColor
                                                                    .dBlue,
                                                                // border: Border.all(width: 2.w, color: Colors.blue),
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5.w))),
                                                        child: Text(
                                                            'Attendance',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize:
                                                                    12.sp)),
                                                      )),
                                                  SizedBox(
                                                    height: 15.h,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            onTap: () async {
                                              if (await Permission.location
                                                  .request()
                                                  .isGranted) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) => JoinAttendanceScreen(
                                                            lists[index]
                                                                ["subjectID"],
                                                            shortName,
                                                            lists[index]
                                                                ["subjectName"],
                                                            arrayToString(lists[
                                                                    index]
                                                                ["branches"]),
                                                            arrayToString(lists[
                                                                    index]
                                                                ["batches"]),
                                                            arrayToString(lists[
                                                                    index]
                                                                ["sections"]),
                                                            lists[index]
                                                                ["students"],
                                                            myProfile)));
                                              } else if (await Permission
                                                  .location
                                                  .request()
                                                  .isPermanentlyDenied) {
                                                openAppSettings();
                                              } else {
                                                locationPermission();
                                              }
                                            }),
                                      ],
                                    ),
                                  );
                                  //StudentCourse(lists[index], myProfile);
                                });
                            // } else if (snapshot.data["success"] == false) {
                          } else {
                            return Container(
                              height: 300.h,
                              width: 360.w,
                              margin: EdgeInsets.symmetric(
                                  vertical: 80.h, horizontal: 0.w),
                              child: Image.asset(
                                'assets/images/ns.png',
                                fit: BoxFit.fitHeight,
                              ),
                            );
                          }
                        }),
                        Container(
                          height: 100.h,
                        )
                      ],
                    ),
              Positioned(
                  top: 0,
                  child: Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Builder(
                                  builder: (ctx) => IconButton(
                                      onPressed: () {
                                        Scaffold.of(ctx).openDrawer();
                                      },
                                      icon: Icon(
                                        Icons.menu,
                                        color: Colors.black,
                                        size: 25.w,
                                      ))),
                              Container(
                                alignment: Alignment.center,
                                width: 360.w - 2 * (50.w + 16),
                                child: Text(
                                  'My Courses',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.account_circle_rounded,
                                    color: Colors.transparent,
                                    size: 25.w,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Container(
                            height: 1.h,
                            width: 360.w,
                            color: appColor.wBlue,
                          ),
                        ],
                      )))
            ])));
  }
}
