part of screens;

class MainScreen extends StatefulWidget{

  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen>{

  List<Thing> _lights = [];
  static const double _buttonWidth = 250;
  static const double _buttonHeight = 50;

  @override
  void initState() {
    super.initState();
    RoomControlsApi.getThingsByType().then((value){
      if(mounted) {
        setState(() {
          _lights = value;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          ActionButton(
            onPressed: (){
            },
            icon: const Icon(Icons.logout),

          ),
          ActionButton(
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(padding),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: FirstSetUp(firstSetUp: false),
                    );
                  }
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(padding),
                  boxShadow: [
                      BoxShadow(color: Colors.black,offset: Offset(0,10), blurRadius: 10
                    ),
                  ]
              ),
              child: LightControlLayout(initialized: true, lights: _lights),
            ),
            SizedBox(width: 30),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      RoomControlsApi.setAllDevicesState('ON');
                    },
                    child: Container(
                      width: _buttonWidth,
                      height: _buttonHeight,
                      decoration: BoxDecoration(
                          color: Colors.green.shade800,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                                color: kActiveShadowColor,
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0)
                          ]
                      ),
                      child:Align(
                        alignment: Alignment.center,
                        child: Text("Turn On Lights",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      RoomControlsApi.setAllDevicesState('OFF');
                    },
                    child: Container(
                      width: _buttonWidth,
                      height: _buttonHeight,
                      decoration: BoxDecoration(
                          color: Colors.red.shade800,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                                color: kActiveShadowColor,
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0)
                          ]
                      ),
                      child:Align(
                        alignment: Alignment.center,
                        child: Text("Turn Off Lights",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LightTemp(things: this._lights);
                          }
                      );
                    },
                    child: Container(
                      width: _buttonWidth,
                      height: _buttonHeight,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                                color: kActiveShadowColor,
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0)
                          ]
                      ),
                      child:Align(
                        alignment: Alignment.center,
                        child: Text("Dim Lights",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.0)),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return LightColor(things: this._lights);
                          }
                      );
                    },
                    child: Container(
                      width: _buttonWidth,
                      height: _buttonHeight,
                      decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                                color: kActiveShadowColor,
                                offset: Offset(0.0, 8.0),
                                blurRadius: 8.0)
                          ]
                      ),
                      child:Align(
                        alignment: Alignment.center,
                        child: Text("Set Lights Color",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins-Bold",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                letterSpacing: 1.0)),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
