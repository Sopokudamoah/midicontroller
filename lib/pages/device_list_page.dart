import 'package:flutter/material.dart';
import 'package:midi_controller_app/blocs/midi_provider.dart';
import 'package:provider/provider.dart';

import 'controller.dart';

class DeviceListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: const Text('FlutterMidiCommand'),
          actions: <Widget>[
            IconButton(
                onPressed: () {
                  Provider.of<MidiControllerProvider>(context, listen: false).scanForDevices();
                },
                icon: Icon(Icons.refresh))
          ],
        ),
        body: Consumer<MidiControllerProvider>(
          builder: (_, midiController, child){
            return ListView.builder(
              itemCount: midiController.devices.length,
              itemBuilder: (context, index) {
                final device = midiController.devices[index];

                return ListTile(
                  title: Text(
                    device.name,
                  ),
                  trailing: device.type == "BLE"
                      ? Icon(Icons.bluetooth)
                      : null,
                  onTap: () {
                    midiController.connectToDevice(device);
                    Navigator.of(context).push(MaterialPageRoute<Null>(
                      builder: (_) => ControllerPage(),
                    ));
                  },
                );
              },
            );
          },
        )
    );
  }
}
