part of widgets;

class DeviceCard extends StatefulWidget{

  final Thing thing;

  DeviceCard({this.thing});

  @override
  _DeviceCard createState() => _DeviceCard();


}

class _DeviceCard extends State<DeviceCard>{

  StreamSubscription<DataConnectionStatus> _dataConnectionChecker;

  html.EventSource _eventSourcePower;
  html.EventSource _itemOnlineStatus;

  Asset _asset = new Asset('','','', '', '', '', statusDescription:  '');

  bool _on = false;
  bool _error = false;
  bool _connectionStatus = false;
  String _errorMessage = "";
  String _deviceAddress = Device.getDeviceAddress();

  @override
  void initState() {
    super.initState();

    SqlUtils.createDb(this.widget.thing.uid.replaceAll(":",""));

    _dataConnectionChecker = DataConnectionChecker().onStatusChange.listen((event) {
      setState(() {
        _connectionStatus == DataConnectionStatus.connected;
      });
    });

    RoomControlsApi.getThingByType(this.widget.thing.uid).then((value) {
        setState(() {
          _asset = value;
        });
    });

    RoomControlsApi.getState(this.widget.thing.label.replaceAll(" ", "")+"_"+this.widget.thing.action).then((value) {
      try {
        setState(() {
          _on =
          (this.widget.thing.action == 'Power' ? value == 'ON' : this.widget
              .thing.action == 'Brightness' ? int.parse(value) > 0 : int.parse(
              value.split(',')[2]) > 0);
        });
      }catch(e){

      }
    });

    RoomControlsApi.getThingState(this.widget.thing.uid).then((value){
      try {
        setState(() {
          _error = value['statusInfo']['status'] == "OFFLINE";
          _errorMessage = value['statusInfo']['statusDetail'] == "NONE"
              ? value['statusInfo']['description']
              : value['statusInfo']['statusDetail'];
        });
      }catch(e){

      }
    });

    eventSourcePower();
    onlineStatusListener();

  }

  void onlineStatusListener() async {


    _itemOnlineStatus = html.EventSource('http://$_deviceAddress/rest/events?topics=openhab/things/'+this.widget.thing.uid+'/status');

    _itemOnlineStatus.addEventListener('message', (html.Event message) {

        setState(() {
          try {


            _error = (jsonDecode(jsonDecode((message as html.MessageEvent)
                .data as String)['payload'])['status']) != 'ONLINE';


            _errorMessage =
            (jsonDecode(jsonDecode((message as html.MessageEvent)
                .data as String)['payload'])['statusDetail']);

          }catch(e){

          }
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
        setState(() {
          try {

            js = jsonDecode(jsonDecode((message as html.MessageEvent)
                .data as String)['payload'])['value'];


            SqlUtils.insert(this.widget.thing.uid.replaceAll(":", ""),(message as html.MessageEvent)
                .data as String);

            _on =
            (this.widget.thing.action == 'Power' ? js == 'ON' : this.widget
                .thing
                .action == 'Brightness' ? int.parse(js) > 0 : int.parse(
                js.split(',')[2]) > 0);
          }catch(e){

          }
        });

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
    _dataConnectionChecker?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: (){
          var js = _on ? (this.widget.thing.action == 'Power' ? 'OFF' : this.widget.thing.action == 'Brightness' ? 0 : '0.0,0,0') : (this.widget.thing.action == 'Power' ? 'ON' : this.widget.thing.action == 'Brightness' ? 100 : '0.0,0,100');;
          RoomControlsApi.setState(this.widget.thing.label.replaceAll(" ", ""), this.widget.thing.action, js);
        },
        onLongPress: (){
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return BulbDialog(thing: this.widget.thing, asset: _asset);
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
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(icon: Icon(Icons.info_outline, color: (_error || _connectionStatus ? Colors.red :Colors.transparent)), onPressed: (){
                  if(_error) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return InfoDialog(title: _asset.status,
                              description: _asset.statusDescription != null
                                  ? _asset.statusDescription.toUpperCase()
                                  : _asset.statusInfo.toUpperCase());
                        }
                    );
                  }
                }),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_outline, size: 60,
                      color: _on
                          ? (_error || _connectionStatus ? Colors.black : Colors.yellow.shade800)
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
            ],
          ),
        ),
      ),
    );
  }


}
