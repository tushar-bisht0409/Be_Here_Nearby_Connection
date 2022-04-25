import 'package:behere/blocs/user_bloc.dart';
import 'package:behere/main.dart';
import 'package:behere/models/user_info.dart';
import 'package:behere/screens/register_screen.dart';
import 'package:behere/screens/studentcourse_screen.dart';
import 'package:behere/screens/teachercourse_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isData = false;
  UserInfo userInfo = UserInfo();
  UserBloc userBloc = UserBloc();
  bool isComplete = false;

  savedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        // userID = prefs.getString('userID').toString();
        myEmail = prefs.getString('email').toString();
        myName = prefs.getString('name').toString();
        myRollno = prefs.getString('rollno').toString();
        myBatch = prefs.getString('batch').toString();
        myBranch = prefs.getString('branch').toString();
        mySection = prefs.getString('section').toString();
        myID = prefs.getString('id').toString();
        myMode = prefs.getString('userMode').toString();
        myCourse = prefs.getString('course').toString();
        myInstitute = prefs.getString('institute').toString();
        isData = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    savedData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return isData
        ? myEmail == null || myEmail == "null"
            ? RegisterScreen()
            : myMode == "student"
                ? StudentCourseScreen('', '')
                : TeacherCourseScreen('', '', '')
        : SafeArea(
            child: Scaffold(
            backgroundColor: Colors.white,
            body: StreamBuilder(
              builder: (ctx, snapShot) {
                return Container(
                  margin: EdgeInsets.only(
                      top: 345.h - 200.w, left: 30.w, right: 30.w),
                  height: 300.w,
                  width: 300.w,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/be.png',
                    fit: BoxFit.fitHeight,
                  ),
                );
              },
            ),
          ));
    // isData
    //     ? userID == null || userID == "null"
    //         ? AuthScreen()
    //         : SafeArea(
    //             child: Scaffold(
    //                 backgroundColor: Colors.white,
    //                 body: StreamBuilder<dynamic>(
    //                     stream: userBloc.userStream,
    //                     builder: (ctx, snapshot) {
    //                       userInfo.actions = "getUserInfo";
    //                       userInfo.userID = userID;
    //                       userBloc.eventSink.add(userInfo);
    //                       if (snapshot.hasData) {
    //                         if (snapshot.data["success"]) {
    //                           if (isComplete == false) {
    //                             if (snapshot.data["msz"][0]["mode"] ==
    //                                 "student") {
    //                               WidgetsBinding.instance!
    //                                   .addPostFrameCallback((_) {
    //                                 if (mounted) {
    //                                   setState(() {
    //                                     isComplete = true;
    //                                     // rollNo =
    //                                     //     snapshot.data["msz"][0]["rollNo"];
    //                                   });
    //                                 }
    //                                 Navigator.pushReplacement(
    //                                     context,
    //                                     MaterialPageRoute(
    //                                         builder: (builder) =>
    //                                             StudentCourseScreen(
    //                                                 snapshot.data["msz"][0],
    //                                                 "splash")));
    //                               });
    //                             } else if (snapshot.data["msz"][0]["mode"] ==
    //                                 "teacher") {
    //                               WidgetsBinding.instance!
    //                                   .addPostFrameCallback((_) {
    //                                 if (mounted) {
    //                                   setState(() {
    //                                     isComplete = true;
    //                                   });
    //                                 }
    //                                 Navigator.pushReplacement(
    //                                     context,
    //                                     MaterialPageRoute(
    //                                         builder: (builder) =>
    //                                             TeacherCourseScreen(
    //                                                 snapshot.data["msz"][0]
    //                                                     ["institute"],
    //                                                 snapshot.data["msz"][0]
    //                                                     ["instituteCode"],
    //                                                 snapshot.data["msz"][0]
    //                                                     ["name"])));
    //                               });
    //                             }
    //                           }
    //                         }
    //                       }
    //                       return Container(
    //                         margin: EdgeInsets.only(
    //                             top: 345.h - 200.w, left: 30.w, right: 30.w),
    //                         height: 300.w,
    //                         width: 300.w,
    //                         alignment: Alignment.center,
    //                         child: Image.asset(
    //                           'assets/images/be.png',
    //                           fit: BoxFit.fitHeight,
    //                         ),
    //                       );
    //                     })))
    //     : SafeArea(
    //         child: Scaffold(
    //         backgroundColor: Colors.white,
    //         body: StreamBuilder(
    //           builder: (ctx, snapShot) {
    //             return Container(
    //               margin: EdgeInsets.only(
    //                   top: 345.h - 200.w, left: 30.w, right: 30.w),
    //               height: 300.w,
    //               width: 300.w,
    //               alignment: Alignment.center,
    //               child: Image.asset(
    //                 'assets/images/be.png',
    //                 fit: BoxFit.fitHeight,
    //               ),
    //             );
    //           },
    //         ),
    //       ));
  }
}
