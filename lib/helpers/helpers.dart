import 'package:intl/intl.dart';

class Helpers {
  static DateTime getDateTime(String dateString, String arrivalString) {
    /* Get month/day/year string from date */
    String currentYearString = DateFormat.y().format(DateTime.now()).toString();
    String ymdDate = dateString.split(" ")[1] + "/" + currentYearString;
    /* Get Hour:Min AM/PM string from arrivalString */
    if (arrivalString[arrivalString.length - 1] != "m") {
      arrivalString += "m";
    }
    String timeString = arrivalString.substring(0, arrivalString.length - 2);
    if (timeString.length < 3) {
      // if flat hour ex.: 2, 3, 10
      timeString = timeString + ":00";
    } else {
      // if already includes minutes ex.: 230, 1015
      timeString = timeString.substring(0, timeString.length - 2) +
          ":" +
          timeString.substring(timeString.length - 2);
    }
    String timeSuffix =
        arrivalString.substring(arrivalString.length - 2).toUpperCase();
    /* Combine dates and times to create "Month/Day/Year Hour:Min AM/PM" string*/
    String fullSchedString = ymdDate + " " + timeString + " " + timeSuffix;
    // print(
    //     "Original: $dateString, $arrivalString -> Full Sched String: $fullSchedString");
    // parse as if utc string
    DateTime unconvertedTime =
        DateFormat.yMd().add_jm().parse(fullSchedString, true);
    // add 4 hrs to get true utc time
    return unconvertedTime.add(Duration(hours: 4));
  }

  static DateTime getStartOfDay(DateTime day) =>
      DateTime(day.year, day.month, day.day);

  static DateTime getEndOfDay(DateTime day) =>
      DateTime(day.year, day.month, day.day).add(Duration(days: 1));
}
