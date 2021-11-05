import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lightscontrol/models/thing.dart';
import 'package:lightscontrol/models/asset.dart';
import 'package:lightscontrol/models/device.dart';
import 'package:lightscontrol/utils/utils.dart';


class RoomControlsApi{

  static final RoomControlsApi _roomControlsApi = RoomControlsApi._internal();

  factory RoomControlsApi() {
    return _roomControlsApi;
  }

  RoomControlsApi._internal();


  static Future<List<dynamic>> getDevicesByType(String type, {String typeTwo = ""}) async{

    String _deviceAddress = Device.getDeviceAddress();

    List<dynamic> devices = [];
    var js = jsonDecode((await http.get(Uri.parse("http://$_deviceAddress/rest/items"), headers: {
      "Accept": "application/json",
    })).body);

    for(var i = 0; i < js.length; i++){
      print(js[i]['name']);
      if(js[i]['name'].contains(type) || js[i]['name'].contains(typeTwo)){
        devices.add(js[i]);
      }
    }

    return devices;
  }

  static Future<Asset> getThingByType(String uid) async{

    String _deviceAddress = Device.getDeviceAddress();

    Asset _asset;

    try {

      var js = jsonDecode((await http.get(
          Uri.parse("http://$_deviceAddress/rest/things/$uid"), headers: {
        "Accept": "application/json",
        "Authorization": "Basic " + Device.encodedCreds(),
      })).body);

      if (js != null) {
        _asset = new Asset(js['label'], js['properties']['vendorName'] ?? js['properties']['vendor'], js['properties']['productName'] ?? '',  js['properties']['productId'] ?? js['properties']['modelId'], js['statusInfo']['status'], js['statusInfo']['statusDetail'], statusDescription: js['statusInfo']['description'] != null ? js['statusInfo']['description'] : null);
      }

    }catch(error,stackTrace) {
      ExceptionCatcher(error, stackTrace.toString());
    }

    return _asset;
  }

  static Future<dynamic> getThingsByType() async{

    String _deviceAddress = Device.getDeviceAddress();

    List<Thing> devices = [];
    List<String> channels = [];

    try {

      var js = jsonDecode((await http.get(
          Uri.parse("http://$_deviceAddress/rest/things"), headers: {
        "Accept": "application/json",
        "Authorization": "Basic " + Device.encodedCreds(),
      })).body);


      if(js[0] == null)return js;

      if (js != null) {

        for (var i = 0; i < js.length; i++) {

          if ((js[i]['label'].toLowerCase()).contains("Bulb".toLowerCase()) ||
              (js[i]['properties']['productName'] != null
                  ? (js[i]['properties']['productName']).contains('light')
                  : false) || js[i]['configuration']['lightId'] != null) {

            for (var j = 0; j < js[i]['channels'].length; j++) {
              channels.add(js[i]['channels'][j]['label']);
            }

            devices.add(new Thing(js[i]['UID'], js[i]['label'],
                channels.contains('Power') ? 'Power' : channels.contains(
                    'Brightness') ? 'Brightness' : 'Color',
                channels.contains('Color') ? 'Color' : channels.contains('RGBColor') ? 'RGBColor' : null,
                channels.contains('Brightness')
                    ? 'Brightness'
                    : 'Temperature', channels));

            channels.clear();
          }
        }
      }
    } on FormatException catch(e){
      ExceptionCatcher('Format Exception', e.message.toString());
    } catch(error,stackTrace) {
      ExceptionCatcher(error, stackTrace.toString());
    }

    return devices;
  }

  static Future<String> getDeviceByType(String type) async{

    String _deviceAddress = Device.getDeviceAddress();
    var tmp;
    var js = jsonDecode((await http.get(Uri.parse("https://$_deviceAddress/rest/items"), headers: {"Accept": "application/json"})).body);

    for(var i = 0; i < js.length; i++){
      if(js[i]['name'].contains(type)){
        tmp = js[i];
      }
    }

    return await getState(tmp['name']);
  }

  static Future<void> setAllDevicesState(String state) async{
    List<Thing> lights = await getThingsByType();

    for(var i = 0; i < lights.length; i++){
      setState(lights[i].label.replaceAll(" ", ""), lights[i].action, state == 'ON' ? (lights[i].action == 'Power' ? 'ON' : lights[i].action == 'Brightness' ? 100 : '0.0,0,100') : (lights[i].action == 'Power' ? 'OFF' : lights[i].action == 'Brightness' ? 0 : '0.0,0,0'));
    }

  }

  static Future<bool> getAllDevicesState(String type) async{
    List<dynamic> lights = await getDevicesByType(type);
    int count = 0;

    for(var i = 0; i < lights.length; i++){
      if(lights[i]['state'] == 'OFF')count++;
    }

    return count == lights.length;
  }



  static Future<http.Response> setState(String name, String attr, dynamic val) async{

    String _deviceAddress = Device.getDeviceAddress();

    return http.post(
        Uri.parse('http://$_deviceAddress/rest/items/$name' + '_' + '$attr'),
        headers: {
          'Content-Type': 'text/plain',
          'Accept': '*/*',
        },
        body: '$val'
    );
  }

  static Future<String> getState(String name) async{

    String _deviceAddress = Device.getDeviceAddress();

    var js = jsonDecode((await http.get(
      Uri.parse('http://$_deviceAddress/rest/items/$name'),
      headers: {
        "Accept": "application/json",
      },
    )).body);

    return js['state'];
  }


  static Future<dynamic> getThingState(String name) async{

    String _deviceAddress = Device.getDeviceAddress();


    var js = jsonDecode((await http.get(
      Uri.parse('http://$_deviceAddress/rest/things/$name'),
      headers: {
        "Accept": "application/json",
        "Authorization": "Basic " + Device.encodedCreds(),
      },
    )).body);

    return js;
  }


  static Future<dynamic> hubExists(String ipAddr) async{

    String _deviceIp = ipAddr+':'+Device.getDevicePort();

    return await http.get(
      Uri.parse('http://$_deviceIp/rest/items'),
      headers: {
        "Accept": "application/json",
      },
    );
  }

}