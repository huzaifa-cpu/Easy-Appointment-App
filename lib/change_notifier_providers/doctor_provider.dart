import 'package:flutter/cupertino.dart';
import 'package:flutter_ea_mobile_app/models/doctor_model.dart';

class DoctorProvider extends ChangeNotifier {
  Doctor _doctor = Doctor(
    id: null,
    registrationNo: null,
    fatherName: null,
    registrationDate: null,
    registrationType: null,
    validUpto: null,
    qualifications: null,
    titlesStr: null,
    degreesStr: null,
    titles: null,
    degrees: null,
    practiceStartingDate: null,
    description: null,
    createdDate: null,
    updatedDate: null,
    user: null,
    locations: null,
  );

  //GETTER SETTERS
  Doctor get doctor => _doctor;

  set doctor(Doctor value) {
    _doctor = value;
    notifyListeners();
  }
  //METHODS

  void updateDegreeStr(String value) async {
    _doctor.degreesStr = value;
    notifyListeners();
  }

  void updateTitleStr(String value) async {
    _doctor.titlesStr = value;
    notifyListeners();
  }
}
