class LocationModel {
  final String address;
  String time;
  String fee;

  LocationModel({this.address, this.time, this.fee});
}

final location = [
  LocationModel(
    address: "Gulistan-e-Jauhar, Block-5",
    time: "3PM - 7PM",
    fee: "Rs.1000",
  ),
  LocationModel(address: "Nazimabad No.2", time: "8PM - 11PM", fee: "Rs.1200"),
];
