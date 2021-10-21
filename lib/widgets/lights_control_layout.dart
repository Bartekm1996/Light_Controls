import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lightscontrol/models/thing.dart';
import 'package:lightscontrol/widgets/device_card.dart';

class LightControlLayout extends StatefulWidget{

  List<Thing> lights = [];
  bool initialized = false;


  LightControlLayout({this.lights, this.initialized});

  @override
  _LightControlLayout createState() => _LightControlLayout();
}

class _LightControlLayout extends State<LightControlLayout>{


  @override
  void initState() {
    super.initState();
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
                  if(!this.widget.initialized)
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
                  if(this.widget.initialized)
                    Container(
                      height: 150,
                      width: 400,
                      child: this.widget.lights.isNotEmpty ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: this.widget.lights.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return DeviceCard(thing: this.widget.lights[index]);
                          }
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

}