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
              context: context,
              builder: (BuildContext context) {
                return ConnectivityDialog();
              }
          );
          break;
      }
    });

    if(Platform.isLinux) {
      Watcher(
          '/home/pi/Flutter/lightscontrol/creds.txt')
          .events.listen((event) {
        if (event.type == ChangeType.MODIFY) {
          FileUtils.readCounter(File(event.path));
        }
      });
    }

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
              ],
            ),
          ],
        ),
      ),
    );
  }


}
