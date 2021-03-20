import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/bottom_popups/appointment_status_confirmation.dart';
import 'package:flutter_ea_mobile_app/bottom_popups/get_or_create_patient_by_doctor.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointment_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/history_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/doctor/widgets/loaders.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/models/patient_model.dart';
import 'package:flutter_ea_mobile_app/models/payment_model/payment_model.dart';
import 'package:flutter_ea_mobile_app/models/slot_model.dart';
import 'package:flutter_ea_mobile_app/patient/screens/jazzcash_credit_screen.dart';
import 'package:flutter_ea_mobile_app/patient/screens/jazzcash_mobile_screen.dart';
import 'package:flutter_ea_mobile_app/patient/screens/jazzcash_voucher_screen.dart';
import 'package:flutter_ea_mobile_app/services/appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/email_service.dart';
import 'package:flutter_ea_mobile_app/services/local_notification_service.dart';
import 'package:flutter_ea_mobile_app/services/notification_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/patient_service.dart';
import 'package:flutter_ea_mobile_app/services/payment_service/jazz_cash_service.dart';
import 'package:flutter_ea_mobile_app/services/payment_service/payment_service.dart';
import 'package:flutter_ea_mobile_app/services/session_service.dart';
import 'package:flutter_ea_mobile_app/services/sms_service.dart';
import 'package:flutter_ea_mobile_app/services/utils_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_button.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_loading.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SlotCard extends StatefulWidget {
  Slot slot;
  bool doctor;
  Location location;

  SlotCard({
    this.slot,
    this.doctor,
    this.location,
  });

  @override
  _SlotCardState createState() => _SlotCardState();
}

class _SlotCardState extends State<SlotCard> {
  CustomThemeColors _colors = CustomThemeColors();
  CustomSizes _sizes = CustomSizes();
  CustomToast _toast = CustomToast();
  CustomStrings _strings = CustomStrings();
  SessionService sessionService = SessionService();
  NotificationService notificationService = NotificationService();
  Utils utils = Utils();

  var phoneController = TextEditingController();
  var cnicController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  AppointmentService appointmentService = AppointmentService();
  EmailService emailService = EmailService();
  JazzCashService jazzCashService = JazzCashService();
  PaymentService paymentService = PaymentService();
  PatientService patientService = PatientService();
  LocalNotificationService localNotificationService =
      LocalNotificationService();
  SmsService smsService = SmsService();
  PatientAppointmentService patientAppointmentService =
      PatientAppointmentService();

  void onSlotStatusFree() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        isDismissible: false,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Consumer<SlotsProvider>(
                builder: (context, slotsProvider, child) =>
                    GetOrCreatePatientByDoctor(
                  title:
                      "Booking Slot ${slotsProvider.getSlotByDateAndNumber(widget.slot).number} | ${slotsProvider.getSlotByDateAndNumber(widget.slot).timeIn12HoursFormat}",
                  hint: "Enter patient phone number",
                  submitButtonName: "Create Appointment",
                  slot: widget.slot,
                  location: widget.location,
                ),
              ),
            ),
          );
        });
  }

  void onSlotStatusCompleted() {
    _toast.showToast("this appointment is completed");
  }

  @override
  void initState() {
    super.initState();
    localNotificationService.initializing();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer5<SlotsProvider, LocationsProvider, AppointmentListProvider,
        HistoryListProvider, DoctorAppointmentsProvider>(
      builder: (context,
              slotsProvider,
              locationsProvider,
              appointmentListProvider,
              historyListProvider,
              doctorAppointmentsProvider,
              child) =>
          Container(
        padding: EdgeInsets.fromLTRB(50.0, 10.0, 50.0, 10.0),
        child: CustomButton(
          name:
              "Slot: ${slotsProvider.getSlotByDateAndNumber(widget.slot).number} | ${slotsProvider.getSlotByDateAndNumber(widget.slot).timeIn12HoursFormat}",
          pressed: widget.doctor == true
              ? () async {
                  bool isConnected =
                      await CheckInternet().isInternetConnected(context);
                  if (isConnected == true) {
                    // For Doctor
                    String slotStatus = widget.slot.status;
                    if (slotStatus == _strings.slotStatusFree) {
                      onSlotStatusFree();
                    } else if (slotStatus == _strings.slotStatusBooked) {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: false,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext context) {
                            return AppointmentStatusConfirmation(
                              title1: "Cancel Booking",
                              title2: "Complete Booking",
                              slot: widget.slot,
                              doctorAppointmentsProvider:
                                  doctorAppointmentsProvider,
                              slotsProvider: slotsProvider,
                              titleColor1: _colors.red,
                              titleColor2: _colors.blue,
                              onPressed3: () {
                                Navigator.pop(context);
                              },
                            );
                          });
                    } else if (slotStatus == _strings.slotStatusCompleted) {
                      onSlotStatusCompleted();
                    } else if (slotStatus == _strings.slotStatusPassed) {
                      _toast.showToast("slot time already passed");
                    }
                  } else {
                    _toast.showDangerToast(
                        "Please check your internet connection");
                  }
                }
              : () async {
                  // For Patient
                  if (widget.slot.disable == true) {
                    _toast.showToast("not available");
                  } else {
                    String timePatient =
                        utils.durationToString(widget.slot.timeInMinutes);
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: _colors.greyTheme,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ListView(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 20,
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                      ),
                                      child: Stack(
                                        alignment: AlignmentDirectional.center,
                                        children: [
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Payment via:",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: _colors.grey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                                CustomButton(
                                                  name: " Cash on delivery ",
                                                  color: _colors.grey,
                                                  pressed: () async {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    Loaders()));

                                                    final SharedPreferences
                                                        prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    int patientId = prefs
                                                        .getInt("doctorId");
                                                    Patient patient =
                                                        await patientService
                                                            .getPatientById(
                                                                patientId);
                                                    Location location =
                                                        widget.location;
                                                    Appointment appointment =
                                                        Appointment(
                                                      slotNumber:
                                                          widget.slot.number,
                                                      slotDate: utils
                                                          .getFormattedDate(
                                                              widget.slot.date),
                                                      slotTime: widget
                                                          .slot.timeInMinutes,
                                                      fee: location.fee,
                                                      createdByDoctor: false,
                                                      createdDate: utils
                                                          .getCurrentDate(),
                                                      bookingDate: utils
                                                          .getCurrentDate(),
                                                      updatedDate: utils
                                                          .getCurrentDate(),
                                                      paymentDate: utils
                                                          .getCurrentDate(),
                                                      state: true,
                                                      location: location,
                                                      doctor: location.doctor,
                                                      patient: patient,
                                                      status: _strings
                                                          .slotStatusBooked,
                                                      updatedBy: patient.user,
                                                      createdBy: patient.user,
                                                    );

                                                    Appointment
                                                        appointmentFromResponse =
                                                        await appointmentService
                                                            .createAppointment(
                                                                appointment);

                                                    doctorAppointmentsProvider
                                                        .addDoctorAppointment(
                                                            appointmentFromResponse);

                                                    slotsProvider
                                                        .updateSlotByBookedStatus(
                                                            widget.slot,
                                                            appointmentFromResponse);

                                                    Payment payment = Payment(
                                                      name: "C.O.D",
                                                      amount: location.fee,
                                                      type: "Cash on delivery",
                                                      appointment:
                                                          appointmentFromResponse,
                                                      state: true,
                                                      status: "Active",
                                                      createdDate: utils
                                                          .getCurrentDate(),
                                                      updatedDate: utils
                                                          .getCurrentDate(),
                                                    );
                                                    await paymentService
                                                        .createPayment(payment);

                                                    //Update to schedule
                                                    List<Appointment>
                                                        appointmentList =
                                                        await patientAppointmentService
                                                            .getAppointmentList();
                                                    List<Appointment>
                                                        historyList =
                                                        await patientAppointmentService
                                                            .getAppointmentHistoryList();

                                                    appointmentListProvider
                                                            .appointments =
                                                        appointmentList;
                                                    historyListProvider
                                                            .appointments =
                                                        historyList;

                                                    // Patient Notifications
                                                    DateTime slotDate =
                                                        DateTime.parse(
                                                            appointmentFromResponse
                                                                .slotDate);
                                                    String notificationTitle =
                                                        "Appointment Scheduled";
                                                    String notificationMessage =
                                                        "Your appointment ${appointmentFromResponse.slotNumber} with Doctor ${appointmentFromResponse.doctor.user.fullName ?? ''}, on ${slotDate.day}/${slotDate.month}/${slotDate.year} at ${appointmentFromResponse.location.name}, has been scheduled";
                                                    await notificationService
                                                        .sendNotificationsToAllDevices(
                                                            user:
                                                                appointmentFromResponse
                                                                    .patient
                                                                    .user,
                                                            title:
                                                                notificationTitle,
                                                            message:
                                                                notificationMessage);

                                                    // Doctor Notifications
                                                    String
                                                        doctorNotificationMessage =
                                                        "${appointmentFromResponse.patient.user.fullName ?? "Patient"} has scheduled an appointment ${appointmentFromResponse.slotNumber} with you on ${slotDate.day}/${slotDate.month}/${slotDate.year} at ${appointmentFromResponse.location.name}";
                                                    await notificationService
                                                        .sendNotificationsToAllDevices(
                                                            user:
                                                                appointmentFromResponse
                                                                    .doctor
                                                                    .user,
                                                            title:
                                                                notificationTitle,
                                                            message:
                                                                doctorNotificationMessage);

                                                    //EMAIL-TO-PATIENT
                                                    String toPatient =
                                                        patient.user.email;
                                                    String namePatient =
                                                        patient.user.fullName;
                                                    String nameDoctor = location
                                                        .doctor.user.fullName;
                                                    String datePatient = widget
                                                        .slot.date
                                                        .toString();
                                                    String timePatient =
                                                        utils.durationToString(
                                                            appointment
                                                                .slotTime);
                                                    await emailService
                                                        .appointmentStatus(
                                                            to: toPatient,
                                                            name: namePatient,
                                                            secondName:
                                                                nameDoctor,
                                                            status: _strings
                                                                .slotStatusBooked,
                                                            date: datePatient,
                                                            time: timePatient);
                                                    //EMAIL-TO-DOCTOR
                                                    String doctorEmail =
                                                        location
                                                            .doctor.user.email;

                                                    await emailService
                                                        .appointmentStatus(
                                                            to: doctorEmail,
                                                            name: nameDoctor,
                                                            secondName:
                                                                namePatient,
                                                            status: _strings
                                                                .slotStatusBooked,
                                                            date: datePatient,
                                                            time: timePatient);

                                                    //SMS
                                                    String message =
                                                        "Dear $namePatient, your appointment with $nameDoctor on $datePatient at $timePatient has been Booked.";
                                                    String val =
                                                        patient.user.phone;
                                                    String phone =
                                                        val.replaceAll("+", "");
                                                    if (phone[0] == "9" &&
                                                        phone.length == 12) {
                                                      await smsService.sendSMS(
                                                          phone, message);
                                                      print("SMS is sent");
                                                    } else if (phone[0] ==
                                                        "0") {
                                                      String filterPhone =
                                                          phone.substring(
                                                        1,
                                                      );
                                                      String
                                                          phoneWithCountryCode =
                                                          "92$filterPhone"
                                                              .trim();
                                                      print(
                                                          phoneWithCountryCode);
                                                      await smsService.sendSMS(
                                                          phoneWithCountryCode,
                                                          message);
                                                      print("SMS is sent");
                                                    } else {
                                                      print(
                                                          "phone number is not correct for sending SMS");
                                                    }
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    _toast.showToast(
                                                        "Your appointment has been booked successfully");
                                                  },
                                                ),
                                                SizedBox(
                                                  height: 15,
                                                ),
                                                Center(
                                                  child: Text(
                                                    "OR",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: _sizes
                                                            .largeTextSize,
                                                        color: _colors.green,
                                                        fontFamily:
                                                            "CenturyGothic"),
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Payment via:",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: _colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 5.0,
                                                    ),
                                                    Image.asset(
                                                      "images/jazz.png",
                                                      width: 60,
                                                      height: 60,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.0,
                                                ),
                                                CustomButton(
                                                    name: " Mobile account ",
                                                    color: _colors.grey,
                                                    pressed: () async {
                                                      Navigator.push(
                                                          context, // ROUTING
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  JazzCashMobileScreen(
                                                                    location: widget
                                                                        .location,
                                                                    date: widget
                                                                        .slot
                                                                        .date
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10),
                                                                    time:
                                                                        timePatient,
                                                                    currentDates:
                                                                        utils
                                                                            .getCurrentDate(),
                                                                    slot: widget
                                                                        .slot,
                                                                  )));
                                                      //Update to schedule
                                                      List<Appointment>
                                                          appointmentList =
                                                          await patientAppointmentService
                                                              .getAppointmentList();
                                                      List<Appointment>
                                                          historyList =
                                                          await patientAppointmentService
                                                              .getAppointmentHistoryList();

                                                      appointmentListProvider
                                                              .appointments =
                                                          appointmentList;
                                                      historyListProvider
                                                              .appointments =
                                                          historyList;
                                                    }),
                                                SizedBox(
                                                  height: 30.0,
                                                ),
                                                // CustomButton(
                                                //     name: " Voucher ",
                                                //     color: _colors.grey,
                                                //     pressed: () async {
                                                //       Navigator.push(
                                                //           context, // ROUTING
                                                //           MaterialPageRoute(
                                                //               builder: (context) =>
                                                //                   JazzCashVoucherScreen(
                                                //                     location: widget
                                                //                         .location,
                                                //                     date: widget
                                                //                         .slot.date
                                                //                         .toString()
                                                //                         .substring(
                                                //                             0,
                                                //                             10),
                                                //                     time:
                                                //                         timePatient,
                                                //                     currentDates:
                                                //                         utils
                                                //                             .getCurrentDate(),
                                                //                     slot: widget
                                                //                         .slot,
                                                //                   )));
                                                //     }),
                                                // SizedBox(
                                                //   height: 15.0,
                                                // ),
                                                CustomButton(
                                                    name: " Credit/Debit card ",
                                                    color: _colors.grey,
                                                    pressed: () async {
                                                      Navigator.push(
                                                          context, // ROUTING
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  JazzCashCreditScreen(
                                                                    location: widget
                                                                        .location,
                                                                    date: widget
                                                                        .slot
                                                                        .date
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            10),
                                                                    time:
                                                                        timePatient,
                                                                    currentDates:
                                                                        utils
                                                                            .getCurrentDate(),
                                                                    slot: widget
                                                                        .slot,
                                                                  )));
                                                    }),
                                                SizedBox(
                                                  height: 15.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // For Loading
                              isLoading
                                  ? Opacity(
                                      opacity: 0.7,
                                      child: Scaffold(
                                          backgroundColor: _colors.greyTheme),
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
                        });
                    //

                  }
                },
          color: widget.doctor == true
              ? (widget.slot.status == _strings.slotStatusFree
                  ? _colors.green
                  : widget.slot.status == _strings.slotStatusCancelled
                      ? _colors.green
                      : widget.slot.status == _strings.slotStatusBooked
                          ? _colors.red
                          : widget.slot.status == _strings.slotStatusPassed
                              ? _colors.grey
                              : _colors.blue)
              : (widget.slot.disable == true ? _colors.grey : _colors.green),
        ),
      ),
    );
  }
}
