import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';

class ProfileProvider extends ChangeNotifier {
  User _user = User(
    id: 0,
    fullName: "",
    email: "",
    type: "",
    landingUrl: "",
    phone: "",
    gender: "",
    username: "",
    password: "",
    avatar: "",
    state: true,
    status: "",
    createdDate: "",
    updatedDate: "",
//    role: "",
  );

  Future updateId(int id) async {
    _user.id = id;
    notifyListeners();
  }

  Future updateLandingUrl(String landingUrl) async {
    _user.landingUrl = landingUrl;
    notifyListeners();
  }

  Future updateGender(String gender) async {
    _user.gender = gender;
    notifyListeners();
  }

  Future updateUsername(String username) async {
    _user.username = username;
    notifyListeners();
  }

  Future updatePassword(String password) async {
    _user.password = password;
    notifyListeners();
  } //dummy data, must enter all fields of user

  Future updateStatus(String status) async {
    _user.status = status;
    notifyListeners();
  }

  Future updateCreatedDate(String createdDate) async {
    _user.createdDate = createdDate;
    notifyListeners();
  }

  Future updateUpdatedDate(String updatedDate) async {
    _user.updatedDate = updatedDate;
    notifyListeners();
  }

//  Future updateRole(dynamic role) async {
//    _user.role = role;
//    notifyListeners();
//  }

  Future updateEmail(String email) async {
    _user.email = email;
    notifyListeners();
  }

  Future updatePhone(String phone) async {
    _user.phone = phone;
    notifyListeners();
  }

  Future updateAvatar(String avatar) async {
    _user.avatar = avatar;
    notifyListeners();
  }

  Future updateType(String type) async {
    _user.type = type;
    notifyListeners();
  }

  Future updateState(bool state) async {
    _user.state = state;
    notifyListeners();
  }

  Future updateName(String fullName) async {
    _user.fullName = fullName;
    notifyListeners();
  }

  User get user => _user;

  Future users(User value) async {
    _user = value;
    notifyListeners();
  }

  set user(dynamic value) {
    _user = value;
    notifyListeners();
  }
}
