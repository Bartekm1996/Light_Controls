library screens;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'package:lightscontrol/utils/utils.dart';
import 'package:lightscontrol/models/device.dart';
import 'package:lightscontrol/models/lights.dart';
import 'package:lightscontrol/dialogs/dialogs.dart';
import 'package:lightscontrol/api/room_controls.dart';
import 'package:lightscontrol/widgets/widgets_lib.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:watcher/watcher.dart';

part 'main_screen/main_screen.dart';
part 'first_set_up/first_set_up_creds.dart';
part 'first_set_up/first_set_up_network.dart';
part 'first_set_up/first_set_up_rpi.dart';
part 'device_settings/device_settings.dart';