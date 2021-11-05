import 'package:catcher/catcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lightscontrol/utils/utils.dart';
import 'package:universal_io/io.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:lightscontrol/models/device.dart';
import 'package:lightscontrol/screens/screens.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:window_size/window_size.dart';

void main() {

  if(kIsWeb){
    setPathUrlStrategy();
  }

  WidgetsFlutterBinding.ensureInitialized();
  Device.initPrefs();
  sqfliteFfiInit();

  if(Platform.isWindows || Platform.isMacOS) {
    setWindowMaxSize(Size(800, 500));
    setWindowMinSize(Size(800, 500));
  }

  if(Platform.isLinux) {
    FileUtils.readCounter(File(
        '/home/pi/Flutter/lightscontrol/creds.txt'));
  }

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
      navigatorKey: Catcher.navigatorKey,
      title: 'Lights Control',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Device.isFirstSetUp() ? (Platform.isLinux ? FirstSetUpRpi() : FirstSetUpNetwork(firstSetUp: true)) : MainScreen(),
    );
  }
}

