part of screens;

class FirstSetUpCreds extends StatefulWidget{

  bool firstSetUp = false;

  FirstSetUpCreds({this.firstSetUp});

  @override
  _FirstSetUpCreds createState() => _FirstSetUpCreds();
}

class _FirstSetUpCreds extends State<FirstSetUpCreds>{

  TextEditingController _passWord = new TextEditingController(text: Device.getPassWord().isNotEmpty ? Device.getPassWord() : '');
  TextEditingController _userName = new TextEditingController(text: Device.getUserName().isNotEmpty ? Device.getUserName() : '');

  bool _password = false;
  bool _username = false;
  bool _passwordInvisible = true;

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
              Text("User Name",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 26)),
              TextField(
                onChanged: (text){
                  if(mounted){
                    setState(() {
                      _username = text.isEmpty;
                    });
                  }
                },
                controller: _userName,
                decoration: InputDecoration(
                  hintText: "Enter your email",
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
                      fontSize: 26)),
              TextFormField(
                onChanged: (text){
                  if(mounted){
                    setState(() {
                      _password = text.isEmpty;
                    });
                  }
                },
                controller: _passWord,
                obscureText: _passwordInvisible,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordInvisible = (_passwordInvisible ? false : true);
                      });
                    },
                    icon: Icon(
                      _passwordInvisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Enter your password",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
                  errorText: _password ? 'Password Can\'t Be Empty' : null,
                  errorStyle: TextStyle(color: Colors.red, fontSize: 12.0),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
              onTap: () {
                if(_passWord.text.isNotEmpty && _userName.text.isNotEmpty) {

                  Device.setPassWord(_passWord.text);
                  Device.setUserName(_userName.text);

                  if(this.widget.firstSetUp){
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MainScreen()));
                  }else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return InfoDialog(title: 'Data Save',description: 'Data Has Been Save Successfully');
                        }
                    );
                  }

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
                width: 450,
                height: 60,
                child: Center(
                  child: Text("Save",
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
        ],
      ),
    );
  }

}

