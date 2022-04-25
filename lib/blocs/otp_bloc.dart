import 'dart:async';
import 'package:behere/main.dart';
import 'package:behere/models/user_info.dart';
import 'package:dio/dio.dart';

class OTPBloc {
  final _stateStreamController = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get _otpSink => _stateStreamController.sink;
  Stream<dynamic> get otpStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<UserInfo>();
  StreamSink<UserInfo> get eventSink => _eventStreamController.sink;
  Stream<UserInfo> get _eventStream => _eventStreamController.stream;

  OTPBloc() {
    _eventStream.listen((event) async {
      var response;
      try {
        if (event.actions == "createOTP") {
          response = await dio.post(serverURl + "/createotp",
              data: {"email": event.email},
              options: Options(contentType: Headers.formUrlEncodedContentType));
        } else if (event.actions == "getOTP") {
          response = await dio.get(serverURl + '/getotp', queryParameters: {
            "email": event.email,
            "type": event.type,
            "getBy": event.getBy,
            "otp": event.otp
          });
        } else if (event.actions == "deleteOTP") {
          response = await dio.post(serverURl + "/deleteotp",
              data: {"email": event.email, "otp": event.otp},
              options: Options(contentType: Headers.formUrlEncodedContentType));
        }
      } on Error catch (e) {
        print(e);
      }

      _otpSink.add(response.data);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
