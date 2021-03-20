import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/slot_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:intl/intl.dart';

class SlotsProvider extends ChangeNotifier {
  static CustomStrings _strings = CustomStrings();
  List<Slot> _slots = [];

  void addSlot(Slot slot) {
    _slots.add(slot);
  }

  List<Slot> getSlotsByDateAndLocationId(DateTime date, int locationId) {
    List<Slot> slotsByDate = [];
    _slots.forEach((slot) {
      if (slot.date.month == date.month &&
          slot.date.year == date.year &&
          slot.date.day == date.day &&
          slot.locationId == locationId) {
        slotsByDate.add(slot);
      }
    });
    return slotsByDate;
  }

  int getFreeCount(DateTime date, int locationId) {
    int count = 0;
    _slots.forEach((slot) {
      if (slot.locationId == locationId &&
          slot.date.month == date.month &&
          slot.date.year == date.year &&
          slot.date.day == date.day) {
        if (slot.status == _strings.slotStatusFree ||
            slot.status == _strings.slotStatusCancelled) {
          count += 1;
        }
      }
    });
    return count;
  }

  int getBookedCount(DateTime date, int locationId) {
    int count = 0;
    _slots.forEach((slot) {
      if (slot.locationId == locationId &&
          slot.date.month == date.month &&
          slot.date.year == date.year &&
          slot.date.day == date.day &&
          slot.status == _strings.slotStatusBooked) {
        count += 1;
      }
    });
    return count;
  }

  int getCompletedCount(DateTime date, int locationId) {
    int count = 0;
    _slots.forEach((slot) {
      if (slot.locationId == locationId &&
          slot.date.month == date.month &&
          slot.date.year == date.year &&
          slot.date.day == date.day &&
          slot.status == _strings.slotStatusCompleted) {
        count += 1;
      }
    });
    return count;
  }

  void updateSlotStatus(Slot slot, String status, int locationId) {
    _slots.forEach((_slot) {
      if (_slot.locationId == locationId &&
          _slot.date.month == slot.date.month &&
          _slot.date.year == slot.date.year &&
          _slot.date.day == slot.date.day &&
          _slot.number == slot.number) {
        _slot.status = status;
        notifyListeners();
        if (_slot.status != _strings.slotStatusFree ||
            _slot.status != _strings.slotStatusCancelled) {
          _slot.disable = true;
          notifyListeners();
        } else {
          _slot.disable = false;
          notifyListeners();
        }
      }
    });
  }

  void updateSlotByPassedStatus(Slot slot) {
    _slots.forEach((_slot) {
      if (_slot.locationId == slot.locationId &&
          _slot.date.month == slot.date.month &&
          _slot.date.year == slot.date.year &&
          _slot.date.day == slot.date.day &&
          _slot.number == slot.number) {
        _slot.status = _strings.slotStatusPassed;
//        notifyListeners();
        _slot.disable = true;
//        notifyListeners();
        _slot.appointment = null;
//        notifyListeners();
      }
    });
  }

  void updateSlotByCancelledStatus(Slot slot) {
    _slots.forEach((_slot) {
      if (_slot.locationId == slot.locationId &&
          _slot.date.month == slot.date.month &&
          _slot.date.year == slot.date.year &&
          _slot.date.day == slot.date.day &&
          _slot.number == slot.number) {
        _slot.status = _strings.slotStatusFree;
        notifyListeners();
        _slot.disable = false;
        notifyListeners();
        _slot.appointment = null;
        notifyListeners();
      }
    });
  }

  void updateSlotFromFcmByCancelledStatus(Appointment appointment) {
    DateTime slotDate = DateTime.parse(appointment.slotDate);

    _slots.forEach((_slot) {
      if (_slot.locationId == appointment.location.id &&
          _slot.date.month == slotDate.month &&
          _slot.date.year == slotDate.year &&
          _slot.date.day == slotDate.day &&
          _slot.number == appointment.slotNumber) {
        _slot.status = _strings.slotStatusFree;
        notifyListeners();
        _slot.disable = false;
        notifyListeners();
        _slot.appointment = null;
        notifyListeners();
      }
    });
  }

  void updateSlotFromFcmByBookedStatus(Appointment appointment) {
    DateTime slotDate = DateTime.parse(appointment.slotDate);
    _slots.forEach((_slot) {
      if (_slot.locationId == appointment.location.id &&
          _slot.date.month == slotDate.month &&
          _slot.date.year == slotDate.year &&
          _slot.date.day == slotDate.day &&
          _slot.number == appointment.slotNumber) {
        _slot.status = _strings.slotStatusBooked;
        notifyListeners();
        _slot.disable = true;
        notifyListeners();
        _slot.appointment = appointment;
        notifyListeners();
      }
    });
  }

  void updateSlotByBookedStatus(Slot slot, Appointment appointment) {
    _slots.forEach((_slot) {
      if (_slot.locationId == slot.locationId &&
          _slot.date.month == slot.date.month &&
          _slot.date.year == slot.date.year &&
          _slot.date.day == slot.date.day &&
          _slot.number == slot.number) {
        _slot.status = _strings.slotStatusBooked;
//        notifyListeners();
        _slot.disable = true;
//        notifyListeners();
        _slot.appointment = appointment;
//        notifyListeners();
      }
    });
  }

  void updateSlotByCompletedStatus(Slot slot, Appointment appointment) {
    _slots.forEach((_slot) {
      if (_slot.locationId == slot.locationId &&
          _slot.date.month == slot.date.month &&
          _slot.date.year == slot.date.year &&
          _slot.date.day == slot.date.day &&
          _slot.number == slot.number) {
        _slot.status = _strings.slotStatusCompleted;
//        notifyListeners();
        _slot.disable = true;
//        notifyListeners();
        _slot.appointment = appointment;
//        notifyListeners();
      }
    });
  }

  Slot getSlotByDateAndNumber(Slot slot) {
    Slot getSlotByDateAndNumber = _slots.firstWhere(
        (_slot) =>
            _slot.date.month == slot.date.month &&
            _slot.date.year == slot.date.year &&
            _slot.date.day == slot.date.day &&
            _slot.locationId == slot.locationId &&
            _slot.number == slot.number,
        orElse: () => null);
    return getSlotByDateAndNumber;
  }

  get slots => _slots;

  set slots(List<Slot> value) {
    _slots = value;
    notifyListeners();
  }

  void updateSlotStatusByLocationIdSlotDateSLotNumber(
      String status, int locationId, String slotDate, int slotNumber) {
    print("update slot called");
    DateTime date = new DateFormat("yyyy-MM-dd").parse(slotDate);
    print("slots[0].date: ${slots[0].date}");
    print("date: $date");
    _slots.forEach((_slot) {
      if (_slot.locationId == locationId &&
          _slot.date.month == date.month &&
          _slot.date.year == date.year &&
          _slot.date.day == date.day &&
          _slot.number == slotNumber) {
        print("update slot main slot milgaya hai boss");
        _slot.status = status;
        notifyListeners();
        if (_slot.status != _strings.slotStatusFree ||
            _slot.status != _strings.slotStatusCancelled) {
          _slot.disable = true;
          notifyListeners();
        } else {
          _slot.disable = false;
          notifyListeners();
        }
      }
    });
  }

  void setEmptySlots() {
    _slots = [];
  }

  void removeSlotsByLocationIdAndDate(int locationId, DateTime date) {
    _slots.removeWhere((_slot) =>
        _slot.locationId == locationId &&
        _slot.date.month == date.month &&
        _slot.date.year == date.year &&
        _slot.date.day == date.day);
  }
}
