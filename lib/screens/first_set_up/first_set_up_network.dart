part of screens;

class FirstSetUpNetwork extends StatefulWidget{

  bool firstSetUp = false;

  FirstSetUpNetwork({this.firstSetUp = false});

  @override
  _FirstSetUpNetwork createState() => _FirstSetUpNetwork();
}

class _FirstSetUpNetwork extends State<FirstSetUpNetwork>{

  TextEditingController _deviceIp = new TextEditingController(text: Device.getDeviceIp().isNotEmpty ? Device.getDeviceIp() : '');
  TextEditingController _devicePort = new TextEditingController(text:  Device.getDevicePort().isNotEmpty ? Device.getDevicePort() : '');

  bool _deviceport = false;
  bool _deviceip = false;

  @override
  Widget build(BuildContext context) {
    return this.widget.firstSetUp ? Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
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
          child: contentBox(context),
        ),
      ),
    ) : contentBox(context);
  }

  Container contentBox(BuildContext context){
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Smart Hubs Ip Address",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 26)),
              TextField(
                onChanged: (text){
                  if(mounted){
                    setState(() {
                      _deviceip = text.isEmpty;
                    });
                  }
                },
                controller: _deviceIp,
                decoration: InputDecoration(
                  hintText: "Enter Smart Hubs Ip Address",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  errorText: _deviceip ? 'Ip Address Can\'t Be Empty' : null,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Smart Hubs Port",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 26)),
              TextFormField(
                onChanged: (text){
                  if(mounted){
                    setState(() {
                      _deviceport = text.isEmpty;
                    });
                  }
                },
                controller: _devicePort,
                decoration: InputDecoration(
                  hintText: "Enter Smart Hubs Port",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  errorText: _deviceport ? 'Port Can\'t Be Empty' : null,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              if(_devicePort.text.isNotEmpty && _deviceIp.text.isNotEmpty) {

                Device.setDeviceIp(_deviceIp.text);
                Device.setDevicePort(_devicePort.text);
                Device.setFirstSetUp(false);

                if(this.widget.firstSetUp){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FirstSetUpCreds(firstSetUp: true)));
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return InfoDialog(title: 'Data Save',description: 'Data Has Been Save Successfully');
                      }
                  );
                }

              } else {

                if(_devicePort.text.isEmpty){
                  if(mounted){
                    setState(() {
                      _deviceport = true;
                    });
                  }
                }

                if(_deviceIp.text.isEmpty){
                  if(mounted){
                    setState(() {
                      _deviceip = true;
                    });
                  }
                }

              }

            },
            child: Container(
              width: 450,
              height: 60,
              child: Center(
                child: Text(this.widget.firstSetUp ? "Next" : "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins-Bold",
                        fontSize: 30,
                        letterSpacing: 1.0)),
              ),
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(6.0),
                  boxShadow: [
                    BoxShadow(
                        color: kActiveShadowColor,
                        offset: Offset(0.0, 8.0),
                        blurRadius: 8.0)
                  ]),

            ),
          ),
        ],
      ),
    );
  }

}

