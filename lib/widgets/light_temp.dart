part of widgets;

class LightTemp extends StatefulWidget{

  final List<Thing> things;
  final Thing singleItem;

  LightTemp({this.things, this.singleItem});

  @override
  _LightTemp createState() => _LightTemp();
}

class _LightTemp extends State<LightTemp>{

  double _lightTemp = 0;
  
  @override
  void initState() {
    super.initState();
    if(this.widget.singleItem != null){
      RoomControlsApi.getState(this.widget.singleItem.label.replaceAll(" ", "") + '_' + this.widget.singleItem.brightnessLabel).then((value){
        setState(() {
          _lightTemp = double.parse(value);
        });
      });
    }else{
      if(this.widget.things.isNotEmpty) {
        RoomControlsApi.getState(
            this.widget.things[0].label.replaceAll(" ", "") + '_' +
                this.widget.things[0].brightnessLabel).then((value) {
          setState(() {
            _lightTemp = double.parse(value);
          });
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
          width: 400,
          height: 175,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Text('Set Light Brightness', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins', fontSize: 20)),
                  padding: EdgeInsets.only(left: 10),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              SfSlider(
                min: 0,
                max: 100,
                value: _lightTemp,
                interval: 20,
                showDividers: true,
                stepSize: 5,
                showLabels: true,
                enableTooltip: true,
                onChanged: (dynamic value){
                  setState(() {
                    _lightTemp = value;
                  });
                },
              ),
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: TextButton(onPressed: (){
                    if(this.widget.singleItem != null){
                      setTempToBulb(_lightTemp.round());
                    }else{
                      setTempToAll(_lightTemp.round());
                    }
                  }, child: Text('Dim Lights', style: TextStyle(fontSize: 20, fontFamily: 'Poppins'))),
                  padding: EdgeInsets.only(right: 15),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void setTempToBulb(int lightTemp){
    RoomControlsApi.setState(this.widget.singleItem.label.replaceAll(" ", ""), this.widget.singleItem.brightnessLabel, lightTemp);
  }

  void setTempToAll(int lightTemp){
    for(var i = 0; i < this.widget.things.length; i++){
      RoomControlsApi.setState(this.widget.things[i].label.replaceAll(" ", ""), this.widget.things[i].brightnessLabel, lightTemp);
    }
  }

}