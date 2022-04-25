import 'package:behere/blocs/class_bloc.dart';
import 'package:behere/main.dart';
import 'package:behere/models/class_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class StudentAttendance extends StatefulWidget {
  int index;
  var studentInfo;
  var classes;
  StudentAttendance(this.index, this.studentInfo, this.classes);
  @override
  _StudentAttendanceState createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  var attPercent;
  bool isExpanded = false;

  calculateAttPercent() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          if (widget.classes.length != 0) {
            var pCount = 0;
            for (int i = 0; i < widget.classes.length; i++) {
              int indx = widget.classes[i]['studentPresent'].indexWhere(
                  (element) =>
                      element['rollno'] == widget.studentInfo['rollno']);
              if (indx != -1) {
                pCount++;
              }
            }
            attPercent = (pCount / widget.classes.length) * 100;
          } else {
            attPercent = 0.00;
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    calculateAttPercent();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
        width: 320.w,
        child: Column(
          children: <Widget>[
            Row(
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
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
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
                              width: 155.w,
                              alignment: Alignment.center,
                              child: Text('${widget.studentInfo['name']}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.sp)),
                            ),
                            Container(
                              width: 155.w,
                              alignment: Alignment.center,
                              child: Text('${widget.studentInfo['rollno']}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.sp)),
                            ),
                          ],
                        ),
                        Container(
                            alignment: Alignment.center,
                            width: 30.w,
                            child: IconButton(
                                alignment: Alignment.center,
                                constraints: BoxConstraints(maxHeight: 30.w),
                                onPressed: () {
                                  if (mounted) {
                                    setState(() {
                                      if (isExpanded) {
                                        isExpanded = false;
                                      } else {
                                        isExpanded = true;
                                      }
                                    });
                                  }
                                },
                                icon: FaIcon(
                                  isExpanded
                                      ? FontAwesomeIcons.angleDown
                                      : FontAwesomeIcons.angleRight,
                                  size: 15.w,
                                  color: Colors.white,
                                ))),
                      ])),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Container(
                  width: 75.w,
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.w)),
                      color: Colors.lightBlue),
                  child: Text(
                      attPercent == null
                          ? '0%'
                          : '${attPercent.toStringAsFixed(2)}%',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 10.sp)),
                ),
              ],
            ),
            isExpanded
                ? Container(
                    width: 320.w,
                    height: 2 * (10.h + 12.sp + 10.h),
                    margin: EdgeInsets.only(top: 10.h),
                    child: StreamBuilder<dynamic>(builder: (ctx, snapshot) {
                      if (attPercent == null) {
                        calculateAttPercent();
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.classes.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (ctx, ind) {
                            String attendance = 'A';
                            int indx = widget.classes[ind]['studentPresent']
                                .indexWhere((element) =>
                                    element['rollno'] ==
                                    widget.studentInfo['rollno']);
                            if (indx != -1) {
                              attendance = 'P';
                            }
                            var tsData = DateTime.fromMillisecondsSinceEpoch(
                                int.parse(widget.classes[ind]["classID"]));
                            var timing =
                                "${DateFormat('dd/MM/yy').format(tsData)}";
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 10.h + 12.sp,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 5.w),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.h, horizontal: 5.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.w)),
                                      color: appColor.wBlue),
                                  child: Text(
                                    timing,
                                    style: TextStyle(
                                        fontSize: 10.sp, color: Colors.blue),
                                  ),
                                ),
                                Container(
                                    height: 10.h + 12.sp,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 5.w),
                                    child: CircleAvatar(
                                      radius: (10.h + 12.sp) / 2,
                                      backgroundColor: attendance == 'A'
                                          ? Colors.red
                                          : Colors.green,
                                      child: Center(
                                          child: Text(
                                        attendance,
                                        style: TextStyle(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white),
                                      )),
                                    )),
                              ],
                            );
                          });
                    }),
                  )
                : SizedBox()
          ],
        ));
  }
}
