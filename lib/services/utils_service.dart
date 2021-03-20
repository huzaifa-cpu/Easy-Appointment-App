import 'package:intl/intl.dart';

class Utils {
  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    print("duration: $d");
    List<String> parts = d.toString().split(':');
    if (int.parse(parts[0]) >= 12) {
      String hour = (int.parse(parts[0]) % 12).toString();
      if (int.parse(hour) == 0 && int.parse(parts[0]) == 12) {
        return '${"12"}:${parts[1].padLeft(2, '0')} PM';
      }
      return '${hour.padLeft(2, '0')}:${parts[1].padLeft(2, '0')} PM';
    } else if (parts[0] == '0') {
      return '${"12"}:${parts[1].padLeft(2, '0')} AM';
    }
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')} AM';
  }

  String getCurrentDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    return formattedDate;
  }

  String getFormattedDate(DateTime date) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(date);
    return formattedDate;
  }
}
