import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightscontrol/api/room_controls.dart';
import 'package:lightscontrol/models/thing.dart';
import 'package:lightscontrol/widgets/device_card.dart';

class LightControlLayout extends StatefulWidget{


  @override
  _LightControlLayout createState() => _LightControlLayout();
}

class _LightControlLayout extends State<LightControlLayout>{

  List<Thing> _lights = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    RoomControlsApi.getThingsByType().then((value){
      if(mounted) {
        setState(() {
          _lights = value;
          _initialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
            child:  SingleChildScrollView(
              child: Column(
                children: [
                  if(!_initialized)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator(
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      ),
                    ),
                  if(_initialized)
                    Container(
                      width: 400,
                      child: _lights.isNotEmpty ? SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: GridView.count(
                          shrinkWrap: true,
                          primary: false,
                          crossAxisSpacing: 25,
                          mainAxisSpacing: 25,
                          crossAxisCount: 2,
                          children: _getCards(),
                        ),
                      ) : Align(child: Text('No Bulbs Added', style: TextStyle(fontFamily: 'Poppins', fontSize: 20)), alignment: Alignment.center),
                    ),
                  SizedBox(height: 10),
                ],
              ),
              scrollDirection: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }

  List<DeviceCard> _getCards(){
    List<DeviceCard> cards = [];

    for(var i = 0; i < _lights.length; i++){
      cards.add(DeviceCard(thing: _lights[i]));
    }

    return cards;
  }

}