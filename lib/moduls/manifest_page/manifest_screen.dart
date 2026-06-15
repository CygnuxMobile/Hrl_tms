// ignore_for_file: must_be_immutable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';
import '../../moduls/manifest_page/sub_widget/manifest_scan_dialog.dart';
import '../../widgets/app_size.dart';
import '../../widgets/dashboard_widgets/custom_drawer.dart';
import '../../widgets/manifest_widgets/custom_alertdialog.dart';
import '../../widgets/tms_button.dart';
import '../../widgets/tms_normaltext.dart';

import '../../utils/pref.dart';
import '../../widgets/custom_dropdown_search.dart';
import '../../widgets/tost.dart';
import 'manifest_controller.dart';

class ManifestScreen extends StatefulWidget {
  ManifestScreen({Key? key}) : super(key: key);

  @override
  State<ManifestScreen> createState() => _ManifestScreenState();
}

class _ManifestScreenState extends State<ManifestScreen> {
  var mfCtrl = Get.find<ManifestController>();

  TextEditingController manifestScanController = TextEditingController();

  var scaffoldKeyM = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        mfCtrl.checkValidSerialNoDataList.clear();
        Get.back();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKeyM,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  mfCtrl.checkValidSerialNoDataList.clear();
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                )),
            backgroundColor: Color(0xff232F34),
            centerTitle: true,
            title: TmsText(
              text: 'Manifest',
              fontSize: 18,
              color: Colors.white,
            ),
            actions: [
              InkWell(
                onTap: () async {
                  if (Pref().getBaseLocation().isEmpty || Pref().getNextLocation().isEmpty) {
                    mflocAlertDialog(
                        context: context,
                        title: 'Warning',
                        description: 'Please Select Location',
                        onTap: () {
                          Get.back();
                        },
                        onTapText: 'OK');
                  } else {
                    Get.toNamed(AppRoutes.qRScanScreen);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.document_scanner_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            TmsText(
                              text: 'From',
                              fontSize: 14,
                              color: Color(0xff646D72),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (Pref().getBranchCode() == 'HQTR')
                              Obx(
                                () => Dropdown(
                                    height: 25.0.obs,
                                    image:
                                        "assets/images/dashboardimages/To.png"
                                            .obs,
                                    enabled: true.obs,
                                    isSize: false,
                                    text: Pref().getBaseLocation().isEmpty
                                        ? '  Select Location '.obs
                                        : '  ${Pref().getBaseLocation()}'.obs,
                                    list: ctrl.location
                                        .map((element) =>
                                            '${element.locCode} - ${element.locName}')
                                        .toList(),
                                    onChanged: (value) async {
                                      await ctrl.getLocationCode(value!);
                                    }),
                              )
                            else
                              Flexible(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: AppSize.size(context).height * 0.07,
                                  // width: AppSize.size(context).width * 0.75,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFE9ECEF),
                                  ),
                                  child: DropdownSearch(
                                    selectedItem: Pref().getBranchCode(),
                                    enabled: false,
                                    items: [Pref().getBranchCode()],
                                    dropdownDecoratorProps:
                                        DropDownDecoratorProps(
                                      dropdownSearchDecoration: InputDecoration(
                                        prefix: const Icon(
                                          Icons.location_on_outlined,
                                          color: Color(0xFF023E8A),
                                          size: 25,
                                        ),
                                        border: InputBorder.none,
                                        hintText: Pref().getBranchCode(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 5,
                            ),
                            TmsText(
                              text: 'To',
                              fontSize: 14,
                              color: Color(0xff646D72),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(
                              () => Dropdown(
                                height: 25.0.obs,
                                image:
                                    "assets/images/dashboardimages/Form.png".obs,
                                enabled: true.obs,
                                isSize: false,
                                text: Pref().getNextLocation().isEmpty
                                    ? '  Select To Location '.obs
                                    : '  ${Pref().getNextLocation()}'.obs,
                                list: ctrl.location
                                    .map((element) =>
                                        '${element.locCode} - ${element.locName}')
                                    .toList(),
                                onChanged: (value) async {
                                  await Pref().saveNextLocation(
                                      val: mfCtrl.LocationName(value));
                                  print('=====${Pref().getNextLocation()}');
                                  mfCtrl.hideTextFocus.requestFocus();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Pref().getHstMode()
                          ? Row(
                              children: [
                                SizedBox(
                                  height: AppSize.size(context).height * 0.04,
                                  width: AppSize.size(context).width / 1.3,
                                  child: TextField(
                                    controller: manifestScanController,
                                    style: const TextStyle(color: Colors.black),
                                    cursorColor: Colors.transparent,
                                    decoration: const InputDecoration(
                                      labelText: 'Thc No',
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      // if (manifestScanController.text.length >
                                      //     11) {
                                      //   mfCtrl.checkScanResult(context,
                                      //       manifestScanController.text, null);
                                      // }
                                    },
                                  ),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    manifestScanController.clear();
                                  },
                                  child: const Icon(Icons.clear),
                                )
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(() => mfCtrl.checkValidSerialNoDataList.isNotEmpty
                          ? Flexible(
                              flex: 8,
                              child: ListView.builder(
                                itemCount:
                                    mfCtrl.checkValidSerialNoDataList.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  String lastScan = mfCtrl.lastScanNo(index);
                                  return GestureDetector(
                                    onTap: () {
                                      ManifestScanDialog(
                                          context,
                                          mfCtrl
                                              .checkValidSerialNoDataList[index]
                                              .bcserials);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              width: 1),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TmsText(
                                                    text: mfCtrl
                                                        .checkValidSerialNoDataList[
                                                            index]
                                                        .dockno!,
                                                    fontSize: 15,
                                                  ),
                                                  TmsManifestView(
                                                      color: Color(0xff646D72),
                                                      text:
                                                          "${mfCtrl.checkValidSerialNoDataList[index].docketDate}",
                                                      image:
                                                          'assets/images/dashboardimages/Calendar.png',
                                                      height: 25),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  TmsManifestView(
                                                      color: Color(0xff646D72),
                                                      text:
                                                          '${mfCtrl.countScan(index)}/${mfCtrl.checkValidSerialNoDataList[index].bcserials!.length}',
                                                      image:
                                                          'assets/images/dashboardimages/Product.png',
                                                      height: 25),
                                                  Column(
                                                    children: [
                                                      TmsText(
                                                        text: "LastScanned",
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xff646D72),
                                                      ),
                                                      TmsText(
                                                        text: lastScan
                                                            .substring(mfCtrl
                                                                    .lastScanNo(
                                                                        index)
                                                                    .toString()
                                                                    .length -
                                                                3),
                                                        fontSize: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: TmsText(
                                      text: 'Please Scan Qr Code. ',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                    ],
                  ),
                ),
                Obx(() => mfCtrl.checkValidSerialNoDataList.isNotEmpty
                    ? Align(
                        alignment: Alignment.bottomRight,
                        child: TmsButton(
                          text: 'Submit',
                          onPressed: () {
                            print('------${Pref().getNextLocation()}');
                            print('------${Pref().getBaseLocation()}');
                            Pref().getBaseLocation().isNotEmpty
                                ? Pref().getNextLocation().isNotEmpty
                                    ? Pref().getNextLocation() !=
                                            Pref().getBaseLocation()
                                        ? mfAlertDialog(
                                            context: context,
                                            title: 'Create Manifest',
                                            description:
                                                'Are you sure, do you want to Create Manifest ?',
                                            cancelOnTap: () {
                                              Get.back();
                                            },
                                            onTap: () async {
                                              mfCtrl.docketManifestAdd();
                                              mfCtrl.prepareManifestSubmit();
                                              // await Pref().removeBaseLocation();
                                            },
                                            onTapText: 'Create',
                                          )
                                        : TmsToast.msg('Both Location Same')
                                    : TmsToast.msg('Select Next Location')
                                : TmsToast.msg('Select Base Location');
                          },
                          size: const Size(double.infinity, 40),
                        ),
                      )
                    : const SizedBox())
              ],
            ),
          ),
        ),
      ),
    );
  }

  TmsManifestView(
      {required String text,
      required String image,
      required double height,
      required Color color}) {
    return Row(
      children: [
        Image(
          image: AssetImage(image),
          height: height,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TmsText(
            text: text,
            color: color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
