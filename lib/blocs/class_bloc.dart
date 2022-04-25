import 'dart:async';
import 'package:behere/main.dart';
import 'package:behere/models/class_info.dart';
import 'package:dio/dio.dart';

class ClassBloc {
  final _stateStreamController = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get _classSink => _stateStreamController.sink;
  Stream<dynamic> get classStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<ClassInfo>();
  StreamSink<ClassInfo> get eventSink => _eventStreamController.sink;
  Stream<ClassInfo> get _eventStream => _eventStreamController.stream;

  ClassBloc() {
    _eventStream.listen((event) async {
      var response;
      try {
        if (event.actions == "create") {
          // var classData = {
          //   "subjectID": event.subjectID,
          //   "classID": event.classID,
          //   "teacher": event.teacher,
          //   "date": event.date,
          //   "timing": event.timing,
          //   "status": "Scheduled",
          //   "startTimeStamp": event.startTimeStamp
          // };
          var classData = {
            "subjectID": event.subjectID,
            "classID": event.classID,
            "teacher": event.teacher,
            "studentPresent": event.studentPresent
          };
          response = await dio.post(
            serverURl + '/createclass',
            data: classData,
            options: Options(contentType: Headers.formUrlEncodedContentType),
          );
        } else if (event.actions == "createMany") {
          var classData = {"classes": event.classes};
          response = await dio.post(
            serverURl + '/createmanyclass',
            data: classData,
            options: Options(contentType: Headers.formUrlEncodedContentType),
          );
        } else if (event.actions == "getClass") {
          if (event.getBy == "subjectID") {
            response = await dio.get(serverURl + '/getclass', queryParameters: {
              "subjectID": event.subjectID,
              "getBy": event.getBy
            });
          } else if (event.getBy == "classID") {
            response = await dio.get(serverURl + '/getclass', queryParameters: {
              "classID": event.classID,
              "getBy": event.getBy
            });
          }
        } else if (event.actions == "postSSID") {
          response = await dio.post(serverURl + "/postssid",
              data: {"classID": event.classID, "ssid": event.ssid},
              options: Options(contentType: Headers.formUrlEncodedContentType));
        } else if (event.actions == "studentsInClass") {
          response = await dio.post(serverURl + "/studentsinclass",
              data: {"classID": event.classID, "students": event.students},
              options: Options(contentType: Headers.formUrlEncodedContentType));
        } else if (event.actions == "presentAbsentList") {
          response = await dio.post(serverURl + "/presentabsentlist",
              data: {
                "classID": event.classID,
                "studentPresent": event.studentPresent,
                "studentAbsent": event.studentAbsent
              },
              options: Options(contentType: Headers.formUrlEncodedContentType));
        } else if (event.actions == "presentAbsent") {
          response = await dio.post(serverURl + "/presentabsent",
              data: {
                "classID": event.classID,
                "type": event.type,
                "student": event.student
              },
              options: Options(contentType: Headers.formUrlEncodedContentType));
        } else if (event.actions == "changeStatus") {
          response = await dio.post(serverURl + "/changeclassstatus",
              data: {
                "classID": event.classID,
              },
              options: Options(
                  contentType: Headers.formUrlEncodedContentType,
                  followRedirects: false,
                  validateStatus: (status) {
                    return status! > 500;
                  }));
        }
      } on DioError catch (e) {
        print('${e.response}');
        print(e.message);
      }
      if (response != null) {
        _classSink.add(response.data);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
