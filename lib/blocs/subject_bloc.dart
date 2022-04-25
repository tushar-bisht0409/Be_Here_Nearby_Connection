import 'dart:async';
import 'package:behere/main.dart';
import 'package:behere/models/subject_info.dart';
import 'package:dio/dio.dart';

class SubjectBloc {
  final _stateStreamController = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get _subjectSink => _stateStreamController.sink;
  Stream<dynamic> get subjectStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<SubjectInfo>();
  StreamSink<SubjectInfo> get eventSink => _eventStreamController.sink;
  Stream<SubjectInfo> get _eventStream => _eventStreamController.stream;

  SubjectBloc() {
    _eventStream.listen((event) async {
      var response;

      try {
        if (event.actions == "create") {
          var subjectData = {
            "subjectID": event.subjectID,
            "subjectSubID": event.subjectSubID,
            "institute": event.institute,
            "instituteCode": event.instituteCode,
            "subjectName": event.subjectName,
            "batch": event.batch,
            "course": event.course,
            "trade": event.trade,
            "section": event.section,
            "teacherID": event.teacherID,
            "teacherName": event.teacherName
          };

          response = await dio.post(
            serverURl + '/createsubject',
            data: subjectData,
            options: Options(contentType: Headers.formUrlEncodedContentType),
          );
        } else if (event.actions == "getSubject") {
          if (event.getBy == "subjectID") {
            response = await dio.get(serverURl + '/getsubject',
                queryParameters: {
                  "subjectID": event.subjectID,
                  "getBy": event.getBy
                });
          } else if (event.getBy == "teacherID") {
            response = await dio.get(serverURl + '/getsubject',
                queryParameters: {
                  "teacherID": event.teacherID,
                  "getBy": event.getBy
                });
          } else if (event.getBy == "studentID") {
            response = await dio.get(serverURl + '/getsubject',
                queryParameters: {
                  "studentID": event.studentID,
                  "getBy": event.getBy
                });
          } else if (event.getBy == "studentInfo") {
            response =
                await dio.get(serverURl + '/getsubject', queryParameters: {
              "institute": event.institute,
              "instituteCode": event.instituteCode,
              "batch": event.batch,
              "course": event.course,
              "trade": event.trade,
              "section": event.mySection,
              "getBy": event.getBy
            });
          }
        } else if (event.actions == "addTeacher") {
          response = await dio.post(serverURl + "/addteacher",
              data: {
                "subjectID": event.subjectID,
                "newTeacherID": event.newTeacherID
              },
              options: Options(contentType: Headers.formUrlEncodedContentType));
        }
      } on Error catch (e) {
        print(e);
      }

      _subjectSink.add(response.data);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
