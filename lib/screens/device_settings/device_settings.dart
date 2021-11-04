part of screens;

class DeviceSettings extends StatefulWidget{

  @override
  _DeviceSettings createState() => _DeviceSettings();
}

class _DeviceSettings extends State<DeviceSettings> with SingleTickerProviderStateMixin {

  final ScrollController _scrollController = new ScrollController();

  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context){
    return Container(
      width: 500,
      height: 600,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(padding),
          boxShadow: [
            BoxShadow(color: Colors.black,offset: Offset(0,10),
                blurRadius: 10
            ),
          ]
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(padding),
        ),
        padding: EdgeInsets.all(padding),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                child: FirstSetUpCreds(firstSetUp: false),
                width: 350,
              ),
              Container(
                child: FirstSetUpNetwork(firstSetUp: false),
                width: 350,
              ),

            ],
          ),
        ),
      ),
    );
  }


}
