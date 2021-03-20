import 'package:flutter/foundation.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/services/utils_service.dart';

class SchedulesProvider extends ChangeNotifier {
  Utils utils = Utils();
  List<Schedule> _finalSchedules = [];
  List<Schedule> _schedules = [
    Schedule(
      day: 1,
      startTime: 60,
      endTime: 120,
      defaultTimeSlotLimit: 10,
      state: true,
      status: "Active",
      off: false,
    ),
    Schedule(
      day: 2,
      startTime: 180,
      endTime: 240,
      defaultTimeSlotLimit: 10,
      state: true,
      status: "Active",
      off: false,
    ),
    Schedule(
      day: 3,
      startTime: 300,
      endTime: 360,
      defaultTimeSlotLimit: 10,
      state: true,
      status: "Active",
      off: false,
    ),
    Schedule(
      day: 4,
      startTime: 420,
      endTime: 480,
      defaultTimeSlotLimit: 10,
      state: true,
      status: "Active",
      off: false,
    ),
    Schedule(
      day: 5,
      startTime: 1320,
      endTime: 1380,
      defaultTimeSlotLimit: 10,
      state: true,
      status: "Active",
      off: false,
    ),
    Schedule(
      day: 6,
      startTime: 660,
      endTime: 720,
      defaultTimeSlotLimit: 10,
      state: true,
      status: "Active",
      off: true,
    ),
    Schedule(
      day: 7,
      startTime: 780,
      endTime: 840,
      defaultTimeSlotLimit: 10,
      state: true,
      status: "Active",
      off: true,
    ),
  ];

  List<Schedule> getSchedulesByLocationId(int locationId) {
    List<Schedule> schedulesByLocationId = [];
    _finalSchedules.forEach((schedule) {
      if (schedule.location.id == locationId) {
        schedulesByLocationId.add(schedule);
      }
    });
//    notifyListeners();
    return schedulesByLocationId;
  }

  void updateSlot(int slot, int day) async {
    _schedules
        .firstWhere((schedule) => schedule.day == day, orElse: () => null)
        .defaultTimeSlotLimit = slot;
    notifyListeners();
  }

  void updateStartTime(int startTime, int day) async {
    _schedules
        .firstWhere((schedule) => schedule.day == day, orElse: () => null)
        .startTime = startTime;
    notifyListeners();
  }

  bool updateEndTime(int endTime, int day) {
    Schedule _schedule = _schedules
        .firstWhere((schedule) => schedule.day == day, orElse: () => null);
    print("startTime: ${_schedule.startTime}");
    print("endTime: $endTime");
    if (endTime > _schedule.startTime) {
      print("endTime greater hai");
      _schedules
          .firstWhere((schedule) => schedule.day == day, orElse: () => null)
          .endTime = endTime;
      notifyListeners();
      return true;
    }
    print("endTime greater nai hai");
    return false;
  }

  void updateHoliday(bool off, int day) {
    _schedules
        .firstWhere((schedule) => schedule.day == day, orElse: () => null)
        .off = off;
    notifyListeners();
  }

  void setLocation(Location location) {
    _schedules.forEach((schedule) {
      schedule.location = location;
      notifyListeners();
    });
  }

  void addSchedules(List<Schedule> schedules) {
    for( var i = 0 ; i < schedules.length; i++ ) {
      _finalSchedules.add(_schedules[i]);
    }
//    _finalSchedules.addAll(schedules);
    notifyListeners();
  }

  dynamic get schedules => _schedules;

  set schedules(List<Schedule> value) {
    _schedules = value;
    notifyListeners();
  }

  dynamic get finalSchedules => _finalSchedules;

  set finalSchedules(List<Schedule> value) {
    _finalSchedules = value;
    notifyListeners();
  }

  void setEmptyFinalSchedules() {
    _finalSchedules = [];
  }

  void setSchedules(List<Schedule> value) {
    _schedules = value;
  }

  void updateSchedules(List<Schedule> updatedSchedules) {
    _finalSchedules.forEach((_finalSchedule) {
      updatedSchedules.forEach((updatedSchedule) {
        if (_finalSchedule.location.id == updatedSchedule.location.id &&
            _finalSchedule.day == updatedSchedule.day) {
          _finalSchedule.startTime = updatedSchedule.startTime;
          _finalSchedule.endTime = updatedSchedule.endTime;
          _finalSchedule.defaultTimeSlotLimit =
              updatedSchedule.defaultTimeSlotLimit;
          _finalSchedule.off = updatedSchedule.off;
          print("_finalSchedule.location.id: ${_finalSchedule.location.id}");
          print("_finalSchedule.day: ${_finalSchedule.day}");
          print("_finalSchedule.off: ${_finalSchedule.off}");
          print("_finalSchedule.startTime: ${_finalSchedule.startTime}");
          print("_finalSchedule.endTime: ${_finalSchedule.endTime}");
          print(
              "_finalSchedule.defaultTimeSlotLimit: ${_finalSchedule.defaultTimeSlotLimit}");
        }
      });
    });
    notifyListeners();
  }

  void setNullPkAndCreatedDateOfSchedules() {
    _schedules.forEach((_schedule) {
      _schedule.createdDate = utils.getCurrentDate();
      _schedule.id = null;
      _schedule.state = true;
      _schedule.status = "Active";
      notifyListeners();
    });
  }
}
