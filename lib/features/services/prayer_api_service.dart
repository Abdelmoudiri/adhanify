import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:adhanify/features/models/prayer_times.dart';


class PrayerApiService {
    Future<PrayerTimes> fetchPrayerTimes(double latitude, double longitude) async {
        final url = Uri.parse(
            'http://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2'
        );
        final response = await http.get(url);
        if(response.statusCode == 200) {
            final data = jsonDecode(response.body);
            final timings = data['data']['timings'];
            return PrayerTimes.fromJson(timings);
        } else {
            throw Exception('Failed to load prayer times');
        }
    }
}