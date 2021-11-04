part of screens;

class FirstSetUpNetwork extends StatefulWidget{

  bool firstSetUp = false;

  FirstSetUpNetwork({this.firstSetUp = false});

  @override
  _FirstSetUpNetwork createState() => _FirstSetUpNetwork();
}

class _FirstSetUpNetwork extends State<FirstSetUpNetwork>{


  TextEditingController _deviceIp = new TextEditingController(text: Device.getDeviceIp());

  List<String> _errors = ['Ip Address Can\'t Be Empty', 'Invalid Ip Address'];
  String _errorText = "";
  bool _deviceip = false;

  String _userName = '';
  String _passWord = '';

  @override
  Widget build(BuildContext context) {
    return this.widget.firstSetUp ? Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
          ),
          child: contentBox(context),
        ),
      ),
    ) : contentBox(context);
  }

  @override
  void dispose(){
    super.dispose();
    _deviceIp?.dispose();
  }

  @override
  void initState(){
    super.initState();
    Device.deviceIp.stream.listen((event) {
      if(mounted){
        setState(() {
          _deviceIp.text = event;
        });
      }
    });

    FirstSetUpCreds.passWordController.stream.listen((event) {
      setState(() {
        _passWord = event;
      });
    });

    FirstSetUpCreds.userNameController.stream.listen((event) {
      setState(() {
        _userName = event;
      });
    });
  }

  Container contentBox(BuildContext context){
    return Container(
      padding: EdgeInsets.all(this.widget.firstSetUp ? 20 : 5),
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
                      fontSize: 20)),
              TextField(
                onChanged: (text){
                  if(mounted){
                    setState(() {
                      _deviceip = text.isEmpty;
                      _errorText = _errors[0];
                    });
                  }
                },
                controller: _deviceIp,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\-?\d*\.?\d*\.?\d*\.?\d*')),
                ],
                decoration: InputDecoration(
                  hintText: "Enter Smart Hubs Ip Address",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  errorText: _deviceip ? _errorText : null,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //Text('Port is 443 By Default For Increased Security', style: TextStyle(fontSize: 20, fontFamily: 'Poppins')),
            ],
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              if(_deviceIp.text.isNotEmpty) {
                if(this.widget.firstSetUp){
                  if(!RegExp(r'^\-?\d*\.?\d*\.?\d*\.?\d*').hasMatch(_deviceIp.text)){
                      if(mounted){
                        setState(() {
                          _deviceip = true;
                          _errorText = _errors[1];
                        });
                      }
                  }else{
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return ConnectingDialog();
                        }
                    );

                    RoomControlsApi.hubExists(_deviceIp.text).then((value){
                      if(value is String){
                        if(Navigator.canPop(context))Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return InfoDialog(title: 'Hub Not Found',description: 'The Hub Could Not Be Reached With This Ip Address');
                            }
                        );
                      }else{
                        Device.setDeviceIp(_deviceIp.text);
                        Device.setFirstSetUp(false);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => FirstSetUpCreds(firstSetUp: true)));
                          }
                    });
                  }
                } else {
                  Device.setDeviceIp(_deviceIp.text);
                  Device.setUserName(_userName);
                  Device.setPassWord(_passWord);
                  Device.setFirstSetUp(false);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return InfoDialog(title: 'Data Save',description: 'Data Has Been Save Successfully');
                      }
                  );
                }
              } else {
                if(_deviceIp.text.isEmpty){
                  if(mounted){
                    setState(() {
                      _deviceip = true;
                      _errorText = _errors[0];
                    });
                  }
                }
              }
            },
            child: Container(
              width: 350,
              height: 60,
              child: Center(
                child: Text(this.widget.firstSetUp ? "Next" : "Save",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins-Bold",
                        fontSize: 20,
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
          SizedBox(height: 10),
          InkWell(
            onTap: () {
              _openFile();
            },
            child: Container(
              width: 350,
              height: 60,
              child: Center(
                child: Text("Set Up With File",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins-Bold",
                        fontSize: 20,
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

  void _openFile() async{
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path);

      FileUtils.readCounter(fl: file);

    } else {
      // User canceled the picker
    }
  }

}

