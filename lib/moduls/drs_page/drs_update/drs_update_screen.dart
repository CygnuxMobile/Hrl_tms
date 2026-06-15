import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../moduls/drs_page/drs_controller.dart';
import '../../../widgets/app_size.dart';
import '../../../widgets/tms_normaltext.dart';
import '../../../widgets/tms_richtext.dart';
import '../../../utils/tms_color.dart';
import '../../../widgets/custom_dropdown_search.dart';
import '../../../widgets/tms_button.dart';
import '../../home_page/dash_board_controller.dart';

class DrsUpdateScreen extends StatelessWidget {
  DrsUpdateScreen({super.key});

  DRSController drsController = Get.put(DRSController());
  DashBoardController ctrl = Get.find<DashBoardController>();

  SizedBox _sizeBox() => const SizedBox(
        height: 12,
      );

  SizedBox sizeBox() => const SizedBox(
        height: 06,
      );

  int index = Get.arguments;
  GlobalKey<FormState> deliveredPkgsFromKey = GlobalKey<FormState>();
  GlobalKey<FormState> addRemarksFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> reason = GlobalKey<FormState>();
  GlobalKey<FormState> qtyReason = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.black.withOpacity(0.3),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
              color: AppColor.white,
            ),
          ),
          title: const Text(
            'Drs Update',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xff232F34),
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.5), width: 1),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              sizeBox(),
                              TmsRichText(
                                text: "DRS No : ",
                                richText: drsController.drsDetailData.pdcno,
                                color: Color(0xff232F34),
                                color1: AppColor.black45,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                fontSize1: 14,
                              ),
                              sizeBox(),
                              TmsImageTextView(
                                text: drsController.drsDetailList[index].dockno,
                                image:
                                    "assets/images/dashboardimages/Docket.png",
                                height: 25,
                                color: Color(0xff4CAF50),
                                fontWeight: FontWeight.w500,
                              ),
                              sizeBox(),
                              TmsRichText(
                                text: "Delivered packages :",
                                richText:
                                    " ${drsController.drsDetailList[index].pkgsBooked}",
                                color: Color(0xff232F34),
                                color1: AppColor.black45,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                                fontSize1: 14,
                              ),
                              Row(
                                children: [
                                  TmsImageTextView(
                                    text:
                                        "${drsController.drsDetailList[index].pkgsArrived}",
                                    image:
                                        "assets/images/dashboardimages/image 16 (1).png",
                                    height: 25,
                                    color: Color(0xff646D72),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Spacer(),
                                  TmsImageTextView(
                                    text:
                                        "${drsController.drsDetailList[index].pkgsPending}",
                                    image:
                                        "assets/images/dashboardimages/image 15.png",
                                    height: 25,
                                    color: Color(0xff646D72),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                    _sizeBox(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      padding: const EdgeInsets.only(left: 12),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Image(
                              image: AssetImage(
                                  'assets/images/dashboardimages/delivered.png'),
                              height: 25),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Form(
                                key: deliveredPkgsFromKey,
                                child: TextFormField(
                                  controller:
                                      drsController.deliveredPkgsController,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    labelText: 'Enter delivered package ',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (newValue) {
                                    drsController.deliveredPkgsValidation(
                                        newValue, index);
                                  },
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter delivered pkgs number';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _sizeBox(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      padding: const EdgeInsets.only(left: 12),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Image(
                              image: AssetImage(
                                  'assets/images/dashboardimages/remark.png'),
                              height: 25),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Form(
                                key: addRemarksFormKey,
                                child: TextFormField(
                                  controller: drsController.drsRemarkController,
                                  decoration: const InputDecoration(
                                    labelText: 'Enter Remark',
                                    labelStyle: TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter remark';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _sizeBox(),
                    const TmsText(
                        text: '* Reason',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Color(0xff646D72)),
                    sizeBox(),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Form(
                          key: reason,
                          child: Dropdown(
                            list: drsController.remarkList
                                .map((data) => data.codeDesc)
                                .toList(),
                            onChanged: (value) {
                              drsController.reason = value.toString();
                            },
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Please select reason';
                              }
                              return null;
                            },
                            text: " Select Reason ".obs,
                            isSize: true,
                            enabled: true.obs,
                          ),
                        ),
                      ),
                    ),
                    _sizeBox(),
                    drsController.isShow.isTrue
                        ? const TmsText(
                            text: '* Drs undelivered reason ',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xff646D72))
                        : SizedBox(),
                    sizeBox(),
                    drsController.isShow.isTrue
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: qtyReason,
                              child: Dropdown(
                                list: drsController.qtyMissRemarkList
                                    .map((data) => data.codeDesc)
                                    .toList(),
                                onChanged: (value) {
                                  drsController.qtyReason = value.toString();
                                },
                                text: "  Select Reason ".obs,
                                validator: (value) {
                                  if (value == null || value == '') {
                                    return 'Please Select Reason ';
                                  }
                                  return null;
                                },
                                isSize: true,
                                enabled: true.obs,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    const Spacer(),
                    TmsButton(
                      text: 'Submit',
                      size: Size(
                          double.infinity, AppSize.size(context).height * 0.06),
                      onPressed: () {
                        if (drsController.isShow.isTrue) {
                          if (deliveredPkgsFromKey.currentState!.validate() &&
                              addRemarksFormKey.currentState!.validate() &&
                              reason.currentState!.validate() &&
                              qtyReason.currentState!.validate()) {
                            drsController.drsSubmitApi(
                              context: context,
                              index: index,
                            );
                          }
                        } else {
                          if (deliveredPkgsFromKey.currentState!.validate() &&
                              addRemarksFormKey.currentState!.validate() &&
                              reason.currentState!.validate()) {
                            drsController.drsSubmitApi(
                              context: context,
                              index: index,
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
