import 'package:lightscontrol/models/thing.dart';

class Lights{

  static List<Thing> _things = [];

  static final Lights _lights = Lights._internal();

  factory Lights() {
    return _lights;
  }

  Lights._internal();

  static void addToLights(List<Thing> list){
    _things = list;
  }

  static List<Thing> getLights(){
    return _things;
  }
}