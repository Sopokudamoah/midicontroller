import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_midi_command/flutter_midi_command.dart';
import 'package:flutter_midi_command/flutter_midi_command_messages.dart';
import 'package:midi_controller_app/blocs/midi_provider.dart';
import 'package:provider/provider.dart';

import 'midi_commander.dart';

class ControllerPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<MidiControllerProvider>(
      builder: (_, midiController, child){
        return WillPopScope(
            onWillPop: midiController.disconnect,
            child: Scaffold(
              appBar: AppBar(
                title: Text('Controls'),
              ),
              body: MidiCommander(),
            ));
      },
    );
  }
}

class MidiControls extends StatefulWidget {
  @override
  MidiControlsState createState() {
    return new MidiControlsState();
  }
}

class MidiControlsState extends State<MidiControls> {
  var _channel = 0;
  var _controller = 0;
  var _value = 0;

  StreamSubscription<List<int>> _rxSubscription;
  MidiCommand _midiCommand = MidiCommand();

  @override
  void initState() {
    print('init controller');
    _rxSubscription = _midiCommand.onMidiDataReceived.listen((data) {
      print('on data $data');
      var status = data[0];

      if (status == 0xF8) {
        print('beat');
        return;
      }

      if (data.length >= 2) {
        var d1 = data[1];
        var d2 = data[2];
        var rawStatus = status & 0xF0; // without channel
        var channel = (status & 0x0F);
        if (rawStatus == 0xB0 && channel == _channel && d1 == _controller) {
          setState(() {
            _value = d2;
          });
        }
      }
    });
    super.initState();
  }

  void dispose() {
    _rxSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SteppedSelector('Channel', _channel + 1, 1, 16, _onChannelChanged),
          SteppedSelector(
              'Controller', _controller, 0, 127, _onControllerChanged),
          SlidingSelector('Value', _value, 0, 127, _onValueChanged),
        ],
      ),
    );
  }

  _onChannelChanged(int newValue) {
    setState(() {
      _channel = newValue - 1;
    });
  }

  _onControllerChanged(int newValue) {
    setState(() {
      _controller = newValue;
    });
  }

  _onValueChanged(int newValue) {
    setState(() {
      _value = newValue;
      PCMessage(channel: _channel, program: 0).send();
    });
  }
}

class SteppedSelector extends StatelessWidget {
  final String label;
  final int minValue;
  final int maxValue;
  final int value;
  final Function(int) callback;

  SteppedSelector(
      this.label, this.value, this.minValue, this.maxValue, this.callback);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(label),
        IconButton(
            icon: Icon(Icons.remove_circle),
            onPressed: (value > minValue)
                ? () {
                    callback(value - 1);
                  }
                : null),
        Text(value.toString()),
        IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: (value < maxValue)
                ? () {
                    callback(value + 1);
                  }
                : null)
      ],
    );
  }
}

class SlidingSelector extends StatelessWidget {
  final String label;
  final int minValue;
  final int maxValue;
  final int value;
  final Function(int) callback;

  SlidingSelector(
      this.label, this.value, this.minValue, this.maxValue, this.callback);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(label),
        Slider(
          value: value.toDouble(),
          divisions: maxValue,
          min: minValue.toDouble(),
          max: maxValue.toDouble(),
          onChanged: (v) {
            callback(v.toInt());
          },
        ),
        Text(value.toString()),
      ],
    );
  }
}
