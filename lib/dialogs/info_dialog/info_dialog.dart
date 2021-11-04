part of dialogs;


class InfoDialog extends StatelessWidget {

  final String title;
  final String description;
  final bool cancelButton;

  InfoDialog({this.title, this.description, this.cancelButton = false});

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
      height: 175,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(this.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600),),
          SizedBox(height: 15,),
          Text(this.description, style: TextStyle(fontSize: 14, height: 1.5),textAlign: TextAlign.center,),
          SizedBox(height: 22,),
          if(cancelButton)
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context, false);
                      },
                      child: Text("No",style: TextStyle(fontSize: 18),)),
                  TextButton(
                      onPressed: (){
                        Navigator.pop(context, true);
                      },
                      child: Text("Ok",style: TextStyle(fontSize: 18),)),
                ],
              ),
            ),
          if(!cancelButton)
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  onPressed: (){
                    Navigator.pop(context, true);
                  },
                  child: Text("Ok",style: TextStyle(fontSize: 18),)),
            ),
        ],
      ),
    );
  }
}