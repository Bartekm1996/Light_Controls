part of utils;

class ExceptionCatcher extends StatefulWidget{

  final String exception;
  final String stackTrace;

  ExceptionCatcher(this.exception, this.stackTrace);

  @override
  _ExceptionCatcher createState() => _ExceptionCatcher();
}

class _ExceptionCatcher extends State<ExceptionCatcher>{


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
          Text('Oh No !!',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
          SizedBox(height: 15),
          Text('An Error Has Occurred That Has Happened Because Of A Careless Developer', style: TextStyle(fontSize: 14, height: 1.5),textAlign: TextAlign.center,),
          SizedBox(height: 15),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("Cancel",style: TextStyle(fontSize: 18),)),
              SizedBox(width: 10),
              TextButton(
                  onPressed: (){
                    EmailUtils.sendEmail(this.widget.exception, this.widget.stackTrace);
                  },
                  child: Text("Send Report",style: TextStyle(fontSize: 18),)),
            ],
          ),
        ],
      ),
    );
  }
}