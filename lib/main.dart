import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:midi_controller_app/blocs/midi_provider.dart';
import 'package:midi_controller_app/pages/device_list_page.dart';
import 'package:provider/provider.dart';
import 'pages/controller.dart';

void main() => runApp(ChangeNotifierProvider<MidiControllerProvider>(
    create: (BuildContext context) => MidiControllerProvider(),
    child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF),
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      home: DeviceListPage(),
    );
  }
}
