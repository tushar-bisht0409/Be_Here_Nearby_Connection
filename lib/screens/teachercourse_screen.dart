import 'dart:convert';
import 'dart:io';

// import 'package:behere/blocs/subject_bloc.dart';
// import 'package:behere/blocs/user_bloc.dart';
import 'package:behere/blocs/class_bloc.dart';
import 'package:behere/drawer.dart';
import 'package:behere/main.dart';
import 'package:behere/models/class_info.dart';
import 'package:behere/screens/teacherAttendance_screen.dart';
// import 'package:behere/models/subject_info.dart';
// import 'package:behere/models/user_info.dart';
import 'package:behere/screens/allclass_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class TeacherCourseScreen extends StatefulWidget {
  var institute;
  var instituteCode;
  var teacherName;
  TeacherCourseScreen(this.institute, this.instituteCode, this.teacherName);
  @override
  _TeacherCourseScreenState createState() => _TeacherCourseScreenState();
}

class _TeacherCourseScreenState extends State<TeacherCourseScreen> {
  // SubjectInfo subjectInfo = SubjectInfo();
  // SubjectBloc subjectBloc = SubjectBloc();
  // SubjectInfo newSubjectInfo = SubjectInfo();
  // SubjectBloc newSubjectBloc = SubjectBloc();
  ClassInfo classInfo = ClassInfo();
  ClassBloc classBloc = ClassBloc();
  TextEditingController subjectName = TextEditingController();
  TextEditingController section = TextEditingController();
  List<TextEditingController> contList = [new TextEditingController()];
  int optCount = 1;
  var collegeName;
  var collegeCode;
  var courseName;
  var tradeName;
  var startYear;
  var endYear;

  var teacher;
  var allStudents = [];
  var lists = [];
  var classes = [];
  bool isAdd = false;
  bool isLoading = true;
  bool isUploaded = true;
  bool isUploading = false;
  List<String> courseList = [];
  List<String> tradeList = [];
  List<String> batchYearsStart = [
    "2022",
    "2021",
    "2020",
    "2019",
    "2018",
    "2017",
    "2016"
  ];
  List<String> batchYearsEnd = [
    "2028",
    "2027",
    "2026",
    "2025",
    "2024",
    "2023",
    "2022"
  ];

  locationPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
  }

  Future<void> readCollegeFile() async {
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
          for (int i = 0; i < element['teachers'].length; i++) {
            if (element['teachers'][i]['id'] == myID) {
              lists.add(element);
            }
          }
        });
      });
    }
  }

  Future<void> readSubjectFile() async {
    var dd;
    var classNames = [];
    await getApplicationDocumentsDirectory().then((value) {
      if (mounted) {
        setState(() {
          dd = value.path;
        });
      }
    });

    for (int i = 0; i < lists.length; i++) {
      if (await File(dd + '/' + '${lists[i]['subjectID']}.txt').exists()) {
        var nn = '${lists[i]['subjectID']}.txt';
        var newList = jsonDecode(await File(dd + '/' + nn).readAsString());
        if (mounted) {
          setState(() {
            newList.forEach((element) {
              classNames.add(element['fileName']);
            });
          });
        }
        print('a $newList');
      }

      for (int i = 0; i < classNames.length; i++) {
        var nn = '${classNames[i]}';
        var newList = jsonDecode(await File(dd + '/' + nn).readAsString());
        if (mounted) {
          setState(() {
            classes.add(newList);
          });
        }
      }
      print(classes);
      if (mounted) {
        setState(() {
          if (classes.isEmpty) {
            isUploaded = true;
          } else {
            isUploaded = false;
          }
        });
      }
    }
  }

  Future<void> deleteSubjectFile() async {
    var dd;
    var classNames = [];
    await getApplicationDocumentsDirectory().then((value) {
      if (mounted) {
        setState(() {
          dd = value.path;
        });
      }
    });

    for (int i = 0; i < lists.length; i++) {
      if (await File(dd + '/' + '${lists[i]['subjectID']}.txt').exists()) {
        var nn = '${lists[i]['subjectID']}.txt';
        await File(dd + '/' + nn).delete();
      }

      for (int i = 0; i < classNames.length; i++) {
        var nn = '${classNames[i]}';
        var newList = jsonDecode(await File(dd + '/' + nn).readAsString());
        if (await File(dd + '/' + nn).exists()) {
          await File(dd + '/' + nn).delete();
        }
      }
      print(classes);
      if (mounted) {
        setState(() {
          isUploaded = true;
          isUploading = false;
        });
      }
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
    collegeName = widget.institute;
    collegeCode = widget.instituteCode;
    readCollegeFile().then((value) {
      isLoading = false;
      readSubjectFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            drawer: AppDrawer(lists),
            body: Stack(children: <Widget>[
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: <Widget>[
                        SizedBox(height: 50.w + 30.h),
                        StreamBuilder<dynamic>(builder: (ctx, sshot) {
                          if (lists != []) {
                            return ListView.builder(
                                itemCount: lists.length,
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
                                                              "")));
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
                                                    FontAwesomeIcons.peopleLine,
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
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) =>
                                                            TeacherAttendanceScreen(
                                                                lists[index][
                                                                    'students'],
                                                                teacher,
                                                                lists[index][
                                                                    'subjectID']))).then(
                                                    (value) =>
                                                        readSubjectFile());
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
                                  //TeacherCourse(lists[index]);
                                });
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
                                        color: appColor.dBlue,
                                        size: 25.w,
                                      ))),
                              Container(
                                alignment: Alignment.center,
                                width: 360.w - 2 * (50.w + 16),
                                child: Text(
                                  'My Courses',
                                  style: TextStyle(
                                      color: appColor.dBlue,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              StreamBuilder<dynamic>(
                                  stream: classBloc.classStream,
                                  builder: (ctx, snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data['success']) {
                                        WidgetsBinding.instance!
                                            .addPostFrameCallback((_) {
                                          if (mounted) {
                                            setState(() {
                                              deleteSubjectFile();
                                            });
                                          }
                                        });
                                      }
                                    }
                                    return isUploading
                                        ? Container(
                                            width: 25.w,
                                            height: 3.h,
                                            child: LinearProgressIndicator(),
                                          )
                                        : IconButton(
                                            onPressed: isUploaded
                                                ? () {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      content: Text(
                                                        'No Records To Upload',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ));
                                                  }
                                                : () {
                                                    if (mounted) {
                                                      setState(() {
                                                        classInfo.actions =
                                                            'createMany';
                                                        classInfo.classes =
                                                            classes;
                                                        classBloc.eventSink
                                                            .add(classInfo);
                                                        isUploading = true;
                                                      });
                                                    }
                                                  },
                                            icon: Icon(
                                              isUploaded
                                                  ? Icons
                                                      .check_circle_outline_rounded
                                                  : Icons.sync,
                                              color: isUploaded
                                                  ? Colors.green
                                                  : appColor.dBlue,
                                              size: 25.w,
                                            ));
                                  }),
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
