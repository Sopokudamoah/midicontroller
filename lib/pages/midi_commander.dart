import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:midi_controller_app/blocs/midi_provider.dart';
import 'package:provider/provider.dart';

class MidiCommander extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = List(40);
    list.fillRange(0, 39, 0);

    return Scaffold(body:
        Consumer<MidiControllerProvider>(builder: (_, midiController, child) {
      return GridView.builder(
        itemCount: list.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.all(8),
            child: NeumorphicButton(
              style: NeumorphicStyle(
                lightSource: LightSource.topLeft,
                  depth: index == midiController.selected ? -20 : 3,
                  intensity: 0.8,
                  border: NeumorphicBorder(
                    isEnabled: index == midiController.selected,
                    width: 4,
                    color: Colors.amber.shade200
                  ),
                  shape: NeumorphicShape.flat,
                  boxShape: NeumorphicBoxShape.circle()),
              child: Center(child: Text("${index + 1}")),
              onPressed: () {
                midiController.setSelected(index);
              },
              // value: index,
              // groupValue: midiController.selected,
              // onChanged: midiController.setSelected,
            ),
          );
        },
      );
    }));
  }
}
