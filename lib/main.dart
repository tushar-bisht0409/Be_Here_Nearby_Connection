import 'package:behere/appcolor.dart';
import 'package:behere/screens/splash_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

String serverURl = "https://behere.herokuapp.com";
var dio = Dio();
String myMode = "";
String myEmail = "";
String myName = "";
String myRollno = "";
String myID = "";
String myBranch = "";
String myBatch = "";
String mySection = "";
String myCourse = "";
String myInstitute = "";
String userID = "";
int toppad = 0;
int bottompad = 0;
int notificationCount = 0;
AppColors appColor = AppColors();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MediaQuery(
      data: MediaQueryData.fromWindow(WidgetsBinding.instance!.window),
      child: ScreenUtilInit(
        designSize: ScreenUtil.defaultSize,
        builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          //locale: window.locale,
          //fallbackLocale: const Locale('hr', 'HR'),
          theme: ThemeData(
            primarySwatch: Colors.lightBlue,
          ),
          home: SplashScreen(),
          builder: (ctx, child) {
            ScreenUtil.setContext(ctx);
            return child!;
          },
        ),
      ),
    );
    // ScreenUtilInit(
    //     designSize: Size(360, 690),
    //     // allowFontScaling: false,1
    //     builder: () => FutureBuilder(builder: (context, appSnapshot) {
    //           return MaterialApp(
    //             debugShowCheckedModeBanner: false,
    //             theme: ThemeData(
    //               primarySwatch: Colors.lightBlue,
    //             ),
    //             home: SplashScreen(),
    //           );
    //         }));
  }
}
