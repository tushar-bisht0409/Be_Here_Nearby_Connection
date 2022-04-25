import 'dart:convert';
import 'dart:io';

import 'package:behere/screens/feedback_screen.dart';
import 'package:behere/screens/profile_screen.dart';
import 'package:behere/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:behere/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//ignore: must_be_immutable
class AppDrawer extends StatelessWidget {
  var subjectList;
  AppDrawer(this.subjectList);
//  @override
  EdgeInsets p = EdgeInsets.only(
      top: ScreenUtil().setHeight(10), left: ScreenUtil().setWidth(25));

  Future<void> deleteFile() async {
    var dd;
    await getApplicationDocumentsDirectory().then((value) {
      dd = value.path;
    });
    var nn = 'behere.txt';
    await File(dd + '/' + nn).delete(recursive: true);
  }

  Future<void> deleteSubjectFile() async {
    var dd;
    var classNames = [];
    await getApplicationDocumentsDirectory().then((value) {
      dd = value.path;
    });

    for (int i = 0; i < subjectList.length; i++) {
      if (await File(dd + '/' + '${subjectList[i]['subjectID']}.txt')
          .exists()) {
        var nn = '${subjectList[i]['subjectID']}.txt';
        await File(dd + '/' + nn).delete();
      }

      for (int i = 0; i < classNames.length; i++) {
        var nn = '${classNames[i]}';
        var newList = jsonDecode(await File(dd + '/' + nn).readAsString());
        if (await File(dd + '/' + nn).exists()) {
          await File(dd + '/' + nn).delete();
        }
      }
    }
  }

  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  //  color: Colors.deepPurpleAccent,
                  gradient: LinearGradient(
                    //  begin: Alignment.topLeft,
                    //    end: Alignment.bottomRight,
                    //  stops: [0.1, 0.2, 0.8, 1.0],
                    colors: <Color>[appColor.dBlue, appColor.lBlue],
                    //   tileMode: TileMode.mirror,
                  ),
                  //   color: Colors.orange[500],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(ScreenUtil().setWidth(50)),
                    bottomRight: Radius.circular(ScreenUtil().setWidth(50)),
                  ),
                ),
                child: Center(
                    child: Text(
                  'Be Here',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900),
                )),
              ),
              ListTile(
                contentPadding: p,
                leading: Icon(
                  Icons.account_circle_rounded,
                  size: 30.h,
                  color: Colors.lightBlue,
                ),
                title: Text(
                  'My Profile',
                  style: TextStyle(
                      color: appColor.lBlue,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
              ),
              // ListTile(
              //   contentPadding: p,
              //   leading: Icon(
              //     Icons.map,
              //     size: 30.h,
              //     color: Colors.lightGreen,
              //   ),
              //   title: Text(
              //     'My Tournaments',
              //     style: TextStyle(
              //         color: appColor.lBlue,
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w600),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     // Navigator.push(
              //     //     context,
              //     //     MaterialPageRoute(
              //     //         builder: (context) => MyTournamentScreen()));
              //   },
              // ),
              // ListTile(
              //   contentPadding: p,
              //   leading: Icon(
              //     Icons.map,
              //     size: 30.h,
              //     color: Colors.lightGreenAccent,
              //   ),
              //   title: Text(
              //     'Matches Joined',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w600),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => MatchJoinHostScreen("join")));
              //   },
              // ),
              // ListTile(
              //   contentPadding: p,
              //   leading: FaIcon(
              //     FontAwesomeIcons.wallet,
              //     size: 30.h,
              //     color: Colors.brown,
              //   ),
              //   title: Text(
              //     'Wallet',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w600),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => PaymentScreen()));
              //   },
              // ),
              // ListTile(
              //   contentPadding: p,
              //   leading: FaIcon(
              //     FontAwesomeIcons.chessKing,
              //     size: 30.h,
              //     color: Colors.amber,
              //   ),
              //   title: Text(
              //     'Membership',
              //     style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 12.sp,
              //         fontWeight: FontWeight.w600),
              //   ),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //             builder: (context) => SubscriptionScreen()));
              //   },
              // ),
              ListTile(
                contentPadding: p,
                leading: Icon(
                  Icons.feedback_rounded,
                  size: 30.h,
                  color: appColor.lBlue,
                ),
                title: Text(
                  'Feedback',
                  style: TextStyle(
                      color: appColor.lBlue,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FeedBackScreen()));
                },
              ),
              ListTile(
                  contentPadding: p,
                  leading: Icon(
                    Icons.logout,
                    size: 30.h,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                        color: appColor.lBlue,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('email');
                    await prefs.remove('name');
                    await prefs.remove('branch');
                    await prefs.remove('batch');
                    await prefs.remove('section');
                    await prefs.remove('rollno');
                    await prefs.remove('id');
                    await prefs.remove('userMode');
                    await deleteSubjectFile();
                    await deleteFile();

                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()));
                  }),
            ],
          ),
        ));
  }
}
