import 'package:flutter/foundation.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';

class LocationsProvider extends ChangeNotifier {
  List<Location> _locations = [];

  List<Location> get locations => _locations;

  set locations(List<Location> value) {
    _locations = value;
    notifyListeners();
  }

  //METHODS

  void updateLocation(Location location) {
    _locations.forEach((_location) {
      if (_location.id == location.id) {
        _location.name = location.name;
        notifyListeners();
        _location.address = location.address;
        notifyListeners();
        _location.fee = location.fee;
        notifyListeners();
        _location.status = location.status;
        notifyListeners();
      }
    });
  }

  void addLocation(Location location) {
    _locations.add(location);
    notifyListeners();
  }

  String getLocationName(Location location) {
    String locationName;
    _locations.forEach((_location) {
      if (_location.id == location.id) {
        locationName = _location.name;
      }
    });
    return locationName;
  }

  void setEmptyLocations() {
    _locations = [];
  }

  List<Location> getLocationsWithSchedules() {
    List<Location> locationsWithSchedules = [];
    _locations.forEach((_location) {
      if (_location.schedules.length != 0) {
        locationsWithSchedules.add(_location);
      }
    });
    return locationsWithSchedules;
  }
}
