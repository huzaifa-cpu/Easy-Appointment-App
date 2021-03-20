import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/patient_model.dart';
import 'package:flutter_ea_mobile_app/models/slot_model.dart';
import 'package:flutter_ea_mobile_app/models/user_model.dart';
import 'package:flutter_ea_mobile_app/services/appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/doctor_service.dart';
import 'package:flutter_ea_mobile_app/services/email_service.dart';
import 'package:flutter_ea_mobile_app/services/location_service.dart';
import 'package:flutter_ea_mobile_app/services/notification_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_service.dart';
import 'package:flutter_ea_mobile_app/services/session_service.dart';
import 'package:flutter_ea_mobile_app/services/sms_service.dart';
import 'package:flutter_ea_mobile_app/services/utils_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_textfield.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class GetOrCreatePatientByDoctor extends StatefulWidget {
  String title;
  String hint;
  String submitButtonName;
  Slot slot;
  Location location;

  GetOrCreatePatientByDoctor(
      {this.title, this.hint, this.submitButtonName, this.slot, this.location});

  @override
  _GetOrCreatePatientByDoctorState createState() =>
      _GetOrCreatePatientByDoctorState();
}

class _GetOrCreatePatientByDoctorState
    extends State<GetOrCreatePatientByDoctor> {
  NotificationService notificationService = NotificationService();
  CustomToast _toast = CustomToast();
  SessionService sessionService = SessionService();

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  CustomStrings _strings = CustomStrings();

  Utils utils = Utils();

  PatientService patientService = PatientService();
  DoctorService doctorService = DoctorService();
  LocationService locationService = LocationService();
  AppointmentService appointmentService = AppointmentService();
  EmailService emailService = EmailService();
  SmsService smsService = SmsService();

  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();

  Location location;
  Doctor doctor;
  User user;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<DoctorAppointmentsProvider, SlotsProvider>(
      builder: (context, doctorAppointmentsProvider, slotsProvider, child) =>
          Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: _colors.greyTheme,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                )),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 50,
                      color: _colors.grey,
                    ),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: _sizes.smallTextSize,
                      fontWeight: FontWeight.bold,
                      color: _colors.grey,
                      fontFamily: "CenturyGothic",
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomTextField(
                    hint: "Enter 11-digits phone eg.03222222222",
                    type: TextInputType.phone,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    textEditingController: _phoneController,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  CustomButton(
                    name: widget.submitButtonName,
                    pressed: () async {
                      bool isConnected =
                          await CheckInternet().isInternetConnected(context);
                      if (isConnected == true) {
                        if (_phoneController.text.isNotEmpty &&
                            _phoneController.text.length > 10 &&
                            _phoneController.text.length < 12) {
                          // if (_phoneController.text.isNotEmpty) {
                          setState(() {
                            isLoading = true;
                          });
                          Patient patient = await patientService
                              .getOrCreatePatient(_phoneController.text);
                          location = await locationService
                              .getLocationById(widget.location.id);
                          doctor = await doctorService.getDoctor();
                          if (patient != null) {
                            Appointment appointment = Appointment(
                              slotNumber: widget.slot.number,
                              slotDate:
                                  utils.getFormattedDate(widget.slot.date),
                              slotTime: widget.slot.timeInMinutes,
                              fee: location.fee,
                              createdByDoctor: true,
                              createdDate: utils.getCurrentDate(),
                              bookingDate: utils.getCurrentDate(),
                              updatedDate: utils.getCurrentDate(),
                              state: true,
                              location: location,
                              doctor: doctor,
                              patient: patient,
                              status: _strings.slotStatusBooked,
                              updatedBy: doctor.user,
                              createdBy: doctor.user,
                            );
                            Appointment appointmentFromResponse =
                                await appointmentService
                                    .createAppointment(appointment);

                            doctorAppointmentsProvider
                                .addDoctorAppointment(appointmentFromResponse);

                            slotsProvider.updateSlotByBookedStatus(
                                widget.slot, appointmentFromResponse);

                            //EMAIL-TO-PATIENT
                            String toPatient = patient.user.email;
                            String namePatient = patient.user.fullName;
                            String nameDoctor = location.doctor.user.fullName;
                            String datePatient =
                                utils.getFormattedDate(widget.slot.date);
                            String timePatient = utils
                                .durationToString(widget.slot.timeInMinutes);
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
                            //SMS
                            String message =
                                "Dear $namePatient, your appointment with $nameDoctor on $datePatient at $timePatient has been Booked.";
                            String val = patient.user.phone;
                            String phone = val.replaceAll("+", "");

                            // Patient Notifications
                            String notificationTitle = "Appointment Scheduled";
                            String notificationMessage =
                                "${doctor.titlesStr ?? ''} ${doctor.user.fullName ?? "Doctor"} has scheduled an appointment ${appointmentFromResponse.slotNumber} for you on ${widget.slot.date.day}/${widget.slot.date.month}/${widget.slot.date.year}";
                            await notificationService
                                .sendNotificationsToAllDevices(
                                    user: appointmentFromResponse.patient.user,
                                    title: notificationTitle,
                                    message: notificationMessage);

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

                            Navigator.pop(context);
                          } else {
                            throw "can't get or create patient by doctor";
                          }
                        } else {
                          _toast.showToast("Phone may empty or invalid");
                        }
                      } else {
                        _toast.showDangerToast(
                            "Please check your internet connection");
                      }
                    },
                    color: _colors.green,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),

          // For Loading
          isLoading
              ? Opacity(
                  opacity: 0.7,
                  child: Container(
                    height: 200.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: _colors.greyTheme,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                        )),
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
      ),
    );
  }
}
