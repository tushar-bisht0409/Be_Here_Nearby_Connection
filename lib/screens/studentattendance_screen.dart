import 'package:behere/blocs/class_bloc.dart';
import 'package:behere/main.dart';
import 'package:behere/models/class_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class StudentAttendanceScreen extends StatefulWidget {
  var shortName;
  var subjectName;
  var branch;
  var section;
  var batch;
  var student;
  var classes;

  StudentAttendanceScreen(this.shortName, this.subjectName, this.branch,
      this.section, this.batch, this.student, this.classes);

  @override
  _StudentAttendanceScreenState createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  var presentCount = 0;
  var classCount = 0;
  var absentCount = 0;
  var attPercent = 0.00;

  attendancePercent() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          presentCount = 0;
          classCount = 0;
          absentCount = 0;
          attPercent = 0.00;
          classCount = widget.classes.length;
          for (int i = 0; i < widget.classes.length; i++) {
            int indx = widget.classes[i]['studentPresent'].indexWhere(
                (element) => element['rollno'] == widget.student['rollno']);
            if (indx != -1) {
              presentCount++;
            } else {
              absentCount++;
            }
          }
          attPercent = (presentCount / classCount) * 100;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    attendancePercent();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: <Widget>[
              ListView(
                //    physics: BouncingScrollPhysics(),
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
                                  child: Text('My Attendance Report',
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
                                      text: 'Total: ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.sp),
                                      children: <TextSpan>[
                                    TextSpan(
                                        text: '$classCount',
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
                                        text: '$presentCount',
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
                                        text: '$absentCount',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w800))
                                  ])),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                          width: 80.w,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.w)),
                              color: attPercent >= 75.00
                                  ? Colors.green
                                  : Colors.red),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 5.w),
                          child: RichText(
                              text: TextSpan(
                            text: '${attPercent.toStringAsFixed(2)}%',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
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
                  ListView.builder(
                      itemCount: widget.classes.length,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        String attendance = 'Absent';
                        int indx = widget.classes[index]['studentPresent']
                            .indexWhere((element) =>
                                element['rollno'] == widget.student['rollno']);
                        if (indx != -1) {
                          attendance = 'Present';
                        }
                        var tsData = DateTime.fromMillisecondsSinceEpoch(
                            int.parse(widget.classes[index]["classID"]));
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
                          width: 320.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.w))),
                                child: Container(
                                    width: 235.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.w)),
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
                                        vertical: 5.h, horizontal: 10.w),
                                    child: Row(children: <Widget>[
                                      Container(
                                        width: 215.w,
                                        alignment: Alignment.center,
                                        child: Text(timing,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.sp)),
                                      ),
                                    ])),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                width: 75.w,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h, horizontal: 10.w),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.w)),
                                    color: attendance == "Present"
                                        ? Colors.green
                                        : Colors.red),
                                child: Text(
                                    attendance == "Present"
                                        ? 'Present'
                                        : 'Absent',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10.sp)),
                              ),
                            ],
                          ),
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
