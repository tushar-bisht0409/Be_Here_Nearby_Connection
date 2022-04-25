import 'dart:async';
import 'package:behere/main.dart';
import 'package:behere/models/offline_info.dart';

class OfflineBloc {
  final _stateStreamController = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get _offlineSink => _stateStreamController.sink;
  Stream<dynamic> get offlineStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<OfflineInfo>();
  StreamSink<OfflineInfo> get eventSink => _eventStreamController.sink;
  Stream<OfflineInfo> get _eventStream => _eventStreamController.stream;

  OfflineBloc() {
    _eventStream.listen((event) async {
      var response;
      try {
        if (event.actions == "download") {
          response = await dio.get(serverURl + '/downloaddata',
              queryParameters: {
                "getBy": event.getBy,
                "type": event.type,
                "instituteCode": event.instituteCode
              });
        }
      } on Error catch (e) {
        print(e);
      }

      _offlineSink.add(response.data);
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
