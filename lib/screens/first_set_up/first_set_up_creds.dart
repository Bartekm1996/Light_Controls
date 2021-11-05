part of screens;

class FirstSetUpCreds extends StatefulWidget{

  static StreamController userNameController = new StreamController<String>.broadcast();
  static StreamController passWordController = new StreamController<String>.broadcast();

  bool firstSetUp = false;

  FirstSetUpCreds({this.firstSetUp});

  @override
  _FirstSetUpCreds createState() => _FirstSetUpCreds();
}

class _FirstSetUpCreds extends State<FirstSetUpCreds>{


  TextEditingController _passWord = new TextEditingController(text: Device.getPassWord());
  TextEditingController _userName = new TextEditingController(text: Device.getUserName());

  bool _password = false;
  bool _username = false;
  bool _passwordInvisible = true;

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
    _passWord?.dispose();
    _userName?.dispose();

  }

  @override
  void initState(){
    super.initState();
    Device.userName.stream.listen((event) {
      if(mounted){
        setState(() {
          _userName.text = event;
        });
      }
    });

    Device.passWord.stream.listen((event) {
      if(mounted){
        setState(() {
          _passWord.text = event;
        });
      }
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
              Text("User Name",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20)),
              TextField(
                onChanged: (text){
                  if(mounted){
                    setState(() {
                      _username = text.isEmpty;
                    });
                  }

                  if(!this.widget.firstSetUp){
                    FirstSetUpCreds.userNameController.sink.add(text);
                  }
                },
                controller: _userName,
                decoration: InputDecoration(
                  hintText: "Enter Smarts Hub Email",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  errorText: _username ? 'User Name Can\'t Be Empty' : null,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Password",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 20)),
              TextFormField(
                onChanged: (text){
                  if(mounted){
                    setState(() {
                      _password = text.isEmpty;
                    });
                  }

                  if(!this.widget.firstSetUp){
                    FirstSetUpCreds.passWordController.sink.add(text);
                  }
                },
                controller: _passWord,
                obscureText: _passwordInvisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      if(mounted) {
                        setState(() {
                          _passwordInvisible =
                          (_passwordInvisible ? false : true);
                        });
                      }
                    },
                    icon: Icon(
                      _passwordInvisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Enter Smarts Hub Password",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  errorText: _password ? 'Password Can\'t Be Empty' : null,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
          if(this.widget.firstSetUp && !Platform.isLinux)
          InkWell(
            onTap: () {
              if(_passWord.text.isNotEmpty && _userName.text.isNotEmpty) {

                Device.setPassWord(_passWord.text);
                Device.setUserName(_userName.text);

                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MainScreen()));

              } else {


                if(_userName.text.isEmpty){
                  if(mounted){
                    setState(() {
                      _username = true;
                    });
                  }
                }

                if(_passWord.text.isEmpty){
                  if(mounted){
                    setState(() {
                      _password = true;
                    });
                  }
                }
              }

            },
            child: Container(
              width: 350,
              height: 60,
              child: Center(
                child: Text("Save",
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

}

