import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_textfield.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ea_mobile_app/services/notification_service.dart';

class JazzCashMobileScreen extends StatefulWidget {
  JazzCashMobileScreen(
      {this.location, this.time, this.date, this.slot, this.currentDates});

  Location location;
  String time;
  String date;
  Slot slot;
  String currentDates;
  @override
  _JazzCashMobileScreenState createState() => _JazzCashMobileScreenState();
}

class _JazzCashMobileScreenState extends State<JazzCashMobileScreen> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //TOAST
  CustomToast _toast = CustomToast();

  CustomStrings _strings = CustomStrings();
  bool isLoading = false;

  var phoneController = TextEditingController();
  var cnicController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AppointmentService appointmentService = AppointmentService();
  EmailService emailService = EmailService();
  JazzCashService jazzCashService = JazzCashService();
  PaymentService paymentService = PaymentService();
  PatientService patientService = PatientService();
  LocalNotificationService localNotificationService =
      LocalNotificationService();
  SmsService smsService = SmsService();
  NotificationService notificationService = NotificationService();

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
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
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
                          "With : ${widget.location.doctor.user.fullName}",
                          style: TextStyle(
                              fontSize: 15,
                              color: _colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Fee : ${_strings.pakistaniCurrency}. ${widget.location.fee}",
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
                          "Date : ${widget.date}",
                          style: TextStyle(
                              fontSize: 15,
                              color: _colors.grey,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Time : ${widget.time}",
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
                  "Payment via Mobile",
                  style: TextStyle(
                      fontSize: 18,
                      color: _colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20.0,
                ),
                CustomTextField(
                  hint: "Enter phone no eg.03331234567",
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  type: TextInputType.number,
                  textEditingController: phoneController,
                ),
                SizedBox(
                  height: 25.0,
                ),
                CustomTextField(
                  hint: "Enter last 6 digits of NIC no.",
                  type: TextInputType.number,
                  inputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  ],
                  textEditingController: cnicController,
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
                      if (phoneController.text.isNotEmpty &&
                          cnicController.text.isNotEmpty &&
                          phoneController.text.length > 10 &&
                          phoneController.text.length < 12 &&
                          cnicController.text.length > 5) {
                        setState(() {
                          isLoading = true;
                        });
                        String responseCode =
                            await jazzCashService.postPaymentViaMobile(
                                phoneController.text,
                                cnicController.text,
                                widget.location.fee.toString());
                        if (responseCode == "000") {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          int patientId = prefs.getInt("doctorId");
                          Patient patient =
                              await patientService.getPatientById(patientId);
                          Appointment appointment = Appointment(
                            slotNumber: widget.slot.number,
                            slotDate: getFormattedDate(widget.slot.date),
                            slotTime: widget.slot.timeInMinutes,
                            fee: widget.location.fee,
                            createdByDoctor: false,
                            createdDate: widget.currentDates,
                            bookingDate: widget.currentDates,
                            updatedDate: widget.currentDates,
                            paymentDate: widget.currentDates,
                            state: true,
                            location: widget.location,
                            doctor: widget.location.doctor,
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
                            amount: widget.location.fee,
                            type: "Mobile account",
                            appointment: appointmentFromResponse,
                            state: true,
                            status: "Active",
                            createdDate: widget.currentDates,
                            updatedDate: widget.currentDates,
                          );
                          await paymentService.createPayment(payment);
//                    slotsProvider.updateSlotStatus(widget.slot,
//                        _strings.slotStatusBooked, widget.location.id);
                          widget.slot.disable = true;

                          // Patient Notifications
                          DateTime slotDate =
                              DateTime.parse(appointmentFromResponse.slotDate);
                          String notificationTitle = "Appointment Scheduled";
                          String notificationMessage =
                              "Your appointment ${appointmentFromResponse.slotNumber} with Doctor ${appointmentFromResponse.doctor.user.fullName ?? ''}, on ${slotDate.day}/${slotDate.month}/${slotDate.year} at ${appointmentFromResponse.location.name}, has been scheduled";
                          await notificationService
                              .sendNotificationsToAllDevices(
                                  user: appointmentFromResponse.patient.user,
                                  title: notificationTitle,
                                  message: notificationMessage);

                          // Doctor Notifications
                          String doctorNotificationMessage =
                              "${appointmentFromResponse.patient.user.fullName ?? "Patient"} has scheduled an appointment ${appointmentFromResponse.slotNumber} with you on ${slotDate.day}/${slotDate.month}/${slotDate.year} at ${appointmentFromResponse.location.name}";
                          await notificationService
                              .sendNotificationsToAllDevices(
                                  user: appointmentFromResponse.doctor.user,
                                  title: notificationTitle,
                                  message: doctorNotificationMessage);
                          //EMAIL-TO-PATIENT
                          String toPatient = patient.user.email;
                          String namePatient = patient.user.fullName;
                          String nameDoctor =
                              widget.location.doctor.user.fullName;
                          String datePatient = widget.slot.date.toString();
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
                          String doctorEmail =
                              widget.location.doctor.user.email;

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
                            String phoneWithCountryCode =
                                "92$filterPhone".trim();
                            print(phoneWithCountryCode);
                            await smsService.sendSMS(
                                phoneWithCountryCode, message);
                            print("SMS is sent");
                          } else {
                            print(
                                "phone number is not correct for sending SMS");
                          }
                        } else {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          _toast.showToast("Transaction cancelled");
                        }
                        phoneController.clear();
                        cnicController.clear();
                      } else {
                        _toast.showToast("Data may invalid or empty");
                      }
                    } else {
                      _toast.showDangerToast(
                          "Please check your internet connection");
                    }
                  },
                ),
              ],
            ),
          ),
          // For Loading
          isLoading
              ? Opacity(
                  opacity: 0.7,
                  child: Scaffold(backgroundColor: _colors.greyTheme),
                )
              : SizedBox(
                  height: 0.0,
                ),
          isLoading
              ? CustomLoading()
              : SizedBox(
                  height: 0.0,
                ),
        ],
      ),
    );
  }
}
