part of screens;

class FirstSetUpRpi extends StatefulWidget{


  FirstSetUpRpi();

  @override
  _FirstSetUpRpi createState() => _FirstSetUpRpi();
}

class _FirstSetUpRpi extends State<FirstSetUpRpi>{


  @override
  Widget build(BuildContext context) {
    return contentBox(context);
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
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
              Text("To Set Up Lights Control Edit The Config Following File /home/pi/Flutter/lightscontrol/creds.txt",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 24)),
            ],
          ),
          SizedBox(height: 20),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MainScreen()));
            },
            child: Container(
              width: 350,
              height: 60,
              child: Center(
                child: Text("Continue",
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

