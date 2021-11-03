import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Device{

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static StreamController passWord = new StreamController<String>.broadcast();
  static StreamController userName = new StreamController<String>.broadcast();
  static StreamController deviceIp = new StreamController<String>.broadcast();

  static final Device _device = Device._internal();

  static String _deviceIp = '';
  static String _devicePort = '8080';
  static String _passWord = '';
  static String _userName = '';
  static bool _firstSetUp = true;

  factory Device() {
    return _device;
  }

  static Future<bool> initPrefs() async{
    SharedPreferences sharedPreferences = await _prefs;

    if(sharedPreferences.containsKey('device_ip')) {
      try {
        _deviceIp = sharedPreferences.getString('device_ip') == null ? '' : sharedPreferences.getString('device_ip');
        _userName = sharedPreferences.getString('username') == null ? '' : sharedPreferences.getString('username');
        _passWord = sharedPreferences.getString('password')  == null ? '' : sharedPreferences.getString('password');
        _firstSetUp = sharedPreferences.getBool('first_set_up') == null ? true : sharedPreferences.getBool('first_set_up');
      } catch (e) {

      }
    }
    else{

    }

    return sharedPreferences.containsKey('device_ip');
  }

  Device._internal();

  static void setSharePrefs(String obj, dynamic item) async{
    SharedPreferences sharedPreferences = await _prefs;

    if(item is bool){
      sharedPreferences.setBool(obj, item);
    }else{
      sharedPreferences.setString(obj, item);
    }
  }

  static void setDeviceIp(String ip){
    setSharePrefs('device_ip', ip);
    deviceIp.sink.add(ip);
    _deviceIp = ip;
  }

  static void setDevicePort(String port){
    setSharePrefs('device_port', port);
    _devicePort = port;
  }

  static void setPassWord(String password){
    setSharePrefs('password', password);
    passWord.sink.add(password);
    _passWord = password;
  }

  static void setUserName(String username){
    setSharePrefs('username', username);
    userName.sink.add(username);
    _userName = username;
  }

  static String getUserName(){
    return _userName;
  }

  static String getDeviceIp(){
    return _deviceIp;
  }

  static String getDevicePort(){
    return _devicePort;
  }

  static String getPassWord(){
    return _passWord;
  }

  static String getDeviceAddress(){
    return Device.getDeviceIp()+':'+Device.getDevicePort();
  }

  static bool isFirstSetUp(){
    return _firstSetUp;
  }

  static void setFirstSetUp(bool firstSetUp){
    setSharePrefs('first_set_up', firstSetUp);
    _firstSetUp = firstSetUp;
  }

  static String encodedCreds(){
    String credentials = Device.getUserName() + ':' + Device.getPassWord();

    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    return stringToBase64.encode(credentials);
  }
}