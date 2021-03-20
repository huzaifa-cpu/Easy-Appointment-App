import 'package:flutter/foundation.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';

class DoctorAppointmentsProvider extends ChangeNotifier {
  static CustomStrings _strings = CustomStrings();

  List<Appointment> _doctorAppointments = [];

  List<Appointment> get doctorAppointments => _doctorAppointments;

  set doctorAppointments(List<Appointment> appointments) {
    _doctorAppointments = appointments;
    notifyListeners();
  }

  List<Appointment> getAppointmentBySelectedDateLocationId(
      DateTime selectedDate, int locationId) {
    List<Appointment> appointmentsBySlotDateAndLocationId = [];
    _doctorAppointments.forEach((doctorAppointment) {
      if (DateTime.parse(doctorAppointment.slotDate).month ==
              selectedDate.month &&
          DateTime.parse(doctorAppointment.slotDate).day == selectedDate.day &&
          DateTime.parse(doctorAppointment.slotDate).year ==
              selectedDate.year &&
          doctorAppointment.location.id == locationId) {
        appointmentsBySlotDateAndLocationId.add(doctorAppointment);
      }
    });
    return appointmentsBySlotDateAndLocationId;
  }

  void addDoctorAppointment(Appointment appointment) {
    _doctorAppointments.add(appointment);
    notifyListeners();
  }

  void updateAppointment(Appointment appointmentFromResponse) {
    _doctorAppointments.forEach((_appointment) {
      if (_appointment.id == appointmentFromResponse.id) {
        _appointment.status = appointmentFromResponse.status;
        _appointment.state = appointmentFromResponse.state;
        _appointment.cancelledDate = appointmentFromResponse.cancelledDate;
        _appointment.updatedDate = appointmentFromResponse.updatedDate;
        _appointment.updatedBy = appointmentFromResponse.updatedBy;
        _appointment.completedDate = appointmentFromResponse.completedDate;
        _appointment.name = appointmentFromResponse.name;
        _appointment.slotDate = appointmentFromResponse.slotDate;
        _appointment.slotTime = appointmentFromResponse.slotTime;
        _appointment.slotNumber = appointmentFromResponse.slotNumber;
        _appointment.bookingDate = appointmentFromResponse.bookingDate;
        _appointment.paymentDate = appointmentFromResponse.paymentDate;
        _appointment.rescheduledDate = appointmentFromResponse.rescheduledDate;
        _appointment.reschedulingCount =
            appointmentFromResponse.reschedulingCount;
        _appointment.fee = appointmentFromResponse.fee;
        _appointment.type = appointmentFromResponse.type;
        _appointment.createdByDoctor = appointmentFromResponse.createdByDoctor;
        _appointment.createdDate = appointmentFromResponse.createdDate;
        _appointment.location = appointmentFromResponse.location;
        _appointment.doctor = appointmentFromResponse.doctor;
        _appointment.patient = appointmentFromResponse.patient;
        _appointment.createdBy = appointmentFromResponse.createdBy;
      }
    });
    notifyListeners();
  }

  int getBookedCount(DateTime date, int locationId) {
    int count = 0;
    _doctorAppointments.forEach((_doctorAppointment) {
      DateTime _doctorAppointmentSlotDate =
          DateTime.parse(_doctorAppointment.slotDate);
      if (_doctorAppointment.location.id == locationId &&
          _doctorAppointmentSlotDate.month == date.month &&
          _doctorAppointmentSlotDate.year == date.year &&
          _doctorAppointmentSlotDate.day == date.day &&
          _doctorAppointment.status == _strings.slotStatusBooked) {
        count += 1;
      }
    });
    return count;
  }

  int getCompletedCount(DateTime date, int locationId) {
    int count = 0;
    _doctorAppointments.forEach((_doctorAppointment) {
      DateTime _doctorAppointmentSlotDate =
          DateTime.parse(_doctorAppointment.slotDate);
      if (_doctorAppointment.location.id == locationId &&
          _doctorAppointmentSlotDate.month == date.month &&
          _doctorAppointmentSlotDate.year == date.year &&
          _doctorAppointmentSlotDate.day == date.day &&
          _doctorAppointment.status == _strings.slotStatusCompleted) {
        count += 1;
      }
    });
    return count;
  }

  void setEmptyDoctorAppointments() {
    _doctorAppointments = [];
  }
}
