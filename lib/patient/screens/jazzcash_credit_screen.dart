import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/patient_model.dart';
import 'package:flutter_ea_mobile_app/models/payment_model/payment_model.dart';
import 'package:flutter_ea_mobile_app/models/slot_model.dart';
import 'package:flutter_ea_mobile_app/services/appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/email_service.dart';
import 'package:flutter_ea_mobile_app/services/local_notification_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_service.dart';
import 'package:flutter_ea_mobile_app/services/payment_service/jazz_cash_service.dart';
import 'package:flutter_ea_mobile_app/services/payment_service/payment_service.dart';
import 'package:flutter_ea_mobile_app/services/sms_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_textfield.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ea_mobile_app/services/notification_service.dart';

class JazzCashCreditScreen extends StatelessWidget {
  JazzCashCreditScreen(
      {this.location, this.time, this.date, this.slot, this.currentDates});
  Location location;
  String time;
  String date;
  Slot slot;
  String currentDates;
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //TOAST
  CustomToast _toast = CustomToast();

  CustomStrings _strings = CustomStrings();

  var cardNoController = TextEditingController();
  var cvvNoController = TextEditingController();
  var expiryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AppointmentService appointmentService = AppointmentService();
  EmailService emailService = EmailService();
  JazzCashService jazzCashService = JazzCashService();
  PaymentService paymentService = PaymentService();
  PatientService patientService = PatientService();
  LocalNotificationService localNotificationService =
      LocalNotificationService();
  NotificationService notificationService = NotificationService();
  SmsService smsService = SmsService();

  String getFormattedDate(DateTime date) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(date);
    return formattedDate;
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    if (int.parse(parts[0]) > 12) {
      String hour = (int.parse(parts[0]) % 12).toString();
      return '${hour.padLeft(2, '0')}:${parts[1].padLeft(2, '0')} PM';
    }
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')} AM';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.greyTheme,
      appBar: CustomAppBar(
        notificationButton: false,
        notificationButtonPressed: () {},
        backButtonPressed: () {},
        logoutButton: false,
        title: "Payment",
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ListView(
          children: [
            Text(
              "Appointment details",
              style: TextStyle(
                  fontSize: 18,
                  color: _colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "With : ${location.doctor.user.fullName}",
                      style: TextStyle(
                          fontSize: 15,
                          color: _colors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Fee : ${location.fee}/=",
                      style: TextStyle(
                          fontSize: 15,
                          color: _colors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Date : $date",
                      style: TextStyle(
                          fontSize: 15,
                          color: _colors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Time : $time",
                      style: TextStyle(
                          fontSize: 15,
                          color: _colors.grey,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
              "Payment via Credit/Debit card",
              style: TextStyle(
                  fontSize: 18,
                  color: _colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20.0,
            ),
            CustomTextField(
              hint: "Enter card no.",
              type: TextInputType.number,
              textEditingController: cardNoController,
            ),
            SizedBox(
              height: 25.0,
            ),
            CustomTextField(
              hint: "Enter 3 digit CVV no.",
              type: TextInputType.number,
              textEditingController: cvvNoController,
            ),
            SizedBox(
              height: 25.0,
            ),
            CustomTextField(
              hint: "Enter expiry of card eg. MonthYear",
              type: TextInputType.number,
              textEditingController: expiryController,
            ),
            SizedBox(
              height: 25,
            ),
            CustomButton(
              color: _colors.green,
              name: "Pay",
              pressed: () async {
                bool isConnected =
                    await CheckInternet().isInternetConnected(context);
                if (isConnected == true) {
                  if (cardNoController.text.isNotEmpty &&
                      cvvNoController.text.isNotEmpty &&
                      expiryController.text.isNotEmpty) {
                    // Navigator.push(
                    //     context, // ROUTING
                    //     MaterialPageRoute(builder: (context) => CustomLoading()));
                    print(cardNoController.text.trim());
                    print(cvvNoController.text.trim());
                    print(expiryController.text.trim());
                    print(location.fee.toString());
                    String responseCode =
                        await jazzCashService.postPaymentViaCredit(
                            cardNo: cardNoController.text.trim(),
                            cvvNo: cvvNoController.text.trim(),
                            expiry: expiryController.text.trim(),
                            amount: location.fee.toString());
                    if (responseCode == "000") {
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      int patientId = prefs.getInt("doctorId");
                      Patient patient =
                          await patientService.getPatientById(patientId);
                      Appointment appointment = Appointment(
                        slotNumber: slot.number,
                        slotDate: getFormattedDate(slot.date),
                        slotTime: slot.timeInMinutes,
                        fee: location.fee,
                        createdByDoctor: false,
                        createdDate: currentDates,
                        bookingDate: currentDates,
                        updatedDate: currentDates,
                        paymentDate: currentDates,
                        state: true,
                        location: location,
                        doctor: location.doctor,
                        patient: patient,
                        status: _strings.slotStatusBooked,
                        updatedBy: patient.user,
                        createdBy: patient.user,
                      );
                      Appointment appointmentFromResponse =
                          await appointmentService
                              .createAppointment(appointment);
                      Payment payment = Payment(
                        name: "Jazz cash",
                        amount: location.fee,
                        type: "Credit/Debit card",
                        appointment: appointmentFromResponse,
                        state: true,
                        status: "Active",
                        createdDate: currentDates,
                        updatedDate: currentDates,
                      );
                      await paymentService.createPayment(payment);
//                    slotsProvider.updateSlotStatus(widget.slot,
//                        _strings.slotStatusBooked, widget.location.id);
                      slot.disable = true;
                      // Patient Notifications
                      DateTime slotDate =
                          DateTime.parse(appointmentFromResponse.slotDate);
                      String notificationTitle = "Appointment Scheduled";
                      String notificationMessage =
                          "Your appointment ${appointmentFromResponse.slotNumber} with Doctor ${appointmentFromResponse.doctor.user.fullName ?? ''}, on ${slotDate.day}/${slotDate.month}/${slotDate.year} at ${appointmentFromResponse.location.name}, has been scheduled";
                      await notificationService.sendNotificationsToAllDevices(
                          user: appointmentFromResponse.patient.user,
                          title: notificationTitle,
                          message: notificationMessage);

                      // Doctor Notifications
                      String doctorNotificationMessage =
                          "${appointmentFromResponse.patient.user.fullName ?? "Patient"} has scheduled an appointment ${appointmentFromResponse.slotNumber} with you on ${slotDate.day}/${slotDate.month}/${slotDate.year} at ${appointmentFromResponse.location.name}";
                      await notificationService.sendNotificationsToAllDevices(
                          user: appointmentFromResponse.doctor.user,
                          title: notificationTitle,
                          message: doctorNotificationMessage);
                      //EMAIL-TO-PATIENT
                      String toPatient = patient.user.email;
                      String namePatient = patient.user.fullName;
                      String nameDoctor = location.doctor.user.fullName;
                      String datePatient = slot.date.toString();
                      String timePatient =
                          durationToString(appointment.slotTime);
                      await emailService.appointmentStatus(
                          to: toPatient,
                          name: namePatient,
                          secondName: nameDoctor,
                          status: _strings.slotStatusBooked,
                          date: datePatient,
                          time: timePatient);
                      //EMAIL-TO-DOCTOR
                      String doctorEmail = location.doctor.user.email;

                      await emailService.appointmentStatus(
                          to: doctorEmail,
                          name: nameDoctor,
                          secondName: namePatient,
                          status: _strings.slotStatusBooked,
                          date: datePatient,
                          time: timePatient);

                      // Local Notification
//                    await localNotificationService
//                        .showNotificationsAfterSecond();

                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      _toast.showToast(
                          "Your appointment has been booked successfully");
                      //SMS
                      String message =
                          "Dear $namePatient, your appointment with $nameDoctor on $datePatient at $timePatient has been Booked.";
                      String val = patient.user.phone;
                      String phone = val.replaceAll("+", "");
                      if (phone[0] == "9" && phone.length == 12) {
                        await smsService.sendSMS(phone, message);
                        print("SMS is sent");
                      } else if (phone[0] == "0") {
                        String filterPhone = phone.substring(
                          1,
                        );
                        String phoneWithCountryCode = "92$filterPhone".trim();
                        print(phoneWithCountryCode);
                        await smsService.sendSMS(phoneWithCountryCode, message);
                        print("SMS is sent");
                      } else {
                        print("phone number is not correct for sending SMS");
                      }
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      _toast.showToast("Transaction cancelled");
                    }
                    cardNoController.clear();
                    cvvNoController.clear();
                    expiryController.clear();
                  } else {
                    _toast.showToast("Data may invalid or empty");
                  }
                } else {
                  _toast
                      .showDangerToast("Please check your internet connection");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
