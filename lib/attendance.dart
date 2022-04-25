import 'package:behere/blocs/class_bloc.dart';
import 'package:behere/blocs/user_bloc.dart';
import 'package:behere/main.dart';
import 'package:behere/models/class_info.dart';
import 'package:behere/models/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Attendance extends StatefulWidget {
  var classID;
  var student;
  var index;
  var isPresent;
  var isTeacher;
  var isProcessing;
  Attendance(this.classID, this.student, this.index, this.isPresent,
      this.isTeacher, this.isProcessing);

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  // UserInfo userInfo = UserInfo();
  // UserBloc userBloc = UserBloc();
  ClassInfo attInfo = ClassInfo();
  ClassBloc attBloc = ClassBloc();
  var isLoading = false;
  bool oldStatus = false;

  @override
  void initState() {
    super.initState();
    oldStatus = widget.isPresent;
    attInfo.actions = 'presentAbsent';
    attInfo.classID = widget.classID.toString();
    attInfo.student = widget.student;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      width: 320.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Card(
            margin: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.w))),
            child: Container(
                width: 235.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  gradient: LinearGradient(
                      colors: [appColor.lBlue, appColor.dBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.1, 0.3]),
                ),
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                child: Row(children: <Widget>[
                  Container(
                    width: 30.w,
                    child: Text('${widget.index + 1}.',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp)),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 185.w,
                        alignment: Alignment.center,
                        child: Text('${widget.student["name"]}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp)),
                      ),
                      Container(
                        width: 185.w,
                        alignment: Alignment.center,
                        child: Text('${widget.student["rollno"]}',
                            textAlign: TextAlign.center,
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
          StreamBuilder<dynamic>(
              stream: attBloc.classStream,
              builder: (ctx, loadsnap) {
                if (loadsnap.hasData) {
                  if (isLoading) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      if (widget.isPresent != oldStatus) {
                        if (mounted) {
                          setState(() {
                            // if (loadsnap.data['success']) {
                            //   if (attInfo.type == 'present') {
                            //     widget.isPresent = true;
                            //   } else if (attInfo.type == 'absent') {
                            //     widget.isPresent = false;
                            //   }
                            // }
                            isLoading = false;
                          });
                        }
                      }
                    });
                  }
                }
                return isLoading
                    ? Container(
                        width: 75.w,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 10.w),
                        child: Text(
                          'Loading...',
                          style: TextStyle(
                              color: appColor.lBlue,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800),
                        ),
                      )
                    : GestureDetector(
                        child: Container(
                          width: 75.w,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 10.w),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.w)),
                              color: widget.isPresent
                                  ? Colors.green.withOpacity(
                                      widget.isProcessing ? 0.5 : 1)
                                  : Colors.red.withOpacity(
                                      widget.isProcessing ? 0.5 : 1)),
                          child: Text(widget.isPresent ? 'Present' : 'Absent',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 10.sp)),
                        ),
                        onTap: widget.isProcessing
                            ? null
                            : widget.isTeacher
                                ? () async {
                                    if (mounted) {
                                      setState(() {
                                        isLoading = true;
                                        if (widget.isPresent) {
                                          oldStatus = true;
                                          attInfo.type = 'absent';
                                        } else {
                                          oldStatus = false;
                                          attInfo.type = 'present';
                                        }
                                      });
                                    }
                                    attBloc.eventSink.add(attInfo);
                                  }
                                : null,
                      );
              }),
        ],
      ),
    );
  }
}
