import 'dart:async';

class GetTimeBloc {
  bool isTimeSet = false;
  final _stateStreamController = StreamController<dynamic>.broadcast();
  StreamSink<dynamic> get getTimeSink => _stateStreamController.sink;
  Stream<dynamic> get getTimeStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<String>();
  StreamSink<String> get eventSink => _eventStreamController.sink;
  Stream<String> get _eventStream => _eventStreamController.stream;

  GetTimeBloc() {
    _eventStream.listen((event) async {
      try {
        var dd = DateTime.now().difference(DateTime.parse(event));
        if (dd.inHours == 0) {
          if (dd.inMinutes > 14 && dd.inMinutes < 21) {
            isTimeSet = true;
          } else {
            isTimeSet = false;
          }
        }
        getTimeSink.add({"isTimeSet": isTimeSet, "minutes": dd.inMinutes});
      } on Error catch (e) {
        print(e);
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
