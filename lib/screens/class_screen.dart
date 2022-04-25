import 'package:behere/attendance.dart';
import 'package:behere/blocs/class_bloc.dart';
import 'package:behere/main.dart';
import 'package:behere/models/class_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';

class ClassScreen extends StatefulWidget {
  var classID;
  var subjectID;
  var shortName;
  var subjectName;
  var trade;
  var batch;
  var section;
  var timing;
  var students;
  var student;
  var studentPresent;
  ClassScreen(
      this.classID,
      this.subjectID,
      this.shortName,
      this.subjectName,
      this.trade,
      this.batch,
      this.section,
      this.timing,
      this.students,
      this.student,
      this.studentPresent);
  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  var classStatus = '';
  var studentIDs = [];
  var studentPresent = [];

  ClassInfo attInfo = ClassInfo();
  ClassBloc attBloc = ClassBloc();

  @override
  void initState() {
    super.initState();
    studentPresent = widget.studentPresent;
    attInfo.actions = 'getClass';
    attInfo.getBy = 'classID';
    attInfo.classID = widget.classID;
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
                  Container(
                    width: 320.w,
                    margin:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      gradient: LinearGradient(
                          colors: [appColor.lBlue, appColor.dBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.1, 0.3]),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 320.w,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: 10.w, top: 25.h, right: 10.w, bottom: 5.h),
                          child: Text(
                            '${widget.shortName} (${widget.subjectName})',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          width: 320.w,
                          margin: EdgeInsets.only(
                              left: 10.w, right: 10.w, top: 5.h, bottom: 5.h),
                          child: Text(
                            '${widget.trade}, Section ${widget.section} (${widget.batch})',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 10.sp, color: Colors.white),
                          ),
                        ),
                        Container(
                          width: 320.w,
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                              left: 10.w, top: 5.h, right: 10.w, bottom: 25.h),
                          child: Text(
                            '${widget.timing}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    height: 1.h,
                    width: 360.w,
                    color: appColor.wBlue,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.h, horizontal: 20.w),
                      child: Column(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: 100.w,
                              alignment: Alignment.center,
                              child: RichText(
                                  text: TextSpan(
                                      text: 'Strength: ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.sp),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: '${widget.students.length}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w800))
                                  ])),
                            ),
                            Container(
                              width: 100.w,
                              alignment: Alignment.center,
                              child: RichText(
                                  text: TextSpan(
                                      text: 'Present: ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.sp),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: studentPresent.isEmpty
                                            ? '0'
                                            : '${studentPresent.length}',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w800))
                                  ])),
                            ),
                            Container(
                              width: 100.w,
                              alignment: Alignment.center,
                              child: RichText(
                                  text: TextSpan(
                                      text: 'Absent: ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.sp),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: studentPresent.isEmpty
                                            ? '${widget.students.length}'
                                            : '${widget.students.length - studentPresent.length}',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w800))
                                  ])),
                            )
                          ],
                        ),
                        myMode == "teacher"
                            ? SizedBox()
                            : Container(
                                margin: EdgeInsets.only(top: 10.h),
                                width: 120.w,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.w)),
                                    color: widget.studentPresent.indexWhere(
                                                (element) =>
                                                    element['rollno'] ==
                                                    widget.student['rollno']) !=
                                            -1
                                        ? Colors.green
                                        : Colors.red),
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 4.h, horizontal: 5.w),
                                child: RichText(
                                    text: TextSpan(
                                  text: widget.studentPresent.indexWhere(
                                              (element) =>
                                                  element['rollno'] ==
                                                  widget.student['rollno']) !=
                                          -1
                                      ? 'You are Present!'
                                      : 'You are Absent!',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w800),
                                )),
                              )
                      ])),
                  Container(
                    height: 1.h,
                    width: 360.w,
                    color: appColor.wBlue,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  StreamBuilder<dynamic>(
                      stream: attBloc.classStream,
                      builder: (ctx, ats) {
                        attBloc.eventSink.add(attInfo);
                        if (ats.hasData) {
                          if (ats.data['success']) {
                            WidgetsBinding.instance!.addPostFrameCallback((_) {
                              if (mounted) {
                                setState(() {
                                  studentPresent =
                                      ats.data['msz'][0]['studentPresent'];
                                });
                              }
                            });
                            return ListView.builder(
                                itemCount: widget.students.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (ctx, index) {
                                  WidgetsBinding.instance!
                                      .addPostFrameCallback((_) {
                                    if (mounted) {
                                      setState(() {
                                        studentPresent = ats.data['msz'][0]
                                            ['studentPresent'];
                                      });
                                    }
                                  });
                                  var isP = false;
                                  var isTeacher = false;
                                  int ind = studentPresent.indexWhere(
                                      (element) =>
                                          element['rollno'] ==
                                          widget.students[index]['rollno']);

                                  if (ind == -1) {
                                    isP = false;
                                  } else {
                                    isP = true;
                                  }
                                  if (myMode == "teacher") {
                                    isTeacher = true;
                                  }
                                  return Attendance(
                                      widget.classID,
                                      widget.students[index],
                                      index,
                                      isP,
                                      isTeacher,
                                      false);
                                });
                          }
                        }
                        return Container(
                          padding: EdgeInsets.only(top: 100.h),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        );
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
