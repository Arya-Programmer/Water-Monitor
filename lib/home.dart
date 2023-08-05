import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:monitor_water/water_wave2.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref(); //database reference object
  bool _pumpSwitch = false;
  List<int> receivedData = [];

  void _updateData(bool pumpSwitch) async {
    await databaseRef.update({'pump_switch': pumpSwitch});
  }

  void _toggleSwitch({ switch_: null }) {
    setState(() {
      _pumpSwitch = switch_ ?? !_pumpSwitch;
    });
    _updateData(_pumpSwitch);
  }

  bool _isOutlier(data) {
    double avg = receivedData.reduce((int item, int prevItem) => item+item)/receivedData.length;
    if (avg != 0 && (data <= avg*1.1 && data >= avg*0.9)) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
          stream: databaseRef.onValue,
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
            print(snapshot.data?.snapshot.value);
            if (!snapshot.hasData) {
              return const WaveAnimation(
                filledPercentage: 0,
              );
            }
            var received = (snapshot.data?.snapshot.value as Map)["water_distance"] as int;
            receivedData.add(received);
            if (receivedData.length > 10) {
              receivedData.removeRange(1, receivedData.length-1);
            }
            return Scaffold(
              body: Center(
                  child: WaveAnimation(
                      filledPercentage: _isOutlier(received) ? receivedData[receivedData.length] : received,
                  ),
              ),
              floatingActionButton: Container(
                height: 70,
                width: 110,
                child: ElevatedButton(
                  onPressed: _toggleSwitch,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        if (!(snapshot.data?.snapshot.value as Map)["pump_switch"]) {
                          return Colors.redAccent; //<-- SEE HERE
                        }
                        return Colors.blue; // Defer to the widget's default.
                      },
                    ),
                  ),
                  child: (snapshot.data?.snapshot.value as Map)["pump_switch"] as bool
                      ? const Text("داگرساوە", style: TextStyle(fontSize: 18))
                      : const Text("کوژاوەتەوە", style: TextStyle(fontSize: 18)),
                ),
              ),
            );
          }),
      // body: FutureBuilder(
      //     future: _future,
      //     builder: (context,  snapshot) {
      //       if (snapshot.hasError) {
      //         return Text(snapshot.error.toString());
      //       } else {
      //         return StreamBuilder(
      //           stream: databaseRef.onValue,
      //           builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
      //             print(snapshot.data?.snapshot?.value);
      //             return WaveAnimation(filledPercentage: _waterPercentage);
      //           },
      //         );
      //       }
      //     }),

    );
  }
}
