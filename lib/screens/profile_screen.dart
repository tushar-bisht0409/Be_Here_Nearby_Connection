import 'package:behere/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userMode = "student";
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
                children: <Widget>[
                  SizedBox(height: 50.w + 20.h),
                  Card(
                      elevation: 10,
                      margin: EdgeInsets.symmetric(
                          vertical: 20.h, horizontal: 20.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                      ),
                      child: Container(
                        width: 320.w,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.w)),
                            color: Colors.white),
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [appColor.dBlue, appColor.lBlue],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.w),
                                      topRight: Radius.circular(20.w))),
                              child: Text(
                                '${myMode.toUpperCase()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 25.w),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      // width: 100.w,
                                      child: Text(
                                    'Name:',
                                    style: TextStyle(
                                        color: appColor.dBlue,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w800),
                                  )),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Container(
                                      width: 200.w,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '$myName',
                                        style: TextStyle(
                                            color: appColor.dBlue,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 25.w),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      // width: 100.w,
                                      child: Text(
                                    'Email:',
                                    style: TextStyle(
                                        color: appColor.dBlue,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w800),
                                  )),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Container(
                                      width: 200.w,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '$myEmail',
                                        style: TextStyle(
                                            color: appColor.dBlue,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                            ),
                            myMode == "teacher"
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 25.w),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            // width: 100.w,
                                            child: Text(
                                          'ID:',
                                          style: TextStyle(
                                              color: appColor.dBlue,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w800),
                                        )),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                            width: 200.w,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '$myID',
                                              style: TextStyle(
                                                  color: appColor.dBlue,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 25.w),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                      // width: 100.w,
                                      child: Text(
                                    'Institute:',
                                    style: TextStyle(
                                        color: appColor.dBlue,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w800),
                                  )),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Container(
                                      width: 200.w,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '$myInstitute',
                                        style: TextStyle(
                                            color: appColor.dBlue,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                            ),
                            myMode == 'teacher'
                                ? SizedBox()
                                : Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 25.w),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            // width: 100.w,
                                            child: Text(
                                          'Roll No:',
                                          style: TextStyle(
                                              color: appColor.dBlue,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w800),
                                        )),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                            width: 200.w,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '$myRollno',
                                              style: TextStyle(
                                                  color: appColor.dBlue,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ],
                                    ),
                                  ),
                            myMode == 'teacher'
                                ? SizedBox()
                                : Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 5.h, horizontal: 25.w),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                            // width: 100.w,
                                            child: Text(
                                          'Course:',
                                          style: TextStyle(
                                              color: appColor.dBlue,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w800),
                                        )),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Container(
                                            width: 200.w,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              '$myCourse, $myBranch ($myBatch), Section $mySection',
                                              style: TextStyle(
                                                  color: appColor.dBlue,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ],
                                    ),
                                  ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [appColor.dBlue, appColor.lBlue],
                                  ),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20.w),
                                      bottomRight: Radius.circular(20.w))),
                            ),
                          ],
                        ),
                      )),
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
                                  'My Profile',
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
