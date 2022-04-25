import 'package:behere/blocs/subject_bloc.dart';
import 'package:behere/main.dart';
import 'package:behere/models/subject_info.dart';
import 'package:behere/studentattendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ClassAttendanceScreen extends StatefulWidget {
  var shortName;
  var subjectName;
  var branch;
  var section;
  var batch;
  var students;
  var classes;

  ClassAttendanceScreen(this.shortName, this.subjectName, this.branch,
      this.section, this.batch, this.students, this.classes);
  @override
  _ClassAttendanceScreenState createState() => _ClassAttendanceScreenState();
}

class _ClassAttendanceScreenState extends State<ClassAttendanceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: <Widget>[
              ListView(
                shrinkWrap: true,
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
                            '${widget.shortName}(${widget.subjectName})',
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
                            '${widget.branch}, Section ${widget.section} (${widget.batch})',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 10.sp, color: Colors.white),
                          ),
                        ),
                        Container(
                          width: 320.w,
                          margin: EdgeInsets.only(
                              left: 10.w, right: 10.w, top: 10.h, bottom: 25.h),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.poll_outlined,
                                  color: Colors.lightBlue[300],
                                  size: 30.w,
                                ),
                                Container(
                                  // width: 155.w,
                                  padding: EdgeInsets.only(left: 5.w),
                                  child: Text('Attendance Report',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w800)),
                                )
                              ]),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  ListView.builder(
                      itemCount: widget.students.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return StudentAttendance(
                            index, widget.students[index], widget.classes);
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
