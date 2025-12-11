import 'package:flutter/material.dart';
import '../models/prayer_times.dart';
import '../services/prayer_api_service.dart';
import '../../notifications/notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PrayerTimes? prayerTimes;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    NotificationService.init();
  }

  void fetchData() async {
    final data = await PrayerApiService().fetchPrayerTimes(33.5731, -7.5898); // Casablanca
    setState(() {
      prayerTimes = data;
      loading = false;
    });
    scheduleNotifications(data);
  }

  void scheduleNotifications(PrayerTimes data) {
    final now = DateTime.now();
    Map<String, String> prayers = {
      'Fajr': data.fajr,
      'Dhuhr': data.dhuhr,
      'Asr': data.asr,
      'Maghrib': data.maghrib,
      'Isha': data.isha,
    };

    prayers.forEach((name, time) {
      final parts = time.split(':');
      DateTime prayerTime = DateTime(
          now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
      if (prayerTime.isAfter(now)) {
        NotificationService.scheduleNotification(
            name, 'Time for $name prayer', prayerTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adhanify')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Fajr: ${prayerTimes!.fajr}'),
                Text('Dhuhr: ${prayerTimes!.dhuhr}'),
                Text('Asr: ${prayerTimes!.asr}'),
                Text('Maghrib: ${prayerTimes!.maghrib}'),
                Text('Isha: ${prayerTimes!.isha}'),
              ],
            ),
    );
  }
}
