import 'package:adhanify/features/models/prayer_times.dart';
import 'package:adhanify/features/services/prayer_api_service.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? Key}) : super(key: Key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Adhanify'),
        ),
        body: FutureBuilder(
          future: PrayerApiService().fetchPrayerTimes(33.5731, -7.5898), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));

            } else{
              final prayerTimes = snapshot.data!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Fajr: ${prayerTimes.fajr}'),
                  Text('Dhuhr: ${prayerTimes.dhuhr}'),
                  Text('Asr: ${prayerTimes.asr}'),
                  Text('Maghrib: ${prayerTimes.maghrib}'),
                  Text('Isha: ${prayerTimes.isha}'),
                ],
              );
            }
          }
      ),
      ),
    );
  }

}