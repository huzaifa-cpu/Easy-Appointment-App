import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/services/appointment_service.dart';
import 'package:flutter_ea_mobile_app/services/local_notification_service.dart';
import 'package:flutter_ea_mobile_app/services/schedule_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';

class FcmService {
  CustomStrings _strings = CustomStrings();

  final FirebaseMessaging _fcm = FirebaseMessaging();
  AppointmentService appointmentService = AppointmentService();
  ScheduleService scheduleService = ScheduleService();
  LocalNotificationService localNotificationService =
      LocalNotificationService();

  void initializeFcmServices(
      {DoctorAppointmentsProvider doctorAppointmentsProvider,
      SlotsProvider slotsProvider,
      Function setLocalNotificationChannelId}) {
    // SETTING CHANNEL_ID
    int localNotificationChannelId = setLocalNotificationChannelId();

    // Local Notification Service
    localNotificationService.initializing();

    // FCM
    _fcm.getToken().then((value) => print("token $value"));
    _fcm.subscribeToTopic("appointment");
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("initializing fcm services");
        print("onMessage: ${message}");

        if (message["notification"]["title"] != null &&
            message["notification"]["body"] != null) {
          localNotificationService.showNowNotification(
              message["notification"]["title"],
              message["notification"]["body"],
              localNotificationChannelId);
        }

        int appointmentId = int.parse(message["data"]["id"]);
        Appointment appointmentFromFcm =
            await appointmentService.getAppointmentById(appointmentId);
        print("appointmentFromFcm: $appointmentFromFcm");
        if (appointmentFromFcm.status == _strings.slotStatusBooked) {
          doctorAppointmentsProvider.addDoctorAppointment(appointmentFromFcm);
          slotsProvider.updateSlotFromFcmByBookedStatus(appointmentFromFcm);
          print("appointment added");
        } else if (appointmentFromFcm.status == _strings.slotStatusCancelled) {
          doctorAppointmentsProvider.updateAppointment(appointmentFromFcm);
          slotsProvider.updateSlotFromFcmByCancelledStatus(appointmentFromFcm);
          print("appointment updated");
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("initializing fcm services");
        print("onLaunch: ${message}");

        if (message["notification"]["title"] != null &&
            message["notification"]["body"] != null) {
          localNotificationService.showNowNotification(
              message["notification"]["title"],
              message["notification"]["body"],
              localNotificationChannelId);
        }

        int appointmentId = int.parse(message["data"]["id"]);
        Appointment appointmentFromFcm =
            await appointmentService.getAppointmentById(appointmentId);
        print("appointmentFromFcm: $appointmentFromFcm");
        if (appointmentFromFcm.status == _strings.slotStatusBooked) {
          doctorAppointmentsProvider.addDoctorAppointment(appointmentFromFcm);
          slotsProvider.updateSlotFromFcmByBookedStatus(appointmentFromFcm);
          print("appointment added");
        } else if (appointmentFromFcm.status == _strings.slotStatusCancelled) {
          doctorAppointmentsProvider.updateAppointment(appointmentFromFcm);
          slotsProvider.updateSlotFromFcmByCancelledStatus(appointmentFromFcm);
          print("appointment updated");
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("initializing fcm services");
        print("onResume: ${message}");

        if (message["notification"]["title"] != null &&
            message["notification"]["body"] != null) {
          localNotificationService.showNowNotification(
              message["notification"]["title"],
              message["notification"]["body"],
              localNotificationChannelId);
        }

        int appointmentId = int.parse(message["data"]["id"]);
        Appointment appointmentFromFcm =
            await appointmentService.getAppointmentById(appointmentId);
        print("appointmentFromFcm: $appointmentFromFcm");
        if (appointmentFromFcm.status == _strings.slotStatusBooked) {
          doctorAppointmentsProvider.addDoctorAppointment(appointmentFromFcm);
          slotsProvider.updateSlotFromFcmByBookedStatus(appointmentFromFcm);
          print("appointment added");
        } else if (appointmentFromFcm.status == _strings.slotStatusCancelled) {
          doctorAppointmentsProvider.updateAppointment(appointmentFromFcm);
          slotsProvider.updateSlotFromFcmByCancelledStatus(appointmentFromFcm);
          print("appointment updated");
        }
      },
    );
  }
}
