part of widgets;

class LightControlLayout extends StatefulWidget{


  @override
  _LightControlLayout createState() => _LightControlLayout();
}

class _LightControlLayout extends State<LightControlLayout>{


  final ScrollController _scrollController = ScrollController();

  List<Thing> _lights = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    getThings();
  }


  void getThings(){
    RoomControlsApi.getThingsByType().then((value) {
      try {
        if (value['error'] != null) {
          if (value['error']['http-code'] == 401) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return InfoDialog(title: 'Invalid Credentials',
                      description: 'Provided Login Details Are Invalid. Change Them In Settings');
                }
            );
          }
        }
      } catch (e) {
        if(mounted) {
          setState(() {
            Lights.addToLights(cast<List<Thing>>(value));
            _lights = cast<List<Thing>>(value);
            _initialized = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if(_lights.isEmpty)
            Align(child: Text('No Bulbs Added\n\nCheck If OpenHab Hub Is Reachable', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Poppins', fontSize: 20)), alignment: Alignment.center),
          if(_lights.isNotEmpty)
            SingleChildScrollView(
              controller: _scrollController,
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
                      child:  GridView.count(
                        shrinkWrap: true,
                        primary: false,
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 25,
                        crossAxisCount: 2,
                        children: _getCards(),
                      ),
                    ),
                  SizedBox(height: 10),
                ],
              ),
              scrollDirection: Axis.vertical,
            ),
            Align(child:Container(
                child: ElevatedButton(
                  onPressed: () {
                    getThings();
                  },
                  child: Icon(Icons.refresh),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(CircleBorder()),
                    padding: MaterialStateProperty.all(EdgeInsets.all(20)),
                    backgroundColor: MaterialStateProperty.all(Colors.blue), // <-- Button color
                  ),
                ),
                alignment: Alignment.bottomLeft,
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

  T cast<T>(x) => x is T ? x : null;
}