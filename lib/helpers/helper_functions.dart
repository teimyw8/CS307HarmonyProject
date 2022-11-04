import 'package:instant/instant.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
// DateTime dateTimeToEST(DateTime dateTime) {
// // Super Simple!
// //   DateTime myDT = DateTime.now(); //Current DateTime
//   DateTime EastCoast = dateTimeToZone(zone: "EST", datetime: dateTime); //DateTime in EST zone
//
//   print("EastCoast: $EastCoast");
//   return EastCoast;
// }
DateTime dateTimeToEST(DateTime dateTime) {
  tz.initializeTimeZones();
  final pacificTimeZone = tz.getLocation('America/Los_Angeles');
  return tz.TZDateTime.from(dateTime, pacificTimeZone);
}