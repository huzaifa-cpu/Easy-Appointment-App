import 'package:flutter/material.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointment_list_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/appointments_provider.dart';
import 'package:flutter_ea_mobile_app/change_notifier_providers/history_list_provider.dart';
import 'package:flutter_ea_mobile_app/models/appointment_model.dart';
import 'package:flutter_ea_mobile_app/services/patient_appointment_service.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_colors.dart';
import 'package:flutter_ea_mobile_app/widgets/custom_sizes.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:provider/provider.dart';

class PatientScheduleHistory extends StatefulWidget {
  @override
  _PatientScheduleHistoryState createState() => _PatientScheduleHistoryState();
}

class _PatientScheduleHistoryState extends State<PatientScheduleHistory> {
  PatientAppointmentService appointmentService = PatientAppointmentService();

  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  @override
  Widget build(BuildContext context) {
    return Consumer<HistoryListProvider>(
        builder: (context, appointmentsProvider, child) {
      if (appointmentsProvider.appointments.length != 0) {
        return ListView.builder(
            itemCount: appointmentsProvider.appointments.length,
            itemBuilder: (BuildContext context, int i) {
              return HistoryCard(
                appoints: appointmentsProvider.appointments[i],
              );
            });
      } else {
        return Center(
            child: Text(
          "No history yet",
          style: TextStyle(color: _colors.grey),
        ));
      }
    });
  }
}

class HistoryCard extends StatelessWidget {
  //COLORS
  CustomThemeColors _colors = CustomThemeColors();

  //SIZES
  CustomSizes _sizes = CustomSizes();

  HistoryCard({this.appoints});

  final Appointment appoints;

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
                      durationToString(appoints.slotTime),
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
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
