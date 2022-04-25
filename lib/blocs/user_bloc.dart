import 'dart:async';
import 'dart:convert';
import 'package:behere/main.dart';
import 'package:behere/models/user_info.dart';
import 'package:dio/dio.dart';

class UserBloc {
  final _stateStreamController = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get _userSink => _stateStreamController.sink;
  Stream<dynamic> get userStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<UserInfo>();
  StreamSink<UserInfo> get eventSink => _eventStreamController.sink;
  Stream<UserInfo> get _eventStream => _eventStreamController.stream;

  UserBloc() {
    _eventStream.listen((event) async {
      var response;

      try {
        if (event.actions == "saveInfo") {
          var userData = {
            "userID": event.userID,
            "mode": event.mode,
            "institute": event.institute,
            "instituteCode": event.instituteCode,
            "name": event.name,
            "rollNo": event.rollNo,
            "batch": event.batch,
            "course": event.course,
            "trade": event.trade,
            "section": event.section.toUpperCase(),
          };

          response = await dio.post(
            serverURl + '/saveuserinfo',
            data: userData,
            options: Options(contentType: Headers.formUrlEncodedContentType),
          );
        } else if (event.actions == "getUserInfo") {
          response =
              await dio.get(serverURl + '/getuserinfo', queryParameters: {
            "userID": event.userID,
          });
        } else if (event.actions == "getInstitute") {
          response = await dio.get(serverURl + '/getinstitute',
              queryParameters: {
                "getBy": event.getBy,
                "instituteCode": event.instituteCode
              });
        } else if (event.actions == "enroll") {
          var userData = {
            "userID": event.userID,
            "subjectID": event.subjectID,
            "students": event.students,
            "type": event.type
          };
          response = await dio.post(
            serverURl + '/enrollsubject',
            data: userData,
            options: Options(contentType: Headers.formUrlEncodedContentType),
          );
        } else if (event.actions == "feedback") {
          response = await dio.post(serverURl + '/sendfeedback',
              data: jsonEncode({
                "feedback": event.feedback,
                "userID": userID,
                "timeStamp": DateTime.now().toString(),
              }));
        }
      } on Error catch (e) {
        print(e);
      }

      _userSink.add(response.data);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
