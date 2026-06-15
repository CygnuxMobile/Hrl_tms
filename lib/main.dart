import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../environments%20.dart';
import '../../utils/pref.dart';
import '../../utils/tmsapi_method.dart';
import 'get_page.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Pref().init();
   await requestPermissions();
  /// this line can change app build flavor
  AppEnvironments.setupEvm(Environments.hrl);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ScreenUtilInit(
        designSize: const Size(412, 732),
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            color: context.theme.colorScheme.background,
            debugShowCheckedModeBanner: false,
            getPages: getPages,
          );
        },
      ),
    );
  }
}

Future<void> requestPermissions() async {
  Map<Permission, PermissionStatus> status = await [
    Permission.bluetooth,
    Permission.bluetoothAdvertise,
    Permission.bluetoothConnect,
    Permission.bluetoothScan,
    Permission.location,

  ].request();

  status.forEach((key, value) {
    if (value != PermissionStatus.granted ||
        value == PermissionStatus.limited) {
      Fluttertoast.showToast(
          msg: "Permission not granted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // requestPermissions();
    }
  });
}
