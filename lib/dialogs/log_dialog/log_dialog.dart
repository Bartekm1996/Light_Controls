part of dialogs;

class LogDialog extends StatefulWidget{

  final String uid;

  LogDialog(this.uid);

  @override
  _LogDialog createState() => _LogDialog();
}

class _LogDialog extends State<LogDialog>{

  final TextEditingController _textEditingController = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  String _txt = '';

  @override
  void initState() {
    super.initState();
    SqlUtils.read(this.widget.uid).then((value){
      try {
        if(value != null) {

          for (var i = 0; i < value.length; i++) {
            _txt = (_txt + value[i]['timestamp']+ ' : \t' + jsonDecode(value[i]['payload']).toString() + '\n\n');
          }

          if (mounted) {
            setState(() {
              _textEditingController.text = _txt;
            });
          }
        }
      }catch(e){

      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController?.dispose();
    _scrollController?.dispose();
  }

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
      width: 500,
      height: 500,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.grey.shade800.withOpacity(0.7),
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
          Expanded(child:  TextField(
              scrollController: _scrollController,
              style: TextStyle(color: Colors.white),
              decoration: new InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null, //grow automatically
              controller: _textEditingController,
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return InfoDialog(title: "Delete Logs", description: 'Are You Sure To Delete Logs', cancelButton: true);
                  }
              ).then((value) {
                if(value) {
                  _textEditingController.clear();

                  SqlUtils.clearTable(this.widget.uid);
                }
              });
            },
            child: Container(
              width: 500,
              height: 50,
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
                child: Text("Clear Logs",
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
    );
  }

}