// ignore_for_file: must_be_immutable

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';
import '../../widgets/app_size.dart';
import '../../widgets/dashboard_widgets/custom_drawer.dart';
import '../../widgets/manifest_widgets/custom_alertdialog.dart';
import '../../widgets/tms_button.dart';
import '../../widgets/tms_normaltext.dart';

import '../../utils/pref.dart';
import '../../widgets/custom_dropdown_search.dart';
import '../../widgets/tost.dart';
import 'manifest_controller.dart';

class HarshManifestScreen extends GetView {
  HarshManifestScreen({Key? key}) : super(key: key);
  var HarshMfCtrl = Get.find<HarshManifestController>();
  TextEditingController manifestScanController = TextEditingController();
  var scaffoldKeyM = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        HarshMfCtrl.checkValidSerialNoDataList.clear();
        Get.back();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKeyM,
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  HarshMfCtrl.checkValidSerialNoDataList.clear();
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
                  String? baseLocation = Pref().getBaseLocation();
                  if (baseLocation.isEmpty ||
                      HarshMfCtrl.toLocation.value.isEmpty ||
                      HarshMfCtrl.toLocation.value.isNull ||
                      HarshMfCtrl.toLocation.value == 'null') {
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: AppSize.size(context).height * 0.25,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 35,
                              ),
                              child: Image(
                                image: AssetImage(
                                    'assets/images/dashboardimages/fromTo.png'),
                                height: AppSize.size(context).height * 0.145,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 10, bottom: 10),
                                    child: TmsText(
                                      text: 'From',
                                      fontSize: 14,
                                      color: Color(0xff646D72),
                                    ),
                                  ),
                                  if (Pref().getBranchCode() == 'HQTR')
                                    Obx(
                                      () => Flexible(
                                        child: Container(
                                            height:
                                                AppSize.size(context).height *
                                                    0.07,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color(0xFFE9ECEF),
                                            ),
                                            child: Dropdown(
                                              enabled: true.obs,
                                              isSize: true,
                                              text: Pref()
                                                      .getBaseLocation()
                                                      .isEmpty
                                                  ? '  Select Location '.obs
                                                  : '  ${Pref().getBaseLocation()}'
                                                      .obs,
                                              list: ctrl.location
                                                  .map((element) =>
                                                      element.locName)
                                                  .toList(),
                                              onChanged: (value) async =>
                                                  await ctrl
                                                      .getLocationCode(value!),
                                            )),
                                      ),
                                    )
                                  else
                                    Flexible(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height:
                                            AppSize.size(context).height * 0.07,
                                        // width: AppSize.size(context).width * 0.75,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xFFE9ECEF),
                                        ),
                                        child: DropdownSearch(
                                          selectedItem: Pref().getBranchCode(),
                                          enabled: false,
                                          items: [Pref().getBranchCode()],
                                          dropdownDecoratorProps:
                                              DropDownDecoratorProps(
                                            dropdownSearchDecoration:
                                                InputDecoration(
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, top: 10, bottom: 10),
                                    child: TmsText(
                                      text: 'To',
                                      fontSize: 14,
                                      color: Color(0xff646D72),
                                    ),
                                  ),
                                  Obx(
                                    () => Flexible(
                                      child: Container(
                                        alignment: Alignment.center,
                                        height:
                                            AppSize.size(context).height * 0.07,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: const Color(0xFFE9ECEF),
                                        ),
                                        child: Dropdown(
                                          enabled: true.obs,
                                          isSize: true,
                                          text: Pref().getNextLocation().isEmpty
                                              ? '  Select To Location '.obs
                                              : '  ${Pref().getNextLocation()}'
                                                  .obs,
                                          list: ctrl.location
                                              .map((element) => element.locName)
                                              .toList(),
                                          onChanged: (value) async {
                                            // await ctrl.saveNextLocation(value!);
                                            HarshMfCtrl.hideTextFocus
                                                .requestFocus();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
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
                      Obx(() => HarshMfCtrl
                              .checkValidSerialNoDataList.isNotEmpty
                          ? Flexible(
                              flex: 8,
                              child: ListView.builder(
                                itemCount: HarshMfCtrl
                                    .checkValidSerialNoDataList.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  String lasn = HarshMfCtrl.lastScanNo(index);
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.withOpacity(0.5),
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
                                                  text: HarshMfCtrl
                                                      .checkValidSerialNoDataList[
                                                          index]
                                                      .dockno!,
                                                  fontSize: 15,
                                                ),
                                                TmsManifestView(
                                                    color: Color(0xff646D72),
                                                    text:
                                                        "${HarshMfCtrl.checkValidSerialNoDataList[index].docketDate}",
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
                                                        '${HarshMfCtrl.countScan(index)}/${HarshMfCtrl.checkValidSerialNoDataList[index].bcserials!.length}',
                                                    image:
                                                        'assets/images/dashboardimages/Product.png',
                                                    height: 25),
                                                Column(
                                                  children: [
                                                    TmsText(
                                                      text: "LastScanned",
                                                      fontSize: 12,
                                                      color: Color(0xff646D72),
                                                    ),
                                                    TmsText(
                                                      text: lasn.substring(
                                                          HarshMfCtrl.lastScanNo(
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
                Obx(() => HarshMfCtrl.checkValidSerialNoDataList.isNotEmpty
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
                                              HarshMfCtrl.docketManifestAdd();
                                              HarshMfCtrl
                                                  .prepareManifestSubmit();
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
