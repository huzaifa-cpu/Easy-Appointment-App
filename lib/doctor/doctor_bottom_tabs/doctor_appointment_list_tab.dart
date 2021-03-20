import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/doctor_appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/locations_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/schedules_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/slots_provider.dart';
import 'package:flutter_ea_mobile_app/doctor/screens/notifications_screen.dart';
import 'package:flutter_ea_mobile_app/doctor/widgets/slot_card.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/models/location_model.dart';
import 'package:flutter_ea_mobile_app/patient/screens/doctor_location_selector.dart';
import 'package:flutter_ea_mobile_app/services/check_internet_service.dart';
import 'package:flutter_ea_mobile_app/services/firebase_services/fcm_service.dart';
import 'package:flutter_ea_mobile_app/services/slot_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_app_bar.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_date_picker.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_location_dropdown.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_strings.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_toast.dart';
import 'package:provider/provider.dart';

class AppointmentsTab extends StatefulWidget {
  Location location;

  AppointmentsTab({
    this.location,
  });

  @override
  _AppointmentsTabState createState() => _AppointmentsTabState();
}

class _AppointmentsTabState extends State<AppointmentsTab> {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  CustomStrings _strings = CustomStrings();

  CustomToast _toast = CustomToast();

  //SERVICES
  FcmService fcmService = FcmService();
  SlotService slotService = SlotService();

  int day;
  DateTime selectedDate;
  DatePickerController _controller = DatePickerController();
  Appointment doctorAppointmentBySlotNumberAndSlotDate;
  int localNotificationChannelId = 0;

  void setInitialDateTime() {
    setState(() {
      selectedDate = new DateTime.now();
      day = DateTime.now().weekday;
    });
    print("initialSelectedDate: $selectedDate, initialDay: $day");
  }

  @override
  void initState() {
    super.initState();
    print("starting doctor appointment list tab");

    // Setting initial Date Time
    setInitialDateTime();

    // Providers
    SchedulesProvider schedulesProvider =
        Provider.of<SchedulesProvider>(context, listen: false);
    SlotsProvider slotsProvider =
        Provider.of<SlotsProvider>(context, listen: false);
    DoctorAppointmentsProvider doctorAppointmentsProvider =
        Provider.of<DoctorAppointmentsProvider>(context, listen: false);

    // Initializing Slot Statuses
    slotService.updateSlotStatuses(
        schedulesProvider: schedulesProvider,
        slotsProvider: slotsProvider,
        doctorAppointmentsProvider: doctorAppointmentsProvider,
        locationId: widget.location.id,
        selectedDate: selectedDate,
        day: day);
  }

  void onClinicLocation() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return DoctorLocationSelector();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colors.greyTheme,
      appBar: CustomAppBar(
        title: "Appointments",
        notificationButton: true,
        notificationButtonPressed: () async {
          bool isConnected = await CheckInternet().isInternetConnected(context);
          if (isConnected == true) {
            Navigator.push(
                context, // ROUTING
                MaterialPageRoute(builder: (context) => NotificationsScreen()));
          } else {
            _toast.showDangerToast("Please check your internet connection");
          }
        },
        backButtonPressed: () {},
        logoutButton: false,
      ),
      body: Consumer4<SchedulesProvider, SlotsProvider, LocationsProvider,
          DoctorAppointmentsProvider>(
        builder: (context, schedulesProvider, slotsProvider, locationsProvider,
                doctorAppointmentsProvider, child) =>
            Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 5.0,
              ),
              CustomLocationDropDown(
                locationName:
                    locationsProvider.getLocationName(widget.location),
                pressed: () async {
                  bool isConnected =
                      await CheckInternet().isInternetConnected(context);
                  if (isConnected == true) {
                    onClinicLocation();
                  } else {
                    _toast.showDangerToast(
                        "Please check your internet connection");
                  }
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              CustomDatePicker(
                datePickerController: _controller,
                onDateChanged: (DateTime date) {
                  setState(() {
                    day = date.weekday;
                    selectedDate = date;
                    // Initializing Slot Statuses
                    slotService.updateSlotStatuses(
                        schedulesProvider: schedulesProvider,
                        slotsProvider: slotsProvider,
                        doctorAppointmentsProvider: doctorAppointmentsProvider,
                        locationId: widget.location.id,
                        selectedDate: selectedDate,
                        day: day);
                    print("selectedDay: ${date.weekday}");
                    print("selected: $date");
                  });
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              slotsProvider
                          .getSlotsByDateAndLocationId(
                              selectedDate, widget.location.id)
                          .length !=
                      0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${_strings.slotStatusFree}: ${slotsProvider.getFreeCount(selectedDate, widget.location.id)}",
                          style: TextStyle(
                            fontSize: _sizes.xsTextSize,
                            fontWeight: FontWeight.w600,
                            color: _colors.green,
                            fontFamily: "CenturyGothic",
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "${_strings.slotStatusBooked}: ${slotsProvider.getBookedCount(selectedDate, widget.location.id)}",
                          style: TextStyle(
                            fontSize: _sizes.xsTextSize,
                            fontWeight: FontWeight.w600,
                            color: _colors.red,
                            fontFamily: "CenturyGothic",
                          ),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "${_strings.slotStatusCompleted}: ${slotsProvider.getCompletedCount(selectedDate, widget.location.id)}",
                          style: TextStyle(
                            fontSize: _sizes.xsTextSize,
                            fontWeight: FontWeight.w600,
                            color: _colors.blue,
                            fontFamily: "CenturyGothic",
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      height: 0.0,
                    ),
              SizedBox(
                height: 10.0,
              ),
              slotsProvider
                          .getSlotsByDateAndLocationId(
                              selectedDate, widget.location.id)
                          .length !=
                      0
                  ? Expanded(
                      child: ListView.builder(
                        itemCount: slotsProvider
                            .getSlotsByDateAndLocationId(
                                selectedDate, widget.location.id)
                            .length,
                        itemBuilder: (BuildContext context, int index) {
                          return SlotCard(
                            location: widget.location,
                            slot: slotsProvider.getSlotsByDateAndLocationId(
                                selectedDate, widget.location.id)[index],
                            doctor: true,
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Text(
                      "Marked as Holiday",
                      style: TextStyle(
                          fontFamily: "CenturyGothic", color: _colors.grey),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
