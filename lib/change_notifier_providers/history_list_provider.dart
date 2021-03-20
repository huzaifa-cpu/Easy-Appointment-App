import 'package:flutter/cupertino.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';

class HistoryListProvider extends ChangeNotifier {
  List<Appointment> appointments = [
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
  List<Appointment> get appointment => appointments;

  //SETTER
  set appointment(List<Appointment> value) {
    appointments = value;
    notifyListeners();
  }
}
