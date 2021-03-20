import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentsProvider extends ChangeNotifier {
  CustomStrings strings = CustomStrings();

  List<Appointment> _doctorAppointmentBySlotDate = [];

  set doctorAppointmentBySlotDate(List<Appointment> value) {
    _doctorAppointmentBySlotDate = value;
    notifyListeners();
  }

  void setDoctorAppointmentBySlotDate(List<Appointment> appointments) {
    _doctorAppointmentBySlotDate = appointments;
  }

  List<Appointment> get doctorAppointmentBySlotDate =>
      _doctorAppointmentBySlotDate;

  //

  // List<Appointment> _patientScheduleAppointments;

  // set patientScheduleAppointments(List<Appointment> value) {
  //   _patientScheduleAppointments = value;
  //   notifyListeners();
  // }

  // void setPatientScheduleAppointments(List<Appointment> value) {
  //   _patientScheduleAppointments = value;
  // }

  // List<Appointment> get patientScheduleAppointments =>
  //     _patientScheduleAppointments;

  // void cancelAppointmentByPatient(Appointment appointment) {
  //   Appointment appointmentToBeRemoved =
  //       _patientScheduleAppointments.firstWhere((_appointment) =>
  //           _appointment.slotDate == appointment.slotDate &&
  //           _appointment.slotNumber == appointment.slotNumber &&
  //           _appointment.location.id == appointment.location.id);
  //   _patientScheduleAppointments.remove(appointmentToBeRemoved);
  //   notifyListeners();
  // }
}
