import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointment_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/history_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/slot_model.dart';
import 'package:flutter_ea_mobile_app/services/appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/email_service.dart';
import 'package:flutter_ea_mobile_app/services/notification_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/session_service.dart';
import 'package:flutter_ea_mobile_app/services/sms_service.dart';
import 'package:flutter_ea_mobile_app/services/utils_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

class PatientScheduleAppointment extends StatefulWidget {
  @override
  _PatientScheduleAppointmentState createState() =>
      _PatientScheduleAppointmentState();
}

class _PatientScheduleAppointmentState
    extends State<PatientScheduleAppointment> {
  PatientAppointmentService appointmentService = PatientAppointmentService();
  CustomToast _toast = CustomToast();

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppointmentListProvider>(
        builder: (context, appointmentsProvider, child) {
      if (appointmentsProvider.appointments.length != 0) {
        return ListView.builder(
            itemCount: appointmentsProvider.appointments.length,
            itemBuilder: (BuildContext context, int i) {
              return ScheduleCard(
                appoints: appointmentsProvider.appointments[i],
              );
            });
      } else {
        return Center(
            child: Text(
          "No appointments yet",
          style: TextStyle(color: _colors.grey),
        ));
      }
    });
  }
}

class ScheduleCard extends StatelessWidget {
  CustomToast _toast = CustomToast();

  CustomStrings _strings = CustomStrings();

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  Utils utils = Utils();

  ScheduleCard({this.appoints});

  final Appointment appoints;

  @override
  Widget build(BuildContext context) {
    void cancel() {
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (BuildContext context) {
            return Cancel(
              appointment: appoints,
            );
          });
    }

    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        NeuCard(
          margin: EdgeInsets.only(left: 16, right: 16),
          bevel: 9,
          color: Color(0xFFECF0F3),
          curveType: CurveType.flat,
          decoration: NeumorphicDecoration(
              color: _colors.greyTheme,
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: EdgeInsets.only(top: 11, left: 20, right: 20, bottom: 10),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "Slot#: ${appoints.slotNumber} | ",
                          style: TextStyle(
                            fontSize: _sizes.smallTextSize,
                            color: _colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: "CenturyGothic",
                          ),
                        ),
                        Text(
                          appoints.status,
                          style: TextStyle(
                            fontSize: 15,
                            color: _colors.green,
                            fontWeight: FontWeight.w900,
                            fontFamily: "CenturyGothic",
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${_strings.pakistaniCurrency}. ${appoints.fee.toString()}",
                      style: TextStyle(
                        fontSize: _sizes.smallTextSize,
                        color: _colors.blue,
                        fontWeight: FontWeight.bold,
                        fontFamily: "CenturyGothic",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      "Slot Time: ",
                      style: TextStyle(
                        color: _colors.grey,
                        fontSize: _sizes.smallTextSize,
                        fontWeight: FontWeight.w600,
                        fontFamily: "CenturyGothic",
                      ),
                    ),
                    Text(
                      utils.durationToString(appoints.slotTime),
                      style: TextStyle(
                        color: _colors.green,
                        fontSize: _sizes.smallTextSize,
                        fontWeight: FontWeight.w600,
                        fontFamily: "CenturyGothic",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "Slot Date: ",
                          style: TextStyle(
                            color: _colors.grey,
                            fontSize: _sizes.smallTextSize,
                            fontWeight: FontWeight.w600,
                            fontFamily: "CenturyGothic",
                          ),
                        ),
                        Text(
                          appoints.slotDate,
                          style: TextStyle(
                            color: _colors.green,
                            fontSize: _sizes.smallTextSize,
                            fontWeight: FontWeight.w600,
                            fontFamily: "CenturyGothic",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Doctor: ",
                      style: TextStyle(
                        color: _colors.grey,
                        fontSize: _sizes.smallTextSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: "CenturyGothic",
                      ),
                    ),
                    Text(
                      "Dr. ${appoints.doctor.user.fullName}",
                      style: TextStyle(
                        color: _colors.green,
                        fontSize: _sizes.smallTextSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: "CenturyGothic",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      "Clinic: ",
                      style: TextStyle(
                        color: _colors.grey,
                        fontSize: _sizes.smallTextSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: "CenturyGothic",
                      ),
                    ),
                    Text(
                      appoints.location.address,
                      style: TextStyle(
                        color: _colors.green,
                        fontSize: _sizes.smallTextSize,
                        fontWeight: FontWeight.w700,
                        fontFamily: "CenturyGothic",
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: CustomButton(
                    name: "Cancel",
                    color: _colors.red,
                    pressed: () async {
                      bool isConnected =
                          await CheckInternet().isInternetConnected(context);
                      if (isConnected == true) {
                        cancel();
                      } else {
                        _toast.showDangerToast(
                            "Please check your internet connection");
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Cancel extends StatefulWidget {
  Appointment appointment;

  Cancel({this.appointment});

  @override
  _CancelState createState() => _CancelState();
}

class _CancelState extends State<Cancel> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //TOAST

  CustomStrings _strings = CustomStrings();
  Utils utils = Utils();

  SmsService smsService = SmsService();
  PatientAppointmentService patientAppointmentService =
      PatientAppointmentService();
  SessionService sessionService = SessionService();
  NotificationService notificationService = NotificationService();

  bool isLoading = false;
  CustomToast _toast = CustomToast();

  AppointmentService appointmentService = AppointmentService();
  EmailService emailService = EmailService();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
              color: _colors.greyTheme,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              )),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            children: <Widget>[
              Consumer3<AppointmentListProvider, HistoryListProvider,
                  SlotsProvider>(
                builder: (context, appointmentsProvider, historyListProvider,
                        slotsProvider, child) =>
                    Expanded(
                  flex: 1,
                  child: Container(
                    height: 45.0,
                    width: 150.0,
                    margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    child: NeuButton(
                      decoration: NeumorphicDecoration(
                          color: _colors.greyTheme,
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () async {
                        bool isConnected =
                            await CheckInternet().isInternetConnected(context);
                        if (isConnected == true) {
                          setState(() {
                            isLoading = true;
                          });
                          // Cancel Booking
                          print(
                              "doctorAppointmentBySlotNumber: ${widget.appointment}");
                          if (widget.appointment != null) {
                            Appointment updatedAppointment = Appointment(
                              id: widget.appointment.id,
                              slotNumber: widget.appointment.slotNumber,
                              slotDate: widget.appointment.slotDate,
                              slotTime: widget.appointment.slotTime,
                              fee: widget.appointment.fee,
                              createdByDoctor:
                                  widget.appointment.createdByDoctor,
                              createdDate: widget.appointment.createdDate,
                              bookingDate: widget.appointment.bookingDate,
                              updatedDate: utils.getCurrentDate(),
                              cancelledDate: utils.getCurrentDate(),
                              state: true,
                              location: widget.appointment.location,
                              doctor: widget.appointment.doctor,
                              patient: widget.appointment.patient,
                              status: _strings.slotStatusCancelled,
                              updatedBy: widget.appointment.patient.user,
                              createdBy: widget.appointment.createdBy,
                            );

                            Appointment appointmentFromResponse =
                                await appointmentService
                                    .updateAppointmentStatus(updatedAppointment,
                                        widget.appointment.id);
                            print(
                                "appointmentFromResponse: $appointmentFromResponse");

                            appointmentsProvider.cancelAppointmentByPatient(
                                appointmentFromResponse);

                            List<Appointment> historyList =
                                await patientAppointmentService
                                    .getAppointmentHistoryList();
                            historyListProvider.appointments = historyList;

                            Slot slot = Slot(
                                locationId: widget.appointment.location.id,
                                number: widget.appointment.slotNumber,
                                timeInMinutes: widget.appointment.slotTime,
                                date:
                                    DateTime.parse(widget.appointment.slotDate),
                                status: widget.appointment.status,
                                disable: true);

                            slotsProvider.updateSlotByCancelledStatus(slot);

                            // Patient Notifications
                            DateTime slotDate = DateTime.parse(
                                appointmentFromResponse.slotDate);
                            String notificationTitle = "Appointment Cancelled";
                            String notificationMessage =
                                "Your appointment ${appointmentFromResponse.slotNumber} with Doctor ${appointmentFromResponse.doctor.user.fullName ?? ''}, on ${slotDate.day}/${slotDate.month}/${slotDate.year} at ${appointmentFromResponse.location.name}, has been cancelled";
                            await notificationService
                                .sendNotificationsToAllDevices(
                                    user: appointmentFromResponse.patient.user,
                                    title: notificationTitle,
                                    message: notificationMessage);

                            // Doctor Notifications
                            String doctorNotificationTitle =
                                "Appointment Cancelled";
                            String doctorNotificationMessage =
                                "${appointmentFromResponse.patient.user.fullName ?? "Patient"} has cancelled their scheduled appointment ${appointmentFromResponse.slotNumber} for ${slotDate.day}/${slotDate.month}/${slotDate.year} at ${appointmentFromResponse.location.name}";
                            await notificationService
                                .sendNotificationsToAllDevices(
                                    user: appointmentFromResponse.doctor.user,
                                    title: doctorNotificationTitle,
                                    message: doctorNotificationMessage);

                            //EMAIL-TO-PATIENT
                            String toPatient =
                                widget.appointment.patient.user.email;
                            String namePatient =
                                widget.appointment.patient.user.fullName;
                            String nameDoctor =
                                widget.appointment.doctor.user.fullName;
                            String datePatient = widget.appointment.slotDate;
                            String timePatient = utils
                                .durationToString(widget.appointment.slotTime);
                            await emailService.appointmentStatus(
                                to: toPatient,
                                name: namePatient,
                                secondName: nameDoctor,
                                status: _strings.slotStatusCancelled,
                                date: datePatient,
                                time: timePatient);
                            //EMAIL-TO-DOCTOR
                            String doctorEmail =
                                widget.appointment.doctor.user.email;
                            await emailService.appointmentStatus(
                                to: doctorEmail,
                                name: nameDoctor,
                                secondName: namePatient,
                                status: _strings.slotStatusCancelled,
                                date: datePatient,
                                time: timePatient);
                            //SMS
                            String message =
                                "Dear $namePatient, your appointment with $nameDoctor on $datePatient at $timePatient has been cancelled.";
                            String val = widget.appointment.patient.user.phone;
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

                            Navigator.pop(context);
                            _toast.showToast("Booking Cancelled");
                            // setState(() {
                            //   isLoading = false;
                            // });

                            //
                          } else {
                            throw "can't cancel appointment";
                          }
                        } else {
                          _toast.showDangerToast(
                              "Please check your internet connection");
                        }
                      },
                      child: Text(
                        "Cancel Appointment",
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _colors.red,
                          fontFamily: "CenturyGothic",
                          fontSize: 8.0,
                        ),
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
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      bool isConnected =
                          await CheckInternet().isInternetConnected(context);
                      if (isConnected == true) {
                        Navigator.pop(context);
                      } else {
                        _toast.showDangerToast(
                            "Please check your internet connection");
                      }
                    },
                    child: Text(
                      "Not Now",
                      textScaleFactor: 1.3,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _colors.grey,
                        fontFamily: "CenturyGothic",
                        fontSize: 8.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // For Loading
        isLoading
            ? Opacity(
                opacity: 0.7,
                child: Container(
                  height: 100,
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
