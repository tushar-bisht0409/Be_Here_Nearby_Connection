import 'dart:convert';
import 'dart:io';

import 'package:behere/main.dart';
import 'package:behere/screens/allclass_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';

class JoinAttendanceScreen extends StatefulWidget {
  var subjectID;
  var shortName;
  var subjectName;
  var branch;
  var batch;
  var section;
  var students;
  var student;
  JoinAttendanceScreen(this.subjectID, this.shortName, this.subjectName,
      this.branch, this.batch, this.section, this.students, this.student);
  @override
  State<JoinAttendanceScreen> createState() => _JoinAttendanceScreenState();
}

class _JoinAttendanceScreenState extends State<JoinAttendanceScreen> {
  bool isStarted = true;
  var nearbyService;
  var subscription;
  List<Device> devices = [];

  Future<void> startJoining() async {
    print(myRollno);
    // await nearbyService.init(
    //     serviceType: 'mpconn',
    //     deviceName: myRollno,
    //     strategy: Strategy.P2P_CLUSTER,
    //     callback: (isRunning) async {
    //       if (isRunning) {
    //         await nearbyService.stopBrowsingForPeers();
    //         await nearbyService.stopAdvertisingPeer();
    //         await Future.delayed(Duration(microseconds: 200));
    //         await nearbyService.startBrowsingForPeers();
    //         await nearbyService.startAdvertisingPeer();
    //       }
    //     });
    await nearbyService.init(
        serviceType: 'mpconn',
        deviceName: myRollno,
        strategy: Strategy.P2P_CLUSTER,
        callback: (isRunning) async {
          if (isRunning) {
            await nearbyService.stopAdvertisingPeer();
            await nearbyService.stopBrowsingForPeers();
            await Future.delayed(Duration(microseconds: 200));
            await nearbyService.startAdvertisingPeer();
            await nearbyService.startBrowsingForPeers();
          }
        });

    // subscription =
    //     nearbyService.stateChangedSubscription(callback: (devicesList) {
    //   devicesList.forEach((element) {
    //     if (mounted) {
    //       setState(() {
    //         devices.clear();
    //         devices.addAll(devicesList);
    //       });
    //     }
    //   });
    // });
  }

  @override
  void initState() {
    super.initState();
    nearbyService = NearbyService();
    startJoining().then((value) {
      Future.delayed(Duration(seconds: 20), () {
        if (mounted) {
          setState(() {
            nearbyService.stopBrowsingForPeers();
            nearbyService.stopAdvertisingPeer();
          });
        }
      }).then((value) {
        isStarted = false;
        print('aa $devices');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              if (isStarted) {
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              body: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    ListView(
                      children: <Widget>[
                        Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 360.w - 2 * (50.w + 16),
                                  child: Text(
                                    'Attendance',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w800),
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Container(
                                  height: 4.h,
                                  width: 360.w,
                                  color: appColor.wBlue,
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: 100.h,
                                left: 40.w,
                                right: 40.w,
                                bottom: 20.h),
                            height: 160.w,
                            width: 160.w,
                            child: SpinKitDoubleBounce(
                              size: 100.w,
                              color: Colors.lightBlue,
                            )),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 40.w),
                          child: Column(
                            children: <Widget>[
                              Text(
                                'Attending Class',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w900),
                              ),
                              SizedBox(
                                height: 40.h,
                              ),
                              Text(
                                isStarted
                                    ? ''
                                    : 'You can see the attendance by visting the classes section by clicking the the button given below',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              isStarted
                                  ? SizedBox()
                                  : Icon(
                                      Icons.arrow_drop_down_circle_outlined,
                                      color: Colors.blue,
                                      size: 30.w,
                                    )
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        bottom: 0,
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 40.w),
                            alignment: Alignment.center,
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    ScreenUtil().setWidth(30)),
                                color: appColor.dBlue,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    isStarted
                                        ? Icons.schedule_rounded
                                        : Icons.class__rounded,
                                    color: isStarted
                                        ? Colors.lightBlue
                                        : Colors.green,
                                    size: 20.w,
                                  ),
                                  TextButton(
                                    child: Text(
                                      isStarted
                                          ? "Attending Class"
                                          : "Show Classes",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14.sp),
                                    ),
                                    onPressed: () {
                                      if (mounted) {
                                        setState(() {
                                          if (isStarted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                'Currently Attending class, wait for a while',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              backgroundColor: Colors.blue,
                                            ));
                                          } else {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (builder) =>
                                                        AllClassScreen(
                                                            widget.subjectID,
                                                            widget.shortName,
                                                            widget.subjectName,
                                                            widget.branch,
                                                            widget.batch,
                                                            widget.section,
                                                            widget.students,
                                                            widget.student)));
                                          }
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )))
                  ]),
            )));
  }
}
