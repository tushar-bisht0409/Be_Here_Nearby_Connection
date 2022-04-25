import 'dart:ui';

import 'package:behere/blocs/class_bloc.dart';
import 'package:behere/blocs/subject_bloc.dart';
import 'package:behere/main.dart';
import 'package:behere/models/class_info.dart';
import 'package:behere/models/subject_info.dart';
import 'package:behere/screens/classattendance_screen.dart';
import 'package:behere/screens/class_screen.dart';
import 'package:behere/screens/studentattendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AllClassScreen extends StatefulWidget {
  var subjectID;
  var shortName;
  var subjectName;
  var branch;
  var batch;
  var section;
  var students;
  var student;
  AllClassScreen(this.subjectID, this.shortName, this.subjectName, this.branch,
      this.batch, this.section, this.students, this.student);
  @override
  _AllClassScreenState createState() => _AllClassScreenState();
}

class _AllClassScreenState extends State<AllClassScreen> {
  var classDate;
  var classTime;
  String preMinute = "";
  bool isAdd = false;
  bool isLoading = true;
  var classes = [];
  ClassInfo classInfo = ClassInfo();
  ClassBloc classBloc = ClassBloc();

  locationPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
    ].request();
    print(statuses[Permission.location]);
  }

  @override
  void initState() {
    super.initState();
    classInfo.actions = "getClass";
    classInfo.getBy = "subjectID";
    classInfo.subjectID = widget.subjectID;
    classBloc.eventSink.add(classInfo);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: <Widget>[
              ListView(
                children: <Widget>[
                  SizedBox(height: 50.w + 20.h),
                  isLoading
                      ? SizedBox()
                      : Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.w))),
                          margin: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 20.w),
                          child: GestureDetector(
                              child: Container(
                                  // width: 150.w,

                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 10.w),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.w))),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.poll_rounded,
                                          color: Colors.white,
                                          size: 20.w,
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Text('View Attendance Report',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.sp)),
                                      ])),
                              onTap: () {
                                if (myMode == "teacher") {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              ClassAttendanceScreen(
                                                  widget.shortName,
                                                  widget.subjectName,
                                                  widget.branch,
                                                  widget.section,
                                                  widget.batch,
                                                  widget.students,
                                                  classes)));
                                } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              StudentAttendanceScreen(
                                                  widget.shortName,
                                                  widget.subjectName,
                                                  widget.branch,
                                                  widget.section,
                                                  widget.batch,
                                                  widget.student,
                                                  classes)));
                                }
                              })),
                  StreamBuilder<dynamic>(
                      stream: classBloc.classStream,
                      builder: (ctx, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data["success"]) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  classes = snapshot.data["msz"];
                                  isLoading = false;
                                });
                              }
                            });
                            return ListView.builder(
                                reverse: true,
                                itemCount: snapshot.data["msz"].length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  var tsData =
                                      DateTime.fromMillisecondsSinceEpoch(
                                          int.parse(snapshot.data["msz"][index]
                                              ["classID"]));
                                  var ampm = 'a.m';
                                  var hr = '0';
                                  if (tsData.hour < 12) {
                                    hr = tsData.hour.toString();
                                  } else if (tsData.hour == 12) {
                                    hr = '12';
                                    ampm = 'p.m';
                                  } else if (tsData.hour == 24) {
                                    hr = '12';
                                    ampm = 'a.m';
                                  } else {
                                    hr = (tsData.hour - 12).toString();
                                    ampm = 'p.m';
                                  }
                                  var timing =
                                      "$hr:00 $ampm, ${DateFormat('dd MMMM, yyy').format(tsData)}";
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.h, horizontal: 20.w),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 250.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.w)),
                                            gradient: LinearGradient(
                                                colors: [
                                                  appColor.lBlue,
                                                  appColor.dBlue
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                stops: [0.1, 0.3]),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                width: 250.w,
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                    left: 10.w,
                                                    top: 25.h,
                                                    right: 10.w,
                                                    bottom: 5.h),
                                                child: Text(
                                                  '${widget.shortName} (${widget.subjectName})',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                width: 250.w,
                                                margin: EdgeInsets.only(
                                                    left: 10.w,
                                                    right: 10.w,
                                                    top: 5.h,
                                                    bottom: 5.h),
                                                child: Text(
                                                  '${widget.branch}, Section ${widget.section} (${widget.batch})',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Container(
                                                width: 250.w,
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                    left: 10.w,
                                                    top: 5.h,
                                                    right: 10.w,
                                                    bottom: 5.h),
                                                child: Text(
                                                  timing,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Colors.white),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              GestureDetector(
                                                  child: Container(
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
                                                    child: Text('Attendance',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 12.sp)),
                                                  ),
                                                  onTap: () async {
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (builder) =>
                                                                    ClassScreen(
                                                                      snapshot.data["msz"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "classID"],
                                                                      snapshot.data["msz"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "subjectID"],
                                                                      widget
                                                                          .shortName,
                                                                      widget
                                                                          .subjectName,
                                                                      widget
                                                                          .branch,
                                                                      widget
                                                                          .batch,
                                                                      widget
                                                                          .section,
                                                                      timing,
                                                                      widget
                                                                          .students,
                                                                      widget
                                                                          .student,
                                                                      snapshot.data["msz"]
                                                                              [
                                                                              index]
                                                                          [
                                                                          "studentPresent"],
                                                                    ))).then(
                                                        (value) => classBloc
                                                            .eventSink
                                                            .add(classInfo));
                                                  }),
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.check_circle_rounded,
                                              color: Colors.green[400],
                                              size: 25.w,
                                            ),
                                            Container(
                                                width: 65.w,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 3.h),
                                                child: Text(
                                                  'Completed',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                          } else if (snapshot.data["success"] == false) {
                            return Container(
                              height: 300.h,
                              width: 360.w,
                              margin: EdgeInsets.symmetric(
                                  vertical: 80.h, horizontal: 0.w),
                              child: Image.asset(
                                'assets/images/nc.png',
                                fit: BoxFit.fitHeight,
                              ),
                            );
                          }
                        }
                        return Container(
                            height: 500.h,
                            width: 360.w,
                            alignment: Alignment.center,
                            child: CircularProgressIndicator());
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
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    color: Colors.black,
                                    size: 25.w,
                                  )),
                              Container(
                                alignment: Alignment.center,
                                width: 360.w - 2 * (50.w + 16),
                                child: Text(
                                  '${widget.shortName}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.poll_rounded,
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
