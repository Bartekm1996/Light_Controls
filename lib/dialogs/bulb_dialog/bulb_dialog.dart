part of dialogs;

class BulbDialog extends StatefulWidget{

  Thing thing;
  Asset asset;

  BulbDialog({this.thing, this.asset});


  @override
  _BulbDialog createState() => _BulbDialog();
}

class _BulbDialog extends State<BulbDialog>{

  static const double _buttonWidth = 120;
  static const double _buttonHeight = 50;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: contentBox(context),
    );

  }

  Widget contentBox(BuildContext context){
    return Container(
      padding: EdgeInsets.all(20),
      width: 420,
      height: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, size: 100),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name : ' + this.widget.asset.name),
                  SizedBox(height: 5),
                  Text('Vendor : ' + this.widget.asset.vendorName),
                  SizedBox(height: 5),
                  Text('Product Id : ' + this.widget.asset.productId),
                  SizedBox(height: 5),
                  Text('Product Name : ' + this.widget.asset.productName),
                  SizedBox(height: 5),
                ],
              ),
            ],
          ),
          SizedBox(height: 40),
          Row(
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return this.widget.thing.colorLabel != null ? LightColor(singleItem: this.widget.thing) : InfoDialog(title: 'Color Not Supported', description: 'This Bulb Does Not Support Color');
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
                    child: Text("Light Color",
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
              SizedBox(width: 10),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LightTemp(singleItem: this.widget.thing);
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
                    child: Text("Dim Temp",
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
              SizedBox(width: 10),
              InkWell(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return LogDialog(this.widget.thing.uid.replaceAll(":", ""));
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
                    child: Text("View Logs",
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
        ],
      ),
    );
  }

}