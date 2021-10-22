part of screens;

class DeviceSettings extends StatefulWidget{

  @override
  _DeviceSettings createState() => _DeviceSettings();
}

class _DeviceSettings extends State<DeviceSettings> with SingleTickerProviderStateMixin {

  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    print(Device.getDeviceAddress());
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
      width: 550,
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
      child: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.selected,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.network_check_rounded),
                label: Text('Network'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person),
                label: Text('Credientials'),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
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
                      if(_selectedIndex == 0)
                        FirstSetUpNetwork(firstSetUp: false),
                      if(_selectedIndex == 1)
                        FirstSetUpCreds(firstSetUp: false),
                    ],
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }


}
