// import 'dart:async';
// import 'package:behere/main.dart';
// import 'package:behere/models/user_info.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// var authResult = {'success': false, 'msz': ''};
// enum AuthMode { login, signup, forgot }

// class AuthBloc {
//   final _stateStreamController = StreamController<dynamic>.broadcast();
//   StreamSink<dynamic> get _authSink => _stateStreamController.sink;
//   Stream<dynamic> get authStream => _stateStreamController.stream;

//   final _eventStreamController = StreamController<UserInfo>();
//   StreamSink<UserInfo> get eventSink => _eventStreamController.sink;
//   Stream<UserInfo> get _eventStream => _eventStreamController.stream;

//   saveData(String uID) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('userID', uID);
//     //  await prefs.setString('fcmToken', fToken);
//   }

//   AuthBloc() {
//     _eventStream.listen((event) async {
//       var response;
//       try {
//         if (event.actions == "SignUp") {
//           response = await dio.post(serverURl + "/adduser",
//               data: {"email": event.email, "password": event.password},
//               options: Options(contentType: Headers.formUrlEncodedContentType));
//           saveData(userID);
//           authDialog = true;
//         } else if (event.actions == "LogIn") {
//           print('yo');
//           response = await dio.post(serverURl + "/authenticate",
//               data: {"email": event.email, "password": event.password},
//               options: Options(contentType: Headers.formUrlEncodedContentType));
//           if (response.data['success'] == true) {
//             userID = response.data['userID'];
//             //        var fcm = await FirebaseMessaging.instance.getToken();
//             saveData(userID);
//           }
//           authDialog = true;
//         } else if (event.actions == "Forgot") {
//           print("forgot");
//         } else if (event.actions == "UserExist") {
//           response = await dio.post(serverURl + "/userexist",
//               data: {"email": event.email},
//               options: Options(contentType: Headers.formUrlEncodedContentType));
//           authDialog = true;
//         } else if (event.actions == "ChangePassword") {
//           response = await dio.post(serverURl + "/changepassword",
//               data: {"email": event.email, "password": event.password},
//               options: Options(contentType: Headers.formUrlEncodedContentType));
//           authDialog = true;
//         }
//       } on Error catch (e) {
//         print(e);
//       }

//       _authSink.add(response.data);
//     });
//   }

//   void dispose() {
//     _stateStreamController.close();
//     _eventStreamController.close();
//   }
// }
