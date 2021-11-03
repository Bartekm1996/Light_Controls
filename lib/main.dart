import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:lightscontrol/models/device.dart';
import 'package:lightscontrol/screens/screens.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {

  if(kIsWeb){
    setPathUrlStrategy();
  }

  WidgetsFlutterBinding.ensureInitialized();
  Device.initPrefs();
  sqfliteFfiInit();
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft])
      .then((_) {
    runApp(MyApp());
  });

}

class MyApp extends StatefulWidget {

  @override
  _MyApp createState() => _MyApp();

}

class _MyApp extends State<MyApp>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lights Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Device.isFirstSetUp() ? FirstSetUpNetwork(firstSetUp: true) : MainScreen(),
    );
  }
}

