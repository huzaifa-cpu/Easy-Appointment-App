import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // clear() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.clear();
  // }

  Future<dynamic> setUser(double id) async {
    return this
        ._prefs
        .then((SharedPreferences prefs) => prefs.setDouble('userId', id));
  }

  Future<dynamic> getUser() async {
    return this._prefs.then((SharedPreferences prefs) => prefs.get('userId'));
  }

  // setDoctors(doctors) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.setString('doctors', doctors);
  // }

  // Future<Object> getDoctors() {
  //   return this.storage.then((SharedPreferences prefs) => prefs.get('doctors'));
  // }

  // Future<Object> setPatient(patient) {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.setString('patient', patient));
  // }

  // Future<Object> getPatient() {
  //   return this.storage.then((SharedPreferences prefs) => prefs.get('patient'));
  // }

  // Future<Object> removePatient() {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.remove('patient'));
  // }

  // Future<Object> setDoctor(doctors) {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.setString('doctors', doctors));
  // }

  // Future<Object> getDoctor() {
  //   return this.storage.then((SharedPreferences prefs) => prefs.get('doctors'));
  // }

  // Future<Object> removeDoctor() {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.remove('doctor'));
  // }

  // Future<Object> setPatientAppointmentsList(patientAppointmentsList) {
  //   return this.storage.then((SharedPreferences prefs) => prefs.setStringList(
  //       'patientAppointmentsList', patientAppointmentsList));
  // }

  // Future<Object> getPatientAppointmentsList() {
  //   return this.storage.then((SharedPreferences prefs) =>
  //       prefs.getStringList('patientAppointmentsList'));
  // }

  // Future<Object> removePatientAppointmentsList() {
  //   return this.storage.then(
  //       (SharedPreferences prefs) => prefs.remove('patientAppointmentsList'));
  // }

  // Future<Object> setPatientAppointmentsHistory(patientAppointmentsHistory) {
  //   return this.storage.then((SharedPreferences prefs) => prefs.setString(
  //       'patientAppointmentsHistory', patientAppointmentsHistory));
  // }

  // Future<Object> getPatientAppointmentsHistory() {
  //   return this.storage.then(
  //       (SharedPreferences prefs) => prefs.get('patientAppointmentsHistory'));
  // }

  // Future<Object> removePatientAppointmentsHistory() {
  //   return this.storage.then((SharedPreferences prefs) =>
  //       prefs.remove('patientAppointmentsHistory'));
  // }

  // Future<Object> setDoctorAppointmentsList(doctorAppointmentsList) {
  //   return this.storage.then((SharedPreferences prefs) =>
  //       prefs.setStringList('doctorAppointmentsList', doctorAppointmentsList));
  // }

  // Future<Object> getDoctorAppointmentsList() {
  //   return this.storage.then((SharedPreferences prefs) =>
  //       prefs.getStringList('doctorAppointmentsList'));
  // }

  // Future<Object> removeDoctorAppointmentsList() {
  //   return this.storage.then(
  //       (SharedPreferences prefs) => prefs.remove('doctorAppointmentsList'));
  // }

  // Future<Object> setPatientProfile(patientProfile) {
  //   return this.storage.then((SharedPreferences prefs) =>
  //       prefs.setString('patientProfile', patientProfile));
  // }

  // Future<Object> getPatientProfile() {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.get('patientProfile'));
  // }

  // Future<Object> setDoctorProfile(doctorProfile) {
  //   return this.storage.then((SharedPreferences prefs) =>
  //       prefs.setString('doctorProfile', doctorProfile));
  // }

  // Future<Object> getDoctorProfile() {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.get('doctorProfile'));
  // }

  // Future<Object> setSelectedDoctor(selectedDoctor) {
  //   return this.storage.then((SharedPreferences prefs) =>
  //       prefs.setString('selectedDoctor', selectedDoctor));
  // }

  // Future<Object> getSelectedDoctor() {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.get('selectedDoctor'));
  // }

  // Future<Object> removeSelectedDoctor() {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.remove('selectedDoctor'));
  // }

  // Future<Object> removeLocations() {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.remove('locations'));
  // }

  // Future<Object> setSelectedLocation(selectedLocation) {
  //   return this.storage.then((SharedPreferences prefs) =>
  //       prefs.setString('selectedLocation', selectedLocation));
  // }

  // Future<Object> getSelectedLocation() {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.get('selectedLocation'));
  // }

  // Future<Object> removeSelectedLocation() {
  //   return this
  //       .storage
  //       .then((SharedPreferences prefs) => prefs.remove('selectedLocation'));
  // }

//  Future<dynamic> setSchedules(schedules) {
//    return this._prefs.then((SharedPreferences prefs) =>
//        prefs.setStringList('schedules', schedules));
//  }
//
//  Future<dynamic> getSchedules() {
//    return this
//        ._prefs
//        .then((SharedPreferences prefs) => prefs.getStringList('schedules'));
//  }

// Future<Object> removeSchedules() {
//   return this
//       .storage
//       .then((SharedPreferences prefs) => prefs.remove('schedules'));
// }
}
