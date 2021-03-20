import "package:flutter/material.dart";
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointment_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/history_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/profile_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/is_sign_in_or_sign_out.dart';
import 'package:flutter_ea_mobile_app/models/doctor_model.dart';
import 'package:flutter_ea_mobile_app/services/doctor_service.dart';
import 'package:flutter_ea_mobile_app/services/firebase_services/fcm_service.dart';
import 'package:flutter_ea_mobile_app/services/firebase_services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

import 'change_notifier_providers/schedules_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  List<Doctor> doctors = await DoctorService().getDoctorList();
  print("doctors: $doctors");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FcmService fcmService = FcmService();

  int localNotificationChannelId = 0;

  int setLocalNotificationChannelId() {
    setState(() {
      localNotificationChannelId += 1;
    });
    print("localNotificationChannelId: $localNotificationChannelId");
    return localNotificationChannelId;
  }

//  @override
//  void initState() {
//    super.initState();
////    firebaseAuthService.signOut(); // For testing purposes
//
//    // PROVIDERS
//    SlotsProvider slotsProvider =
//        Provider.of<SlotsProvider>(context, listen: false);
//    DoctorAppointmentsProvider doctorAppointmentsProvider =
//        Provider.of<DoctorAppointmentsProvider>(context, listen: false);
//
//    // FCM
//    fcmService.initializeFcmServices(
//        doctorAppointmentsProvider: doctorAppointmentsProvider,
//        slotsProvider: slotsProvider,
//        setLocalNotificationChannelId: setLocalNotificationChannelId);
//  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<SchedulesProvider>(
            create: (context) => SchedulesProvider(),
          ),
          ChangeNotifierProvider<AppointmentsProvider>(
            create: (context) => AppointmentsProvider(),
          ),
          ChangeNotifierProvider<ProfileProvider>(
            create: (context) => ProfileProvider(),
          ),
          ChangeNotifierProvider<LocationsProvider>(
            create: (context) => LocationsProvider(),
          ),
          ChangeNotifierProvider<SlotsProvider>(
            create: (context) => SlotsProvider(),
          ),
          ChangeNotifierProvider<AppointmentListProvider>(
            create: (context) => AppointmentListProvider(),
          ),
          ChangeNotifierProvider<HistoryListProvider>(
            create: (context) => HistoryListProvider(),
          ),
          ChangeNotifierProvider<DoctorAppointmentsProvider>(
            create: (context) => DoctorAppointmentsProvider(),
          ),
          ChangeNotifierProvider<DoctorProvider>(
            create: (context) => DoctorProvider(),
          ),
//    StreamProvider<FirebaseAuthUser>.value(value: FirebaseAuthService().user)
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(accentColor: Colors.white),
          home: IsSignInOrSignOut(),
        ));
  }
}
