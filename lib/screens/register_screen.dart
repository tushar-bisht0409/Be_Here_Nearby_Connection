import 'package:behere/blocs/offline_bloc.dart';
import 'package:behere/blocs/user_bloc.dart';
import 'package:behere/main.dart';
import 'package:behere/models/offline_info.dart';
import 'package:behere/models/user_info.dart';
import 'package:behere/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;
  bool isVerified = false;
  var userMode = "student";
  var userData;
  var instituteName;
  var institutes;
  var instituteCode;
  List<String> collegeList = [];
  List<String> emailList = [];

  UserInfo instituteInfo = UserInfo();
  UserBloc instituteBloc = UserBloc();

  OfflineInfo offlineInfo = OfflineInfo();
  OfflineBloc offlineBloc = OfflineBloc();

  TextEditingController email = TextEditingController();

  @override
  void initState() {
    super.initState();
    instituteInfo.actions = "getInstitute";
    instituteInfo.getBy = "all";
    instituteBloc.eventSink.add(instituteInfo);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: collegeList.isEmpty
              ? ListView(
                  children: <Widget>[
                    StreamBuilder<dynamic>(
                        stream: instituteBloc.userStream,
                        builder: (ctx, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data['success']) {
                              WidgetsBinding.instance!
                                  .addPostFrameCallback((_) {
                                if (mounted) {
                                  setState(() {
                                    institutes = snapshot.data['msz'];
                                    collegeList = [];
                                    for (int i = 0;
                                        i < snapshot.data['msz'].length;
                                        i++) {
                                      collegeList.add(
                                          "${snapshot.data['msz'][i]["instituteName"]}");
                                    }
                                    // allInstitutes = snapshot.data['msz'];
                                  });
                                }
                              });
                            }
                          }
                          return Container();
                        }),
                    Container(
                        alignment: Alignment.center,
                        width: 280.w,
                        margin: EdgeInsets.only(
                            left: 40.w, right: 40.w, top: 300.h),
                        child: CircularProgressIndicator())
                  ],
                )
              : ListView(
                  children: <Widget>[
                    SizedBox(height: 20.h),
                    Container(
                      height: 150.h,
                      margin: EdgeInsets.only(top: 0.h),
                      width: 360.w,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/images/be.png',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        right: 30.w,
                        left: 30.w,
                      ),
                      child: Text(
                        'Select Your Institute',
                        style: TextStyle(
                            color: appColor.dBlue,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    collegeList.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            width: 280.w,
                            margin: EdgeInsets.symmetric(
                                horizontal: 40.w, vertical: 10.h),
                            child: Text(
                              "Loading...",
                              style: TextStyle(
                                  color: appColor.lBlue,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700),
                            ))
                        : Container(
                            alignment: Alignment.center,
                            width: 280.w,
                            margin: EdgeInsets.symmetric(
                                horizontal: 40.w, vertical: 10.h),
                            decoration: BoxDecoration(
                              color: appColor.lBlue,
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(30)),
                            ),
                            padding: EdgeInsets.all(2.w),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(30)),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                child: Center(
                                    child: DropdownButton<String>(
                                  value: instituteName,
                                  isExpanded: true,
                                  elevation: 0,
                                  icon: Icon(
                                    Icons.arrow_circle_down,
                                    color: appColor.lBlue,
                                  ),
                                  dropdownColor: appColor.wBlue,
                                  hint: Text(
                                    "Select Institute",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  style: TextStyle(color: Colors.white),
                                  underline: Container(
                                    height: 0,
                                    color: Colors.black,
                                  ),
                                  onChanged: (String? newValue) {
                                    if (mounted) {
                                      setState(() {
                                        instituteName = newValue;
                                      });
                                    }
                                  },
                                  items: collegeList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          color: appColor.lBlue,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                )))),
                    Container(
                      margin:
                          EdgeInsets.only(right: 30.w, left: 30.w, top: 40.h),
                      child: Text(
                        'You are a',
                        style: TextStyle(
                            color: appColor.dBlue,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 30.w, vertical: 0.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            TextButton(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    userMode == "student"
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: userMode == "student"
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 15.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'Student',
                                    style: TextStyle(
                                        color: appColor.dBlue,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w900),
                                  )
                                ],
                              ),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    userMode = "student";
                                  });
                                }
                              },
                            ),
                            SizedBox(
                              width: 40.w,
                            ),
                            TextButton(
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    userMode == "teacher"
                                        ? Icons.circle
                                        : Icons.circle_outlined,
                                    color: userMode == "teacher"
                                        ? Colors.green
                                        : Colors.grey,
                                    size: 15.w,
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Text(
                                    'Teacher',
                                    style: TextStyle(
                                        color: appColor.dBlue,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w900),
                                  )
                                ],
                              ),
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    userMode = "teacher";
                                  });
                                }
                              },
                            )
                          ],
                        )),
                    Container(
                      margin:
                          EdgeInsets.only(right: 30.w, left: 30.w, top: 40.h),
                      child: Text(
                        'Enter Your Institute Email',
                        style: TextStyle(
                            color: appColor.dBlue,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400),
                      ),
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
                                  colors: [appColor.lBlue, appColor.dBlue]),
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setWidth(30)),
                            ),
                            padding: EdgeInsets.all(2.w),
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      ScreenUtil().setWidth(30)),
                                  color: Colors.white,
                                ),
                                child: Center(
                                    child: TextField(
                                  controller: email,
                                  // onChanged: (value) {
                                  //   showCode();
                                  // },
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30.w),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30.w),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30.w),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30.w),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30.w),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(30.w),
                                    ),
                                    contentPadding: EdgeInsets.only(left: 20.w),
                                    hintText: "Email",
                                    // fillColor: Colors.transparent[100],
                                    focusColor: Colors.grey[400],
                                    hintStyle:
                                        TextStyle(color: Colors.grey[400]),
                                  ),
                                  style: TextStyle(color: Colors.black),
                                  keyboardType: TextInputType.text,
                                ))))),
                    Padding(
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
                              color: Colors.blue[800],
                            ),
                            child: Center(
                                child: isLoading
                                    ? LinearProgressIndicator()
                                    : TextButton(
                                        child: Text(
                                          "Proceed",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp),
                                        ),
                                        onPressed: () {
                                          if (mounted) {
                                            setState(() {
                                              institutes.forEach((element) {
                                                if (element['instituteName'] ==
                                                    instituteName) {
                                                  instituteCode =
                                                      element['instituteCode'];
                                                }
                                              });
                                              if (email.text.trim() == "" ||
                                                  email.text.contains("@") ==
                                                      false) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    'Please type a valid email',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor: Colors.blue,
                                                ));
                                              } else if (instituteName ==
                                                  null) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                    'Please select your Institute',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  backgroundColor: Colors.blue,
                                                ));
                                              } else {
                                                isLoading = true;
                                                isVerified = false;
                                                offlineInfo.actions =
                                                    "download";
                                                offlineInfo.getBy =
                                                    "instituteCode";
                                                if (userMode == "student") {
                                                  offlineInfo.type =
                                                      "studentList";
                                                } else {
                                                  offlineInfo.type =
                                                      "teacherList";
                                                }
                                                offlineInfo.instituteCode =
                                                    instituteCode;
                                                offlineBloc.eventSink
                                                    .add(offlineInfo);
                                              }
                                              //                               if (email.text.contains("@") == false) {
                                              //   return snackBar("Type a valid Email.");
                                              // } else if (authMode == AuthMode.signup &&
                                              //     confirmPassword.text != password.text) {
                                              //   confirmPassword.text = "";
                                              //   return snackBar("Password not confirmed.");
                                              // } else if (password.text.trim() == "") {
                                              //   return snackBar("Password can't be Empty.");
                                              // } else {
                                              //   if (authMode == AuthMode.signup) {
                                              //     userInfo.actions = "UserExist";
                                              //     authBloc.eventSink.add(userInfo);
                                              //   } else if (authMode == AuthMode.login) {
                                              //     authBloc.eventSink.add(userInfo);
                                              //   }
                                              // }
                                            });
                                          }
                                        },
                                      )))),
                    StreamBuilder<dynamic>(
                        stream: offlineBloc.offlineStream,
                        builder: (ctx, ss) {
                          if (isLoading) {
                            if (ss.hasData) {
                              if (ss.data['success']) {
                                WidgetsBinding.instance!
                                    .addPostFrameCallback((_) {
                                  if (mounted) {
                                    setState(() {
                                      if (userMode == "student") {
                                        if (ss.data['msz'][0]['studentList'] !=
                                            null) {
                                          ss.data['msz'][0]['studentList']
                                              .forEach((element) {
                                            if (element['email'] ==
                                                email.text.trim()) {
                                              userData = element;
                                              isVerified = true;
                                            }
                                            if (isVerified) {
                                              isVerified = false;
                                              isLoading = false;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          OTPScreen(
                                                              email.text.trim(),
                                                              instituteCode,
                                                              instituteName,
                                                              userData,
                                                              userMode)));
                                            } else {
                                              if (isLoading) {
                                                isLoading = false;
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  useRootNavigator: true,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    title: Text(
                                                      'Cannot Verify You!',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.lightBlue),
                                                    ),
                                                    content: Text(
                                                      "You are not registered as a student of $instituteName.",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                          'Ok',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          });
                                        }
                                      } else {
                                        if (ss.data['msz'][0]['teacherList'] !=
                                            null) {
                                          ss.data['msz'][0]['teacherList']
                                              .forEach((element) {
                                            if (element['email'] ==
                                                email.text.trim()) {
                                              userData = element;
                                              isVerified = true;
                                            }
                                            if (isVerified) {
                                              isVerified = false;
                                              isLoading = false;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (builder) =>
                                                          OTPScreen(
                                                              email.text.trim(),
                                                              instituteCode,
                                                              instituteName,
                                                              userData,
                                                              userMode)));
                                            } else {
                                              if (isLoading) {
                                                isLoading = false;
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  useRootNavigator: true,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        Colors.white,
                                                    title: Text(
                                                      'Cannot Verify You!',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.lightBlue),
                                                    ),
                                                    content: Text(
                                                      "You are not registered as a teacher of $instituteName.",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text(
                                                          'Ok',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }
                                            }
                                          });
                                        }
                                      }
                                    });
                                  }
                                });
                              }
                            }
                          }
                          return Container();
                        })
                  ],
                )),
    );
  }
}
