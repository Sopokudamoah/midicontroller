import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';

class MidiControllerProvider with ChangeNotifier {

  MidiControllerProvider(){
    _initMidiController();
  }

  MidiCommand _midiCommand;

  List<MidiDevice> _devices = [];
  List get devices => _devices;

  int _selected;

  int get selected => _selected;

  void setSelected(int index){
    _selected = index;

    if (_selected != null) {
      PCMessage(channel: 0, program: index).send();
    }
    notifyListeners();
  }

  StreamSubscription<String> _setupSubscription;

  void _initMidiController(){
    _midiCommand = MidiCommand();
    scanForDevices();

    _setupSubscription = _midiCommand.onMidiSetupChanged.listen((data) async {
      if (data == "deviceFound") {
        _devices = await _midiCommand.devices;
        notifyListeners();
      }
    });

    _midiCommand.onMidiDataReceived.listen((event) {
      print(event);
    });
  }

  void scanForDevices(){
    _midiCommand.startScanningForBluetoothDevices().catchError((err) {
      print("Error $err");
    }).whenComplete(() async {
      _devices = await _midiCommand.devices;
      notifyListeners();
    });
  }

  void connectToDevice(MidiDevice midiDevice){
    return _midiCommand.connectToDevice(midiDevice);
  }

  @override
  void dispose() {
    _setupSubscription.cancel();
    super.dispose();
  }

  Future<bool> disconnect(){
    _midiCommand.teardown();
    return Future.value(true);
  }

}