import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/schedule_model.dart';
import 'package:flutter_ea_mobile_app/models/slot_model.dart';
import 'package:flutter_ea_mobile_app/services/utils_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';

class SlotService {
  CustomStrings _strings = CustomStrings();
  Utils utils = Utils();

  void updateSlotStatuses(
      {SchedulesProvider schedulesProvider,
      SlotsProvider slotsProvider,
      DoctorAppointmentsProvider doctorAppointmentsProvider,
      int locationId,
      DateTime selectedDate,
      int day}) async {
    List<Schedule> schedules =
        schedulesProvider.getSchedulesByLocationId(locationId);
    Schedule schedule = schedules.firstWhere((schedule) => schedule.day == day);
    int startTime = schedule.startTime;
    int endTime = schedule.endTime;
    int slotTime = schedule.defaultTimeSlotLimit;
    int totalTime = endTime - startTime;
    int totalSlots = (totalTime ~/ slotTime);
    print("startTime: $startTime");
    print("totalSlots: $totalSlots");
    slotsProvider.removeSlotsByLocationIdAndDate(locationId, selectedDate);
    if (schedule.off == false) {
      print("abay holiday nai hai");
      for (int slotNumber = 1; slotNumber < totalSlots + 1; slotNumber++) {
        if (startTime >= 1440) {
          startTime = startTime - 1440;
        }
        // For Free Status
        slotsProvider.addSlot(
          Slot(
              appointment: null,
              locationId: locationId,
              number: slotNumber,
              timeIn12HoursFormat: utils.durationToString(startTime),
              status: 'Free',
              phone: '',
              timeInMinutes: startTime,
              date: selectedDate,
              disable: false),
        );
        startTime += slotTime;
      }
    }

    List<Appointment> doctorAppointments = doctorAppointmentsProvider
        .getAppointmentBySelectedDateLocationId(selectedDate, locationId);
    List<Slot> doctorSlots =
        slotsProvider.getSlotsByDateAndLocationId(selectedDate, locationId);
    DateTime currentDateTime = DateTime.now();
    int currentTimeInMinutes =
        (currentDateTime.hour * 60) + currentDateTime.minute;

    if (doctorSlots.length != 0) {
      doctorSlots.forEach((doctorSlot) {
        doctorAppointments.forEach((doctorAppointment) {
          if (doctorAppointment.slotNumber == doctorSlot.number) {
            if (doctorAppointment.status == _strings.slotStatusBooked) {
              // For Booked Status
              slotsProvider.updateSlotByBookedStatus(
                  doctorSlot, doctorAppointment);
            } else if (doctorAppointment.status ==
                _strings.slotStatusCompleted) {
              // For Completed Status
              slotsProvider.updateSlotByCompletedStatus(
                  doctorSlot, doctorAppointment);
            }
          }
        });
        if (currentDateTime.year >= doctorSlot.date.year &&
            currentDateTime.month >= doctorSlot.date.month &&
            currentDateTime.day >= doctorSlot.date.day &&
            currentTimeInMinutes >= doctorSlot.timeInMinutes) {
          if (doctorSlot.status == _strings.slotStatusFree) {
            // For Passed Status
            slotsProvider.updateSlotByPassedStatus(doctorSlot);
          } else if (doctorSlot.status == _strings.slotStatusBooked) {
            // For Missed Status

            // waiting business
          }
        }
      });
    }
  }
}
