class AppointmentModel {
  final String remainingTime;
  final String slotTime;
  final String doctorName;
  final String date;
  final String location;
  final String fee;

  AppointmentModel(
      {this.remainingTime,
      this.slotTime,
      this.doctorName,
      this.date,
      this.fee,
      this.location});
}

final appoint = [
  AppointmentModel(
    remainingTime: "9 Hours",
    slotTime: "03:00 PM",
    doctorName: "Dr. khalid Mehmood",
    date: "25-3-2020",
    location: "Nazimabad No.5",
    fee: "Rs.1000",
  ),
  AppointmentModel(
    remainingTime: "1 Week",
    slotTime: "09:00 PM",
    doctorName: "Dr. Ahtisham",
    date: "25-3-2020",
    location: "Gulshan",
    fee: "Rs.1200",
  ),
  AppointmentModel(
    remainingTime: "3 Days",
    slotTime: "08:30 PM",
    doctorName: "Dr. Sarwar",
    date: "1-6-2020",
    location: "Nazimabad No.5",
    fee: "Rs.800",
  ),
];
