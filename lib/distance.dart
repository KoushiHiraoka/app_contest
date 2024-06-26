import 'dart:convert';
import 'package:http/http.dart' as http;

const apiKey = 'AIzaSyCZqph0a84xr03zjkiqTE_u8atElhjravU';
Future<Map<String, dynamic>> getDistanceAndDuration(
  double startLatitude,
  double startLongitude,
  double destinationLatitude,
  double destinationLongitude,
) async {
  String url =
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$startLatitude,$startLongitude&destinations=$destinationLatitude,$destinationLongitude&mode=walking&key=$apiKey";
  http.Response response = await http.get(Uri.parse(url));
  Map<String, dynamic> values = jsonDecode(response.body);


  String distanceWalking = values["rows"][0]["elements"][0]["distance"]["text"];
  String durationWalking = values["rows"][0]["elements"][0]["duration"]["text"];

  url =
      "https://maps.googleapis.com/maps/api/distancematrix/json?origins=$startLatitude,$startLongitude&destinations=$destinationLatitude,$destinationLongitude&mode=driving&key=$apiKey";
  response = await http.get(Uri.parse(url));
  values = jsonDecode(response.body);
  String distanceDriving = values["rows"][0]["elements"][0]["distance"]["text"];
  String durationDriving = values["rows"][0]["elements"][0]["duration"]["text"];

  return {
    "distanceWalking": distanceWalking,
    "durationWalking": durationWalking,
    "distanceDriving": distanceDriving,
    "durationDriving": durationDriving,
  };
}

