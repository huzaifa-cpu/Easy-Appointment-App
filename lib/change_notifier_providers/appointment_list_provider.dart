import 'package:flutter/cupertino.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';

class AppointmentListProvider extends ChangeNotifier {
  List<Appointment> _appointments = [
    Appointment(
      id: null,
      name: null,
      slotDate: null,
      slotTime: null,
      slotNumber: null,
      bookingDate: null,
      paymentDate: null,
      rescheduledDate: null,
      reschedulingCount: null,
      cancelledDate: null,
      fee: null,
      type: null,
      createdByDoctor: null,
      state: null,
      status: null,
      createdDate: null,
      updatedDate: null,
      location: null,
      doctor: null,
      patient: null,
      updatedBy: null,
      createdBy: null,
      completedDate: null,
    ),
  ];

  //GETTER
  List<Appointment> get appointments => _appointments;

  //SETTER
  set appointments(List<Appointment> value) {
    _appointments = value;
    notifyListeners();
  }

  void cancelAppointmentByPatient(Appointment appointment) {
    Appointment appointmentToBeRemoved = _appointments.firstWhere(
        (_appointment) =>
            DateTime.parse(_appointment.slotDate).year ==
                DateTime.parse(appointment.slotDate).year &&
            DateTime.parse(_appointment.slotDate).month ==
                DateTime.parse(appointment.slotDate).month &&
            DateTime.parse(_appointment.slotDate).day ==
                DateTime.parse(appointment.slotDate).day &&
            _appointment.slotNumber == appointment.slotNumber &&
            _appointment.location.id == appointment.location.id);
    _appointments.remove(appointmentToBeRemoved);
    notifyListeners();
  }
}
