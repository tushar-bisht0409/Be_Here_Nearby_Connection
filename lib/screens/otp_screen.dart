import 'dart:convert';
import 'dart:io';

import 'package:behere/blocs/auth_bloc.dart';
import 'package:behere/blocs/offline_bloc.dart';
import 'package:behere/blocs/otp_bloc.dart';
import 'package:behere/blocs/user_bloc.dart';
import 'package:behere/main.dart';
import 'package:behere/models/offline_info.dart';
import 'package:behere/models/user_info.dart';
import 'package:behere/screens/splash_screen.dart';
import 'package:behere/screens/studentcourse_screen.dart';
import 'package:behere/screens/teachercourse_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
  var email;
  var instituteCode;
  var institute;
  var userData;
  var userMode;
  // var password;
  // var isForgot;
  // OTPScreen(this.email, this.password, this.isForgot);
  OTPScreen(this.email, this.instituteCode, this.institute, this.userData,
      this.userMode);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otp = TextEditingController();
  UserInfo otpInfo = UserInfo();
  OTPBloc otpBloc = OTPBloc();
  UserInfo userInfo = UserInfo();
  var newOTP;
  var oldOTP;
  bool isOTP = false;
  bool isLoading = false;
  bool isSignedUp = false;
  bool isVerified = false;
  bool isCompleted = false;

  OfflineInfo offlineInfo1 = OfflineInfo();
  OfflineBloc offlineBloc1 = OfflineBloc();

  // OfflineInfo offlineInfo2 = OfflineInfo();
  // OfflineBloc offlineBloc2 = OfflineBloc();

  // OfflineInfo offlineInfo3 = OfflineInfo();
  // OfflineBloc offlineBloc3 = OfflineBloc();

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userMode', widget.userMode);
    await prefs.setString('email', widget.email);
    await prefs.setString('name', widget.userData['name']);
    await prefs.setString('institute', widget.institute);
    if (widget.userMode == "student") {
      await prefs.setString('rollno', widget.userData['rollno']);
      await prefs.setString('branch', widget.userData['branch']);
      await prefs.setString('batch', widget.userData['batch']);
      await prefs.setString('section', widget.userData['section']);
      await prefs.setString('course', widget.userData['course']);
      await prefs.setString('id', '');
    } else {
      await prefs.setString('id', widget.userData['id']);
      await prefs.setString('rollno', '');
      await prefs.setString('branch', '');
      await prefs.setString('batch', '');
      await prefs.setString('section', '');
    }
  }

  Future<void> createFile(var ll) async {
    var dd;
    await getApplicationDocumentsDirectory().then((value) {
      if (mounted) {
        setState(() {
          dd = value.path;
        });
      }
    });
    var nn = 'behere.txt';
    File(dd + '/' + nn).create(recursive: true).then((file) async {
      file.writeAsString(jsonEncode(ll)).then(
          (value) => print(value.readAsString().then((value) => print(value))));
    });
  }

  readFile() async {
    var dd;
    var lists;
    await getApplicationDocumentsDirectory().then((value) {
      if (mounted) {
        setState(() {
          dd = value.path;
        });
      }
    });
    var nn = 'behere.txt';
    lists = jsonDecode(await File(dd + '/' + nn).readAsString());
    print(lists[0]);
    lists.forEach((element) {
      if (element['name'] == "Aayush Aggarwal") {
        print(element);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    userInfo.actions = "SignUp";
    userInfo.email = widget.email;
    // userInfo.password = widget.password;
    otpInfo.actions = "createOTP";
    otpInfo.email = widget.email;
    // if (widget.isForgot) {
    //   otpInfo.type = "forgot";
    // } else {
    //   otpInfo.type = "signup";
    // }
    otpInfo.type = "signup";
    otpBloc.eventSink.add(otpInfo);

    offlineInfo1.actions = "download";
    offlineInfo1.getBy = "instituteCode";
    offlineInfo1.type = "subjectList";
    offlineInfo1.instituteCode = widget.instituteCode;

    // offlineInfo2.actions = "download";
    // offlineInfo2.getBy = "instituteCode";
    // offlineInfo2.type = "studentList";
    // offlineInfo2.instituteCode = widget.instituteCode;

    // offlineInfo3.actions = "download";
    // offlineInfo3.getBy = "instituteCode";
    // offlineInfo3.type = "teacherList";
    // offlineInfo3.instituteCode = widget.instituteCode;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(children: <Widget>[
              isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: <Widget>[
                        SizedBox(height: 50.w + 20.h),
                        StreamBuilder<dynamic>(
                            stream: otpBloc.otpStream,
                            builder: (ctx, snapshot) {
                              if (snapshot.hasData) {
                                if (snapshot.data['success']) {
                                  if (isOTP == false) {
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback((_) {
                                      if (mounted) {
                                        setState(() {
                                          if (oldOTP != snapshot.data['otp']) {
                                            isOTP = true;
                                            newOTP = snapshot.data['otp'];
                                          }
                                        });
                                      }
                                    });
                                  }
                                }
                              }
                              return Container();
                            }),
                        // Container(
                        //   height: 100.h,
                        // ),
                        Container(
                          height: 250.h,
                          margin: EdgeInsets.only(top: 0.h),
                          width: 360.w,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/be.png',
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 40.w),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'An OTP is sent to ${widget.email}. It might be in your spam emails. OTP is valid for 10 minutes.',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w800),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                                right: ScreenUtil().setWidth(40),
                                left: ScreenUtil().setWidth(40)),
                            child: Container(
                                alignment: Alignment.center,
                                width: ScreenUtil().setWidth(280),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [Colors.blue, appColor.lBlue]),
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(10)),
                                ),
                                padding: EdgeInsets.all(2.w),
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(10)),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                        child: TextField(
                                      textAlign: TextAlign.center,
                                      maxLength: 6,
                                      controller: otp,
                                      decoration: InputDecoration(
                                        counterText: '',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(10.w),
                                        ),
                                        hintText: "OTP",
                                        // fillColor: Colors.transparent[100],
                                        focusColor: Colors.grey[400],
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400]),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 22.sp),
                                      keyboardType: TextInputType.number,
                                    ))))),
                        StreamBuilder(builder: (ctx, bsnap) {
                          return GestureDetector(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(40),
                                    right: ScreenUtil().setWidth(115),
                                    left: ScreenUtil().setWidth(115)),
                                child: Container(
                                    alignment: Alignment.center,
                                    width: 100.sp,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          ScreenUtil().setWidth(30)),
                                      color: isOTP == false
                                          ? Colors.grey
                                          : Colors.blue[800],
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Center(
                                      child: Text(
                                        isOTP == false
                                            ? "Sending OTP"
                                            : "Verify",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp),
                                      ),
                                    ))),
                            onTap: isOTP == false
                                ? null
                                : () async {
                                    if (otp.text == newOTP.toString()) {
                                      if (mounted) {
                                        setState(() {
                                          isLoading = true;
                                          isVerified = true;
                                          isCompleted = true;
                                          // if (widget.isForgot) {
                                          //   Navigator.pushReplacement(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (builder) =>
                                          //               ChangePasswordScreen(
                                          //                   widget.email)));
                                          // } else {
                                          //   Navigator.pushReplacement(
                                          //       context,
                                          //       MaterialPageRoute(
                                          //           builder: (builder) =>
                                          //               UserInfoScreen(
                                          //                   widget.email,
                                          //                   widget
                                          //                       .password)));
                                          // }
                                        });
                                      }
                                      offlineBloc1.eventSink.add(offlineInfo1);
                                    } else {
                                      otp.text = "";
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.redAccent,
                                              content: Text(
                                                "Wrong OTP",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              )));
                                    }
                                  },
                          );
                        }),
                        Padding(
                            padding: EdgeInsets.only(
                                top: ScreenUtil().setHeight(10),
                                right: ScreenUtil().setWidth(115),
                                left: ScreenUtil().setWidth(115)),
                            child: Container(
                                alignment: Alignment.center,
                                width: 100.sp,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(30)),
                                  //     color: isOTP == false ? Colors.grey : Colors.blue,
                                ),
                                child: Center(
                                    child: TextButton(
                                  child: Text(
                                    isOTP == false ? "" : "Resend OTP",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12.sp),
                                  ),
                                  onPressed: isOTP == false
                                      ? null
                                      : () {
                                          print('resend');
                                          if (mounted) {
                                            setState(() {
                                              oldOTP = newOTP;
                                              isOTP = false;
                                              otpBloc.eventSink.add(otpInfo);
                                            });
                                          }
                                        },
                                ))))
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
                                  'Verification',
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
                      ))),
              // StreamBuilder<dynamic>(
              //     stream: authBloc.authStream,
              //     builder: (ctx, authsnap) {
              //       if (authsnap.hasData) {
              //         print(authsnap.data);
              //         if (authsnap.data["success"]) {
              //           WidgetsBinding.instance!.addPostFrameCallback((_) {
              //             if (mounted) {
              //               setState(() {
              //                 isSignedUp = true;
              //                 isLoading = false;
              //                 print("yoo");
              //               });
              //             }
              //           });
              //         } else {
              //           WidgetsBinding.instance!.addPostFrameCallback((_) {
              //             if (mounted) {
              //               setState(() {
              //                 isLoading = false;
              //               });
              //             }
              //           });
              //         }
              //       }
              //       return SizedBox();
              //     }),
              StreamBuilder<dynamic>(
                  stream: offlineBloc1.offlineStream,
                  builder: (ctx, ss) {
                    if (isLoading) {
                      if (ss.hasData) {
                        if (ss.data['success']) {
                          WidgetsBinding.instance!
                              .addPostFrameCallback((_) async {
                            if (isCompleted) {
                              if (mounted) {
                                setState(() {
                                  isCompleted = false;
                                });
                              }
                              await createFile(ss.data['msz'][0]['subjectList'])
                                  .then((value) async {
                                await saveData().then((value) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (builder) =>
                                              SplashScreen()));
                                });
                              });
                            }
                          });
                        }
                      }
                    }
                    return Container();
                  })
            ])));
  }
}
