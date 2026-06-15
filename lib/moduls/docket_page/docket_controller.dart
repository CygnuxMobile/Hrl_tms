// ignore_for_file: prefer_interpolation_to_compose_strings
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:get/get.dart';
import '../../widgets/tms_button.dart';
import '../../environments%20.dart';
import '../../utils/pref.dart';

import '../../model/dash_board_model/location_master.dart';
import '../../model/docket_model/docket.dart';
import '../../utils/tms_color.dart';
import '../home_page/dash_board_controller.dart';

enum DataStatus { loading, completed, error }

enum PrinterEnum { gcn, quickDocket }

class DocketController extends GetxController {
  DashBoardController ctrl = Get.find<DashBoardController>();
  String docketNumbers = Get.arguments ?? '';
  MethodChannel channel = MethodChannel("tms.com/method");
  Rx<DataStatus> dataStatus = DataStatus.loading.obs;
  List<String> prnList = [];
  // FlutterBlue flutterBlue = FlutterBlue.instance;

  ///DocketDetail List
  RxList<DocketInfo> docketData = <DocketInfo>[].obs;

  @override
  void onInit() {
    getDocketData(docketNumbers: docketNumbers);
    update();
    super.onInit();
  }

  Future<bool> checkBluetoothStatus(BuildContext context) async {
    // bool isOn = await flutterBlue.isOn;
    return true;
  }

  Future<void> showBluetoothDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            'Bluetooth turned off',
            style: TextStyle(),
          ),
          content: Text('Please enable Bluetooth to use this app.'),
          actions: <Widget>[
            TmsButton(text: "OK", onPressed: (){
              Get.back();
            })
          ],
        );
      },
    );
  }

  /// list Store Docket Api data method

  Future<void> getDocketData({required String docketNumbers}) async {
    try {
      DocketDetail? docketDetail =
          await ctrl.docketApi(docketNumbers: docketNumbers);
      if (docketDetail!.data.isNotEmpty) {
        docketData(docketDetail.data);

        dataStatus(DataStatus.completed);
      } else {
        dataStatus(DataStatus.error);
      }
    } catch (err) {
      dataStatus(DataStatus.error);
    }
  }

  String getPrintData(argumentData, subIndex) {
    String pkgNo = "";
    if (subIndex.toString().length == 1) {
      pkgNo = "00" "${subIndex + 1}";
    } else if (subIndex.toString().length == 2) {
      pkgNo = "0" "${subIndex + 1}";
    } else if (subIndex.toString().length == 3) {
      pkgNo = "${subIndex + 1}";
    }

    return "SIZE 72.00 125.13 mm\n"
            "GAP 3 mm, 0 mm\n"
            "DIRECTION 0,0\n"
            "REFERENCE 0,0\n"
            "OFFSET 0 mm\n"
            "SET PEEL OFF\n" +
        "SET CUTTER OFF\n" +
        "SET PARTIAL_CUTTER OFF\n" +
        "SET TEAR ON\n" +
        "CLS\n" +

        //QrCode

        "QRCODE 325,51,L,9,A,90,M2,S7,\"" +
        "${argumentData.dockno}" +
        "\"\n" +
        "TEXT 106,450,\"2\",90,1,1,\"" +
        "\"\n" +
        "BAR 41,345, 3, 425\n" +
        "BAR  ${argumentData.csgnnm != "" ? '385' : '285'},344, 3, 428\n" +
        "BAR  ${argumentData.csgnnm != "" ? '315' : '215'},344, 3, 428\n" +
        "${argumentData.csgnnm != "" ? 'BAR 245,344, 3, 428\n' : ''}" +
        "${argumentData.csgenm != "" ? 'BAR 165,344, 3, 428\n' : ''}" +
        "BAR 0,290, 355, 3\n" +
        "CODEPAGE 1252\n" +
        "TEXT ${argumentData.csgnnm != "" ? '450' : '350'},344,\"2\",90,1,1,\"Origin\"\n" +
        "TEXT  ${argumentData.csgnnm != "" ? '420' : '320'},344,\"2\",90,1,1,\"" +
        '${argumentData.orgncd}' +
        "\"\n" +
        "TEXT  ${argumentData.csgnnm != "" ? '375' : '277'},344,\"2\",90,1,1,\"Destination\"\n" +
        "TEXT  ${argumentData.csgnnm != "" ? '345' : '247'},344,\"2\",90,1,1,\"" +
        '${argumentData.reassigNDestcd}' +
        "\"\n" +
        "${argumentData.csgnnm != "" ? 'TEXT 305,344,\"2\",90,1,1,\"Consignor\"\nTEXT 275,344,\"2\",90,1,1,\"${argumentData.csgnnm}\"\n' : ''}" +
        "${argumentData.csgenm != "" ? 'TEXT 232,344,\"2\",90,1,1,\"Consignee\"\nTEXT 200,344,\"2\",90,1,1,\"${argumentData.csgenm}\"\n' : ''}" +
        "TEXT 148,344,\"2\",90,1,1,\"No. of Packages\"\n" +
        "TEXT 120,400,\"2\",90,1,2,\"${argumentData.pkgsno.toInt()}\"\n" +

        // docket no. and date
        "TEXT 520,35,\"2\",90,2,2,\"" +
        '${argumentData.dockno}' +
        "\"\n" + //120   set maximum 12 digits
        "TEXT 400,51,\"2\",90,1,1,\"" +
        '${argumentData.dockdt}' +
        "\"\n" + //66

        "PRINT 1,1\n";
  }

  String shortenString(String input, int maxLength) {
    if (input.length <= maxLength) {
      return input;
    } else {
      return input.substring(0, maxLength - 2) + "..";
    }
  }

  Future<dynamic> printImageByMethodChannel(
      {required Map<String, dynamic> arg}) async {
    await channel.invokeListMethod("launchZebra", arg).then((value) =>
        print(" heloooooooo" + value!.toList().toString() + " heloooooooo"));
  }

  location(String city) {
    if (ctrl.location.isNotEmpty) {
      List<LocationList> locationList = ctrl.location;
      LocationList selectedValue = locationList
          .where((innerValue) => innerValue.locCode.contains(city))
          .first;

      String cityFullName = selectedValue.locName;

      return cityFullName;
    } else {
      return city;
    }
  }
}
