part of dialogs;

class ConnectingDialog extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }


  Container contentBox(BuildContext context){
    return Container(
      width: 300,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: 10),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Connecting To Smart Hub', style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
          SizedBox(height: 20),
          SpinKitFadingCircle(),
        ],
      ),
    );
  }
}