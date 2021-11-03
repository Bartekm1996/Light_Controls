part of screens;

class MainScreen extends StatefulWidget{

  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen>{

  StreamSubscription<DataConnectionStatus> _dataConnectionChecker;

  Widget _lightLayout = LightControlLayout();


  @override
  void initState() {
    super.initState();

    _dataConnectionChecker = DataConnectionChecker().onStatusChange.listen((event) {
      switch(event){
        case DataConnectionStatus.connected:
          if(Navigator.canPop(context))Navigator.pop(context);
          break;
        case DataConnectionStatus.disconnected:
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return ConnectivityDialog();
              }
          );
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _dataConnectionChecker?.cancel();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.only(top: 20, right: 5, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Column(
                children: [
                 Container(
                  child: ElevatedButton(
                    onPressed: () {
                      RoomControlsApi.setAllDevicesState('ON');
                    },
                    child: Icon(Icons.power_settings_new_outlined),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                      backgroundColor: MaterialStateProperty.all(Colors.green), // <-- Button color
                    ),
                  ),
                ),

                  SizedBox(height: 10),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        RoomControlsApi.setAllDevicesState('OFF');
                      },
                      child: Icon(Icons.power_settings_new_outlined),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(CircleBorder()),
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                        backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LightTemp(things: Lights.getLights());
                            }
                        );
                      },
                      child: Icon(Icons.lightbulb_outlined),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(CircleBorder()),
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                        backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return LightColor(things: Lights.getLights());
                            }
                        );
                      },
                      child: Icon(Icons.color_lens_outlined),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(CircleBorder()),
                        padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                        backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
                      ),
                    ),
                  ),
                ],
              ),
              flex: 1,
            ),

            Container(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(padding),
                          ),
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          child: DeviceSettings(),
                        );
                      }
                  );
                },
                child: Icon(Icons.settings),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Row(
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
                  child: _lightLayout,
                ),
                SizedBox(width: 30),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      /*
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
                      */
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}
