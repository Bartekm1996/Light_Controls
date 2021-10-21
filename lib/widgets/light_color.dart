
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:lightscontrol/api/room_controls.dart';
import 'package:lightscontrol/models/thing.dart';


class LightColor extends StatefulWidget{

  Thing singleItem;
  List<Thing> things;

  LightColor({this.things, this.singleItem});


  @override
  _LightColor createState() => _LightColor();

}

class _LightColor extends State<LightColor>{

  Color _pickerColor = Color(0xff443a49);

  @override
  void initState() {
    super.initState();


    if(this.widget.singleItem != null){
      RoomControlsApi.getState(this.widget.singleItem.label.replaceAll(" ", "") + '_' + this.widget.singleItem.colorLabel).then((value){
        List<String> splt = value.split(",");
        _pickerColor = Color.fromARGB(0, int.parse(splt[0]), int.parse(splt[1]), int.parse(splt[2]));
      });
    }else{
      if(this.widget.things.isNotEmpty) {
        RoomControlsApi.getState(
            this.widget.things[0].label.replaceAll(" ", "") + '_' +
                this.widget.things[0].colorLabel).then((value) {
          List<String> splt = value.split(",");
          _pickerColor = Color.fromARGB(
              0, double.parse(splt[0]).round(), int.parse(splt[1]),
              int.parse(splt[2]));
        });
      }
    }



  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Stack contentBox(BuildContext context){
    return Stack(
      children: <Widget>[
        Container(
          width: 500,
          height: 270,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            children: [
              ColorPicker(
                pickerColor: _pickerColor,
                onColorChanged: (color){
                  if(mounted) {
                    setState(() {
                      _pickerColor = color;
                    });
                  }
                },
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),

              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: TextButton(onPressed: (){
                    HSVColor color = HSVColor.fromColor(_pickerColor);

                    if(this.widget.singleItem != null){
                      setColorToBulb(color);
                    }else{
                      setColorToAll(color);
                    }

                    }, child: Text('Set Color', style: TextStyle(fontSize: 20, fontFamily: 'Poppins'))),
                  padding: EdgeInsets.only(right: 15),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void setColorToBulb(HSVColor color){
    RoomControlsApi.setState(this.widget.singleItem.label.replaceAll(" ", ""), this.widget.singleItem.colorLabel, color.hue.toInt().toString() + ',' + (color.saturation*100).toInt().toString() + ',' + (color.value*100).toInt().toString());
  }

  void setColorToAll(HSVColor color){
    for(var i = 0; i < this.widget.things.length; i++){
      RoomControlsApi.setState(this.widget.things[i].label.replaceAll(" ", ""), this.widget.things[i].colorLabel, color.hue.toInt().toString() + ',' + (color.saturation*100).toInt().toString() + ',' + (color.value*100).toInt().toString());
    }
  }



}