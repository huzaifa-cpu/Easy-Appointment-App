import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/slot_model.dart';
import 'package:flutter_ea_mobile_app/services/appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/email_service.dart';
import 'package:flutter_ea_mobile_app/services/notification_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_service.dart';
import 'package:flutter_ea_mobile_app/services/session_service.dart';
import 'package:flutter_ea_mobile_app/services/sms_service.dart';
import 'package:flutter_ea_mobile_app/services/utils_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

class AppointmentStatusConfirmation extends StatefulWidget {
  String title1;
  String title2;
  Color titleColor1;
  Color titleColor2;
  Function onPressed3;
  Slot slot;
  DoctorAppointmentsProvider doctorAppointmentsProvider;
  SlotsProvider slotsProvider;

  AppointmentStatusConfirmation(
      {this.title1,
      this.title2,
      this.slot,
      this.titleColor1,
      this.titleColor2,
      this.onPressed3,
      this.slotsProvider,
      this.doctorAppointmentsProvider});

  @override
  _AppointmentStatusConfirmationState createState() =>
      _AppointmentStatusConfirmationState();
}

class _AppointmentStatusConfirmationState
    extends State<AppointmentStatusConfirmation> {
  AppointmentService appointmentService = AppointmentService();
  EmailService emailService = EmailService();
  PatientService patientService = PatientService();
  PatientAppointmentService patientAppointmentService =
      PatientAppointmentService();
  SessionService sessionService = SessionService();
  NotificationService notificationService = NotificationService();
  CustomToast _toast = CustomToast();
  SmsService smsService = SmsService();

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();
  Utils utils = Utils();
  CustomStrings _strings = CustomStrings();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Consumer2<SlotsProvider, DoctorAppointmentsProvider>(
          builder:
              (context, slotsProvider, doctorAppointmentsProvider, child) =>
                  Container(
            height: 130,
            decoration: BoxDecoration(
                color: _colors.greyTheme,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                )),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: widget.onPressed3,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 50,
                    color: _colors.grey,
                  ),
                ),
                Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 45.0,
                        width: 150.0,
                        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        child: NeuButton(
                          decoration: NeumorphicDecoration(
                              color: _colors.greyTheme,
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () async {
                            bool isConnected = await CheckInternet()
                                .isInternetConnected(context);
                            if (isConnected == true) {
                              setState(() {
                                isLoading = true;
                              });
                              // Cancel Booking

                              print(
                                  "doctorAppointmentBySlotNumber: ${widget.slot.appointment}");
                              if (widget.slot.appointment != null) {
                                // LOADING
                                Appointment appointment = Appointment(
                                  id: widget.slot.appointment.id,
                                  slotNumber:
                                      widget.slot.appointment.slotNumber,
                                  slotDate: widget.slot.appointment.slotDate,
                                  slotTime: widget.slot.appointment.slotTime,
                                  fee: widget.slot.appointment.fee,
                                  createdByDoctor:
                                      widget.slot.appointment.createdByDoctor,
                                  createdDate:
                                      widget.slot.appointment.createdDate,
                                  bookingDate:
                                      widget.slot.appointment.bookingDate,
                                  updatedDate: utils.getCurrentDate(),
                                  cancelledDate: utils.getCurrentDate(),
                                  state: true,
                                  location: widget.slot.appointment.location,
                                  doctor: widget.slot.appointment.doctor,
                                  patient: widget.slot.appointment.patient,
                                  status: _strings.slotStatusCancelled,
                                  updatedBy:
                                      widget.slot.appointment.doctor.user,
                                  createdBy: widget.slot.appointment.createdBy,
                                );
                                Appointment appointmentFromResponse =
                                    await appointmentService
                                        .updateAppointmentStatus(appointment,
                                            widget.slot.appointment.id);

                                doctorAppointmentsProvider
                                    .updateAppointment(appointmentFromResponse);

                                //EMAIL-TO-PATIENT
                                String toPatient =
                                    appointmentFromResponse.patient.user.email;
                                String namePatient = appointmentFromResponse
                                    .patient.user.fullName;
                                String nameDoctor = appointmentFromResponse
                                    .doctor.user.fullName;
                                String datePatient =
                                    appointmentFromResponse.slotDate;
                                String timePatient = utils
                                    .durationToString(appointment.slotTime);

                                await emailService.appointmentStatus(
                                    to: toPatient,
                                    name: namePatient,
                                    secondName: nameDoctor,
                                    status: _strings.slotStatusCancelled,
                                    date: datePatient,
                                    time: timePatient);

                                // Patient Notifications
                                DateTime slotDate = DateTime.parse(
                                    appointmentFromResponse.slotDate);
                                String notificationTitle =
                                    "Appointment Cancelled by Doctor ${appointmentFromResponse.doctor.user.fullName ?? ''}";
                                String notificationMessage =
                                    "Your appointment ${appointmentFromResponse.slotNumber} with Doctor ${appointmentFromResponse.doctor.user.fullName ?? ''}, on ${slotDate.day}/${slotDate.month}/${slotDate.year} at ${appointmentFromResponse.location.name}, has been cancelled";
                                await notificationService
                                    .sendNotificationsToAllDevices(
                                        user: appointmentFromResponse
                                            .patient.user,
                                        title: notificationTitle,
                                        message: notificationMessage);

                                //EMAIL-TO-DOCTOR
                                String doctorEmail =
                                    appointmentFromResponse.doctor.user.email;

                                await emailService.appointmentStatus(
                                    to: doctorEmail,
                                    status: _strings.slotStatusCancelled,
                                    name: nameDoctor,
                                    secondName: namePatient,
                                    date: datePatient,
                                    time: timePatient);
                                //SMS
                                String message =
                                    "Dear $namePatient, your appointment with $nameDoctor on $datePatient at $timePatient has been cancelled.";
                                String val =
                                    appointmentFromResponse.patient.user.phone;
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
                                throw "can't cancel appointment";
                              }

                              slotsProvider
                                  .updateSlotByCancelledStatus(widget.slot);
                              _toast.showToast("Booking Cancelled");
                              Navigator.pop(context);
                            } else {
                              _toast.showDangerToast(
                                  "Please check your internet connection");
                            }
                          },
                          child: Text(
                            widget.title1,
                            textScaleFactor: 1.3,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.titleColor1,
                              fontFamily: "CenturyGothic",
                              fontSize: 8.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 45.0,
                        width: 150.0,
                        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        child: NeuButton(
                          decoration: NeumorphicDecoration(
                              color: _colors.greyTheme,
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () async {
                            // Complete Booking
                            bool isConnected = await CheckInternet()
                                .isInternetConnected(context);
                            if (isConnected == true) {
                              if (widget.slot.appointment != null) {
                                setState(() {
                                  isLoading = true;
                                });
                                Appointment appointment = Appointment(
                                  slotNumber:
                                      widget.slot.appointment.slotNumber,
                                  slotDate: widget.slot.appointment.slotDate,
                                  slotTime: widget.slot.appointment.slotTime,
                                  fee: widget.slot.appointment.fee,
                                  createdByDoctor:
                                      widget.slot.appointment.createdByDoctor,
                                  createdDate:
                                      widget.slot.appointment.createdDate,
                                  bookingDate:
                                      widget.slot.appointment.bookingDate,
                                  completedDate: utils.getCurrentDate(),
                                  updatedDate: utils.getCurrentDate(),
                                  cancelledDate:
                                      widget.slot.appointment.cancelledDate,
                                  state: true,
                                  location: widget.slot.appointment.location,
                                  doctor: widget.slot.appointment.doctor,
                                  patient: widget.slot.appointment.patient,
                                  status: _strings.slotStatusCompleted,
                                  updatedBy:
                                      widget.slot.appointment.doctor.user,
                                  createdBy: widget.slot.appointment.createdBy,
                                );
                                Appointment appointmentFromResponse =
                                    await appointmentService
                                        .updateAppointmentStatus(appointment,
                                            widget.slot.appointment.id);
                                print(
                                    "appointmentFromResponse.status: ${appointmentFromResponse.status}");

                                doctorAppointmentsProvider
                                    .updateAppointment(appointmentFromResponse);

                                slotsProvider.updateSlotByCompletedStatus(
                                    widget.slot, appointmentFromResponse);

                                String to =
                                    appointmentFromResponse.patient.user.email;
                                String name = appointmentFromResponse
                                    .patient.user.fullName;
                                String nameDoctor = appointmentFromResponse
                                    .doctor.user.fullName;
                                String datePatient =
                                    appointmentFromResponse.slotDate;
                                String timePatient = utils
                                    .durationToString(appointment.slotTime);
                                await emailService.appointmentStatus(
                                    to: to,
                                    status: _strings.slotStatusCompleted,
                                    name: name,
                                    secondName: nameDoctor,
                                    date: datePatient,
                                    time: timePatient);

                                // Patient Notifications
                                DateTime slotDate = DateTime.parse(
                                    appointmentFromResponse.slotDate);
                                String notificationTitle =
                                    "Appointment Completed";
                                String notificationMessage =
                                    "Your appointment ${appointmentFromResponse.slotNumber} with Doctor ${appointmentFromResponse.doctor.user.fullName ?? ''}, on ${slotDate.day}/${slotDate.month}/${slotDate.year} at ${appointmentFromResponse.location.name}, has been completed";
                                await notificationService
                                    .sendNotificationsToAllDevices(
                                        user: appointmentFromResponse
                                            .patient.user,
                                        title: notificationTitle,
                                        message: notificationMessage);
                              } else {
                                throw "can't complete appointment";
                              }

                              _toast.showToast("Booking Completed");
                              Navigator.pop(context);
                            } else {
                              _toast.showDangerToast(
                                  "Please check your internet connection");
                            }
                          },
                          child: Text(
                            widget.title2,
                            textScaleFactor: 1.3,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: widget.titleColor2,
                              fontFamily: "CenturyGothic",
                              fontSize: 8.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                  ],
                ),
              ],
            ),
            // For Loading
          ),
        ),
        isLoading
            ? Opacity(
                opacity: 0.7,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: _colors.greyTheme),
                ),
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
    );
  }
}
