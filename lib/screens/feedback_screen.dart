import 'package:behere/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:behere/blocs/user_bloc.dart';
import 'package:behere/models/user_info.dart';

class FeedBackScreen extends StatefulWidget {
  static const routeName = '/feedback';
  @override
  _FeedBackScreenState createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  TextEditingController feedback = TextEditingController();
  UserInfo userInfo = UserInfo();
  UserBloc userBloc = UserBloc();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          StreamBuilder<dynamic>(
              stream: userBloc.userStream,
              builder: (ctx, snapshot) {
                if (isLoading) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          isLoading = false;
                          feedback.text = "";
                        });
                      }
                    });
                    if (snapshot.data['success']) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Feedback Sent Successfully",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.blue,
                            ));
                          });
                        }
                      });
                    } else if (snapshot.data['success'] == false) {
                      WidgetsBinding.instance!.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Failed to send feedback.",
                                style: TextStyle(color: Colors.white),
                              ),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.redAccent,
                            ));
                          });
                        }
                      });
                    }
                  }
                }
                return Container();
              }),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20.h,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                Container(
                    alignment: Alignment.topCenter,
                    //  margin: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 15.w),
                    height: 70.h,
                    color: Colors.transparent,
                    child: Text(
                      "Feedback",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600),
                    )),
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20.h,
                      color: Colors.transparent,
                    ),
                    onPressed: () {}),
              ]),
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
                        colors: [appColor.lBlue, appColor.dBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 0.3]),
                    borderRadius:
                        BorderRadius.circular(ScreenUtil().setWidth(30)),
                  ),
                  padding: EdgeInsets.all(2.w),
                  child: Container(
                      height: 200.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.w),
                        color: Colors.white,
                      ),
                      child: TextField(
                        maxLines: null,
                        controller: feedback,
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
                          contentPadding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 15.h, bottom: 15.h),
                          hintText: "FeedBack",

                          // fillColor: Colors.transparent[100],
                          focusColor: Colors.grey[400],
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                      )))),
          Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(40),
                  right: ScreenUtil().setWidth(115),
                  left: ScreenUtil().setWidth(115)),
              child: isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      alignment: Alignment.center,
                      width: ScreenUtil().setWidth(80),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(ScreenUtil().setWidth(30)),
                        color: Colors.blue,
                      ),
                      child: Center(
                          child: TextButton(
                        child: Text(
                          "Send",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          if (feedback.text.trim() != "") {
                            if (mounted) {
                              setState(() {
                                isLoading = true;
                                userInfo.actions = "feedback";
                                userInfo.feedback = feedback.text;
                                userBloc.eventSink.add(userInfo);
                              });
                            }
                          }
                        },
                      )))),
        ],
      ),
    ));
  }
}
