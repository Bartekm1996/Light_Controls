import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightscontrol/api/room_controls.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lightscontrol/models/device.dart';
import 'package:lightscontrol/models/thing.dart';
import 'package:lightscontrol/utils/constants.dart';
import 'package:lightscontrol/widgets/light_color.dart';
import 'package:universal_html/html.dart' as html;



class DeviceCard extends StatefulWidget{

  //final String type;
  final Thing thing;
  //final dynamic device;


  DeviceCard({this.thing});

  @override
  _DeviceCard createState() => _DeviceCard();


}

class _DeviceCard extends State<DeviceCard>{

  html.EventSource _eventSourcePower;
  html.EventSource _itemOnlineStatus;



  bool _on = false;
  bool _error = false;
  String _errorMessage = "";
  String _deviceAddress = Device.getDeviceAddress();

  @override
  void initState() {
    super.initState();
    RoomControlsApi.getState(this.widget.thing.label.replaceAll(" ", "")+"_"+this.widget.thing.action).then((value) {
      if(mounted) {
        setState(() {
          _on =
          (this.widget.thing.action == 'Power' ? value == 'ON' : this.widget
              .thing.action == 'Brightness' ? int.parse(value) > 0 : int.parse(
              value.split(',')[2]) > 0);
        });
      }
    });

    eventSourcePower();



  }

  void onlineStatusListener() async {


    _itemOnlineStatus = html.EventSource('http://$_deviceAddress/rest/events?topics=openhab/things/'+this.widget.thing.uid+'/status');

    _itemOnlineStatus.addEventListener('message', (html.Event message) {
      setState(() {
        _error = (jsonDecode(jsonDecode((message as html.MessageEvent).data as String)['payload'])['status']) != 'ONLINE';
        _errorMessage = (jsonDecode(jsonDecode((message as html.MessageEvent).data as String)['payload'])['statusDetail']);
      });

    });

    _itemOnlineStatus.onError.listen((event) {
      _itemOnlineStatus?.close();
    });


  }


  void eventSourcePower() async{

    var js;
    _eventSourcePower = html.EventSource('http://$_deviceAddress/rest/events?topics=openhab/items/'+this.widget.thing.label.replaceAll(" ", "")+'_'+this.widget.thing.action+'/statechanged');


    _eventSourcePower.addEventListener('message', (html.Event message) {

      if(mounted) {
        setState(() {
          js = jsonDecode(jsonDecode((message as html.MessageEvent)
              .data as String)['payload'])['value'];
          _on =
          (this.widget.thing.action == 'Power' ? js == 'ON' : this.widget.thing
              .action == 'Brightness' ? int.parse(js) > 0 : int.parse(
              js.split(',')[2]) > 0);
        });
      }

    });

    _eventSourcePower.onError.listen((event) {
      _eventSourcePower?.close();
    });



  }


  @override
  void dispose() {
    super.dispose();
    _eventSourcePower?.close();
    _itemOnlineStatus?.close();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (){
          var js = _on ? (this.widget.thing.action == 'Power' ? 'OFF' : this.widget.thing.action == 'Brightness' ? 0 : '0.0,0,0') : (this.widget.thing.action == 'Power' ? 'ON' : this.widget.thing.action == 'Brightness' ? 100 : '0.0,0,100');
          RoomControlsApi.setState(this.widget.thing.label.replaceAll(" ", ""), this.widget.thing.action, js);
        },
        onLongPress: (){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return LightColor(singleItem: this.widget.thing);
              }
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(padding),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lightbulb_outline, size: 60,
                  color: _on
                      ? Colors.yellow.shade800
                      : Colors.black),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  text: this.widget.thing.label,
                  style: TextStyle(color: Colors.black),
                ),
                overflow: TextOverflow.ellipsis,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
