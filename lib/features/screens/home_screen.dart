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
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text(
          'Adhanify',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF16213E),
        centerTitle: true,
        elevation: 0,
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF0F3460),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildPrayerCard('Fajr', prayerTimes!.fajr, Icons.wb_twilight),
                    const SizedBox(height: 16),
                    _buildPrayerCard('Dhuhr', prayerTimes!.dhuhr, Icons.wb_sunny),
                    const SizedBox(height: 16),
                    _buildPrayerCard('Asr', prayerTimes!.asr, Icons.wb_sunny_outlined),
                    const SizedBox(height: 16),
                    _buildPrayerCard('Maghrib', prayerTimes!.maghrib, Icons.nightlight),
                    const SizedBox(height: 16),
                    _buildPrayerCard('Isha', prayerTimes!.isha, Icons.nights_stay),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildPrayerCard(String name, String time, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F3460), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F3460).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE94560).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFE94560),
              size: 32,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFFE94560),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
