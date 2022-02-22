
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:iot_demo/models/infor_res.dart';
import 'package:iot_demo/models/sensors_res.dart';
import 'package:iot_demo/network/apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'living_room_event.dart';
part 'living_room_state.dart';

class LivingRoomBloc extends Bloc<LivingRoomEvents, LivingRoomState> {
  LivingRoomBloc() : super(LivingRoomLoadingState());

  @override
  Stream<LivingRoomState> mapEventToState(LivingRoomEvents event) async* {
    var formatter = DateFormat('yyyy-MM-dd');
    var now = DateTime.now();
   // String currentDate = formatter.format(now);
   //  var endDay = DateTime.now().add(Duration(days:1));
   //  String endDate = formatter.format(endDay);

    String end= now.microsecondsSinceEpoch.toString();
     var beginTime = DateTime.now().subtract(Duration(hours:1));
     String begin = beginTime.microsecondsSinceEpoch.toString();

    final pref = await SharedPreferences.getInstance();
    String token = (pref.getString('token') ?? "");


    final apiRepository = Api();
    if (event is StartEvent) {
      yield LivingRoomInitState();
    } else if (event is LivingRoomEventStated) {
      yield LivingRoomLoadingState();
    //  var data = await apiRepository.getSensors(begin,end);
      var data = await apiRepository.getSensors('1645370760000','1645457160000');
      if (data != null) {
          yield LivingRoomLoadedState(sensorsResponse: data);

      } else {
        yield LivingRoomErrorState();
      }
    }
  }
}
