import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:rhythmik_music_player/views/base_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await OnAudioRoom().initRoom();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Beats',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.blue,
            appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent, elevation: 0)),
        home: BaseScreen());
  }
}
