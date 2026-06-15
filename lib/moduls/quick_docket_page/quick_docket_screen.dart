import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import '../../moduls/docket_page/docket_controller.dart';
import '../../moduls/quick_docket_page/quick_docket_controller.dart';
import '../../utils/tms_color.dart';
import '../../widgets/custom_dropdown_search.dart';
import '../../widgets/tms_normaltext.dart';
import '../../widgets/tost.dart';
import 'package:intl/intl.dart';
import '../../model/quick_docket_model/quick_docket_submit_models/quick_docket_request.dart';
import '../../utils/pref.dart';
import '../../widgets/app_size.dart';
import '../../widgets/dashboard_widgets/custom_drawer.dart';
import '../../widgets/tms_button.dart';

enum eWayBill { none, withEWayBill, withoutEWayBill }

class QuickDocketScreen extends StatefulWidget {
  const QuickDocketScreen({super.key});

  @override
  State<QuickDocketScreen> createState() => _QuickDocketScreenState();
}

class _QuickDocketScreenState extends State<QuickDocketScreen> {
  final SizedBox _sizedBox = const SizedBox(height: 8);

  final SizedBox _sizedBox12 = const SizedBox(height: 12);

  late QuickDocketController quickDocketController;

  @override
  void initState() {
    super.initState();
    quickDocketController = Get.put(QuickDocketController());
  }

  Future<void> imagesFromGallery() async {
    try {
      Get.back();
      if (quickDocketController.selectedImages.length >= 1) {
        TmsToast.msg("You can only select 1 image.");
        return;
      }

      final List<XFile>? selectedFiles = await ImagePicker().pickMultiImage();
      if (selectedFiles != null) {
        final remainingSlots = 3 - quickDocketController.selectedImages.length;
        final filesToAdd = selectedFiles.take(remainingSlots).toList();

        setState(() {
          quickDocketController.selectedImages.addAll(filesToAdd);
        });
        await processAndConvertImages(filesToAdd);
      }
    } catch (e) {
      print("Error picking images from gallery: $e");
    }
  }

  Future<void> imageFromCamera() async {
    try {
      Get.back();
      if (quickDocketController.selectedImages.length >= 1) {
        TmsToast.msg("You can only select 1 image.");
        return;
      }

      final XFile? capturedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (capturedFile != null) {
        setState(() {
          quickDocketController.selectedImages.add(capturedFile);
        });
        await processAndConvertImages([capturedFile]);
      }
    } catch (e) {
      print("Error capturing image from camera: $e");
    }
  }

  Future<void> processAndConvertImages(List<XFile> files) async {
    for (XFile file in files) {
      try {
        final File imageFile = File(file.path);

        final compressedImageFile = await compressImage(imageFile, maxSizeInBytes: 1024 * 1024);

        final bytes = await compressedImageFile.readAsBytes();
        final base64String = base64Encode(bytes);

        setState(() {
          quickDocketController.base64Images.add(base64String);
        });
      } catch (e) {
        print("Error processing image: $e");
      }
    }
  }

  Future<File> compressImage(File file, {required int maxSizeInBytes}) async {
    final imageBytes = await file.readAsBytes();
    final decodedImage = img.decodeImage(imageBytes)!;

    int quality = 90;
    int resizeFactor = 100;

    File compressedFile = file;

    while (true) {
      final resizedImage = img.copyResize(decodedImage, width: (decodedImage.width * resizeFactor ~/ 100));
      final compressedBytes = img.encodeJpg(resizedImage, quality: quality);

      if (compressedBytes.length <= maxSizeInBytes || quality <= 50) {
        compressedFile = File('${file.path}_compressed.jpg')..writeAsBytesSync(compressedBytes);
        break;
      }

      quality -= 10;
      resizeFactor -= 10;
    }

    return compressedFile;
  }

  Future<void> showPickerDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose an option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Camera'),
              onTap: () => imageFromCamera(),
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('Gallery'),
              onTap: () => imagesFromGallery(),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageView() {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      crossAxisSpacing: 25,
      mainAxisSpacing: 25,
      children: List.generate(
        quickDocketController.selectedImages.length,
        (index) {
          return Obx(() {
            if (quickDocketController.selectedImages.isNotEmpty) {
              return Stack(
                children: [
                  Container(
                    height: AppSize.size(context).height * 0.15,
                    width: AppSize.size(context).width * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      // Ensures the image respects the container's borderRadius
                      child: Image.file(
                        File(quickDocketController.selectedImages[index].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: -12,
                    right: -12,
                    child: IconButton(
                      iconSize: 20,
                      onPressed: () {
                        setState(() {
                          quickDocketController.selectedImages.removeAt(index);
                        });
                      },
                      icon: const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox();
            }
          });
        },
      ),
    );
  }

  final GlobalKey<FormState> numberPkgFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> declaredValueFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> actualWeightFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> chargeWeightFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> valueMetricFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> eWayBillWeightFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> docketDateFromKey = GlobalKey<FormState>();

  final GlobalKey<FormState> transportModelFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> toCityFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> fromCityFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> pinCodeFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> billingPartyFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> billingTypeFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> invoiceNoFromKey = GlobalKey<FormState>();
  final GlobalKey<FormState> docketNoFromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayColor: Colors.black.withOpacity(0.3),
      child: WillPopScope(
        onWillPop: () async {
          quickDocketController.ctrlClear();
          quickDocketController.pinCode.value = "Select Pincode";
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const TmsText(
              text: 'Quick Docket',
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
            backgroundColor: const Color(0xff232F34),
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                  quickDocketController.pinCode.value = "Select Pincode";
                  quickDocketController.ctrlClear();
                  quickDocketController.transportMode.value = false;
                },
                icon: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                )),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 4,
                      ),
                      // Form(
                      //   key: docketNoFromKey,
                      //   child: TextFormField(
                      //     focusNode: quickDocketController.docketFocus,
                      //     controller: quickDocketController.docketNoController,
                      //     style: TextStyle(
                      //         color: Colors.black, fontWeight: FontWeight.bold),
                      //     decoration: InputDecoration(
                      //       labelText: 'Docket No',
                      //       labelStyle: TextStyle(
                      //           color: Colors.black,
                      //           fontWeight: FontWeight.bold),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(15),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderSide: BorderSide(
                      //           color: Color(0xff232F34),
                      //         ),
                      //         borderRadius: BorderRadius.circular(15),
                      //       ),
                      //       contentPadding: EdgeInsets.symmetric(
                      //           vertical: 15, horizontal: 10),
                      //     ),
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return 'Please enter Docket No';
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      // _sizedBox12,
                      Obx(() {
                        switch (quickDocketController.payBaseDataStatus.value) {
                          case DataStatus.completed:
                            return InkWell(
                                onTap: () {
                                  quickDocketController.textFocus();
                                },
                                child: QuickDocketDropdown(
                                  height: 30.0.obs,
                                  enabled: true.obs,
                                  isSize: false,
                                  text: 'Select Paybase Type '.obs,
                                  label: "Paybase Type",
                                  list: quickDocketController.payBasList.map((e) => e.codeDesc).toList(),
                                  onChanged: (value) {
                                    quickDocketController.textFocus();
                                    quickDocketController.billingSelectType(value!);
                                    for (var data in quickDocketController.payBasList) {
                                      if (data.codeDesc == value) {
                                        quickDocketController.consignorId = data.codeAccess;
                                      }
                                    }
                                    quickDocketController.custListApi(context: context);
                                  },
                                  globalKey: billingTypeFromKey,
                                  validator: (value) {
                                    if (value == null || value == '') {
                                      return 'Please Select Paybase Type';
                                    }
                                    return null;
                                  },
                                ));

                          case DataStatus.error:
                            return Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Icon(Icons.error, color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                Text('Failed to load data. Please try again.'),
                                ElevatedButton(
                                  onPressed: () {
                                    quickDocketController.billingTypeApi();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff232F34),
                                  ),
                                  child: Text(
                                    'Retry',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );

                          case DataStatus.loading:
                            return Center(
                              child: CircularProgressIndicator(),
                            );

                          default:
                            return SizedBox();
                        }
                      }),
                      _sizedBox12,
                      Obx(
                        () => InkWell(
                          onTap: () {
                            quickDocketController.textFocus();
                            if (quickDocketController.billingType.isEmpty && quickDocketController.originLocation.isEmpty) {
                              TmsToast.msg('Please select Origin Location && Billing Type ');
                            } else if (quickDocketController.billingType.isEmpty) {
                              TmsToast.msg('Please select Billing Type ');
                            } else if (quickDocketController.originLocation.isEmpty) {
                              TmsToast.msg('Please select Origin Location Type ');
                            }
                          },
                          child: QuickDocketDropdown(
                            height: 30.0.obs,
                            enabled: (quickDocketController.customerList.isNotEmpty ? true : false).obs,
                            isSize: false,
                            text: 'Select Billing Party '.obs,
                            label: "Billing Party",
                            list: quickDocketController.customerList.map((element) => element.custnm).toList(),
                            onChanged: (value) {
                              for (var data in quickDocketController.customerList) {
                                if (data.custnm == value) {
                                  quickDocketController.transportModelApi(Custcode: data.custcd, Paybas: quickDocketController.billingType.value);

                                  // for (var trData in quickDocketController.transportModelList) {
                                  //   // if (!data.transType.contains(',')) {
                                  //   //   if (trData.codeId == data.transType) {
                                  //   //     quickDocketController.selectTransportId.value = trData.codeId;
                                  //   //     quickDocketController.selectTransportModel.value = trData.codeDesc;
                                  //   //     quickDocketController.transportMode.value = false;
                                  //   //   }
                                  //   // } else {
                                  //   //   quickDocketController.transportMode.value = true;
                                  //   // }
                                  // }
                                  quickDocketController.isValueMetrics.value = data.volYn == "Y" ? true : false;
                                }
                              }
                              quickDocketController.consignorName.value = value!;
                              quickDocketController.textFocus();
                              quickDocketController.consignorSelectName(value);
                            },
                            globalKey: billingPartyFromKey,
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Please Select Billing Party ';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      _sizedBox12,
                      Obx(
                        () => InkWell(
                          onTap: () {
                            quickDocketController.textFocus();
                          },
                          child: QuickDocketDropdown(
                            enabled: quickDocketController.transportMode,
                            height: 30.0.obs,
                            isSize: false,
                            text: quickDocketController.selectTransportModel,
                            label: "Transport Mode",
                            list: quickDocketController.transportMode.isTrue
                                ? quickDocketController.transportModelList.map((element) => element.codeDesc).toList()
                                : [quickDocketController.selectTransportModel.value],
                            onChanged: (value) async {
                              quickDocketController.selectTransportModel.value = value!;
                              quickDocketController.textFocus();
                              for (var data
                                  in quickDocketController.transportModelList) {
                                if (data.codeDesc == value) {
                                  quickDocketController
                                      .selectTransportId.value = data.codeId;
                                }
                              }
                            },
                            globalKey: transportModelFromKey,
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Please Select Transport Model ';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      // _sizedBox12,
                      // destinationDropdown(context),
                      _sizedBox12,
                      FromCityDropdown(context),
                      _sizedBox12,
                      QuickDocketDropdown(
                        image: 'assets/images/dashboardimages/Form.png'.obs,
                        height: 30.0.obs,
                        enabled: true.obs,
                        isSize: false,
                        text: 'Select To City '.obs,
                        label: "To City",
                        list: quickDocketController.cityList.map((element) => '${element.location}').toList(),
                        onChanged: (value) {
                          quickDocketController.toCityController.text = value!;
                        },
                        globalKey: toCityFromKey,
                        validator: (value) {
                          if (value == null || value == '') {
                            return 'Please Select To City';
                          }
                          return null;
                        },
                      ),
                      _sizedBox12,
                      Form(
                        key: docketDateFromKey,
                        child: TextFormField(
                          enabled:  quickDocketController.docketDate.value,
                          controller: quickDocketController.docketDateController,
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.date_range),
                            labelText: 'Docket Date',
                            labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xff232F34),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onTap: () async {
                            DateTime? date = DateTime.now();
                            FocusScope.of(context).requestFocus(FocusNode());
                            date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now().subtract(Duration(days: 1)), lastDate:DateTime.now().add(Duration(days: 365)));
                            String toDate = DateFormat('dd MMM yyyy').format(date!);
                            quickDocketController.docketDateController.text = toDate;
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TmsText(
                              text: "Fulfillment Details",
                              color: AppColor.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          // Spacer(),
                          // IconButton(
                          //   onPressed: () {
                          //     _showQrScannerDialog(context); // Open QR code scanner
                          //   },
                          //   icon: Icon(
                          //     Icons.document_scanner_outlined,
                          //     color: const Color(0xff232F34),
                          //   ),
                          // ),
                        ],
                      ),
                      Obx(
                        () => ListView.builder(
                          itemCount: quickDocketController.docketInvoiceList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final invoice = quickDocketController.docketInvoiceList[index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      TmsText(
                                        text: invoice.invno,
                                        fontWeight: FontWeight.bold,
                                        maxLines: 1,
                                      ),
                                      // Declaration Value
                                      Expanded(
                                        child: TmsText(
                                          text: "${invoice.decval}",
                                          maxLines: 1,
                                        ),
                                      ),
                                      // Delete Icon
                                      IconButton(
                                        icon: Icon(CupertinoIcons.delete),
                                        color: Colors.red,
                                        onPressed: () {
                                          quickDocketController.docketInvoiceList.removeAt(index);
                                        },
                                        splashRadius: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      if (quickDocketController.eWayBillStatus.value == eWayBill.withEWayBill) ...{
                        SizedBox(
                          height: 20,
                        ),
                        Obx(() {
                          return Form(
                            key: eWayBillWeightFromKey,
                            child: TextFormField(
                              focusNode: quickDocketController.eWayBillNo,
                              controller: quickDocketController.eWayBillNoController,
                              enabled: quickDocketController.isEWayNumber.value,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                labelText: 'EWB Number',
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xff232F34)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the EWB number';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                quickDocketController.isEWBEmpty.value = value.trim().isEmpty;
                                bool isEmpty = value.trim().isEmpty;

                                quickDocketController.isDeclared.value = isEmpty;
                                quickDocketController.isInvoice.value = isEmpty;
                                quickDocketController.isNumberOfPkg.value = isEmpty;
                                quickDocketController.isActualWeight.value = isEmpty;
                                quickDocketController.isHeight.value = isEmpty;
                                quickDocketController.isBreadth.value = isEmpty;
                                quickDocketController.isLength.value = isEmpty;
                              },
                            ),
                          );
                        }),
                      },
                      _sizedBox,
                      Obx(() {
                        return Form(
                          key: invoiceNoFromKey,
                          child: TextFormField(
                            focusNode: quickDocketController.invoiceNumber,
                            enabled: quickDocketController.isInvoice.value,
                            controller: quickDocketController.invoiceNoController,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              labelText: 'invoice No',
                              labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                              hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff232F34),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value == '') {
                                return 'Please enter invoice No';
                              }
                              return null;
                            },
                          ),
                        );
                      }),
                      _sizedBox12,
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: numberPkgFromKey,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: TextFormField(
                                  controller: quickDocketController.noOfPackageController,
                                  focusNode: quickDocketController.noOfPackage,
                                  enabled: quickDocketController.isNumberOfPkg.value,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Number of PKG',
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xff232F34)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the number of packages';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Obx(() {
                            return Expanded(
                              child: Form(
                                key: declaredValueFromKey,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: TextFormField(
                                    focusNode: quickDocketController.declaredValue,
                                    enabled: quickDocketController.isDeclared.value,
                                    controller: quickDocketController.declaredValueController,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {}
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Declared Value',
                                      labelStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      hintStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Color(0xff232F34)),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the declared value';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                      _sizedBox12,
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: actualWeightFromKey,
                              child: TextFormField(
                                focusNode: quickDocketController.actualWeight,
                                controller: quickDocketController.actualWeightController,
                                enabled: quickDocketController.isActualWeight.value,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Actual Weight',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff232F34)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the actual weight';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Form(
                              key: chargeWeightFromKey,
                              child: TextFormField(
                                focusNode: quickDocketController.chargeWeight,
                                controller: quickDocketController.chargeWeightController,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Charge Weight',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xff232F34)),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the charge weight';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      _sizedBox12,
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff232F34),
                                minimumSize: Size(double.infinity, AppSize.size(context).height * 0.06),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                showPickerDialog();
                              },
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Obx(() {
                            if (quickDocketController.selectedImages.isNotEmpty) {
                              return Container(
                                height: AppSize.size(context).height * 0.10,
                                child: imageView(),
                              );
                            } else {
                              return SizedBox();
                            }
                          }),
                          TmsButton(
                            text: 'ADD INVOICE',
                            size: Size(double.infinity, AppSize.size(context).height * 0.06),
                            onPressed: () {
                              if (invoiceNoFromKey.currentState!.validate() &&
                                  numberPkgFromKey.currentState!.validate() &&
                                  declaredValueFromKey.currentState!.validate() &&
                                  actualWeightFromKey.currentState!.validate() &&
                                  chargeWeightFromKey.currentState!.validate()) {
                                // if (quickDocketController.selectedImages.isNotEmpty) {
                                  quickDocketController.docketInvoiceList.add(DocketInvoiceList(
                                    invno: quickDocketController.invoiceNoController.text,
                                    prodcd: quickDocketController.selectProduct,
                                    pkgsty: quickDocketController.selectPackage,
                                    pkgs: parseInputToInt(quickDocketController.noOfPackageController.text),
                                    decval: parseInputToDouble(quickDocketController.declaredValueController.text),
                                    actuwt: parseInputToDouble(quickDocketController.actualWeightController.text),
                                    chrgwt: parseInputToDouble(quickDocketController.chargeWeightController.text),
                                    ewbno: quickDocketController.eWayBillNoController.text,
                                    voLL: 0.0,
                                    voLB: 0.0,
                                    voLH: 0.0,
                                    eWayBillExpiredDate: quickDocketController.eWayBillExpiredDate,
                                    eWayBillInvoiceDate: quickDocketController.eWayBillInvoiceDate,
                                    image: quickDocketController.base64Images.isNotEmpty?quickDocketController.base64Images[0]:"",
                                  ));
                                  quickDocketController.isInvoice.value = true;
                                  quickDocketController.isNumberOfPkg.value = true;
                                  quickDocketController.isActualWeight.value = true;
                                  quickDocketController.isHeight.value = false;
                                  quickDocketController.isBreadth.value = false;
                                  quickDocketController.isLength.value = false;
                                  quickDocketController.invoiceNoController.clear();
                                  quickDocketController.noOfPackageController.clear();
                                  quickDocketController.declaredValueController.clear();
                                  quickDocketController.actualWeightController.clear();
                                  quickDocketController.chargeWeightController.clear();
                                  quickDocketController.eWayBillNoController.clear();
                                  quickDocketController.selectedImages.clear();
                                }
                              // else {
                              //     TmsToast.msg("Please select at least one image");
                              //   }
                              // }
                            },
                          ),
                          SizedBox(height: 10),
                          TmsButton(
                            text: 'Submit',
                            size: Size(double.infinity, AppSize.size(context).height * 0.06),
                            onPressed: () {
                              // if (quickDocketController.selectedImages.isNotEmpty) {
                                quickDocketController.submitValidator(
                                  billingTypeFromKey: billingTypeFromKey,
                                  billingPartyFromKey: billingPartyFromKey,
                                  transportModelFromKey:transportModelFromKey,
                                  fromCityFromKey: fromCityFromKey,
                                  toCityFromKey: toCityFromKey,
                                  invoiceNoFromKey: invoiceNoFromKey,
                                  numberPkgFromKey: numberPkgFromKey,
                                  declaredValueFromKey: declaredValueFromKey,
                                  actualWeightFromKey: actualWeightFromKey,
                                  docketDateFromKey: docketDateFromKey,
                                  chargeWeightFromKey: chargeWeightFromKey,
                                );
                              // } else {
                              //   TmsToast.msg("Please select at least one image");
                              // }
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  parseInputToDouble(String input) {
    if (input.isEmpty) {
      return 0.0;
    }
    return double.tryParse(input) ?? 0.0;
  }

  parseInputToInt(String input) {
    if (input.isEmpty) {
      return 0;
    }
    return int.tryParse(input) ?? 0;
  }

  destinationDropdown(BuildContext context) {
    return QuickDocketDropdown(
      image: 'assets/images/dashboardimages/Form.png'.obs,
      height: 30.0.obs,
      enabled: true.obs,
      isSize: false,
      text: 'Select Destination '.obs,
      label: "Destination",
      list: ctrl.location.map((element) => '${element.locCode} - ${element.locName}').toList(),
      onChanged: (value) {
        if (value != null && value.isNotEmpty) {
          final selectedLocCode = ctrl.location
              .firstWhere(
                (element) => '${element.locCode} - ${element.locName}' == value,
              )
              .locCode;
          quickDocketController.destinationController.text = selectedLocCode;
        }
      },
    );
  }

  FromCityDropdown(context) {
    return QuickDocketDropdown(
      height: 30.0.obs,
      enabled: true.obs,
      isSize: false,
      boxDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      text: "Select From City".obs,
      label: "From City",
      list: quickDocketController.CityType.map((element) => element.location).toList(),
      onChanged: (value) {
        quickDocketController.fromCityController.text = value!;
      },
      globalKey: fromCityFromKey,
      validator: (value) {
        if (value == null || value == '') {
          return 'Please Select From City';
        }
        return null;
      },
    );
    // }
  }

  docketNoTextField() {
    return SizedBox(
      height: 58,
      child: TextFormField(
        focusNode: quickDocketController.docketFocus,
        controller: quickDocketController.docketNoController,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          labelText: 'Docket No',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff232F34),
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  InfoText() {
    return Row(
      children: [
        Image(
          image: AssetImage('assets/images/dashboardimages/Info.png'),
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: TmsText(
            textAlign: TextAlign.start,
            text: 'Please enter correct docket no. \nIf you don’t have docket no. system will auto generate it.',
            fontSize: 10,
            color: Color(0xff232F34),
          ),
        ),
      ],
    );
  }

  customInfo({required String text}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image(
            image: AssetImage('assets/images/dashboardimages/Info.png'),
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: TmsText(
              textAlign: TextAlign.start,
              text: text,
              fontSize: 10,
              color: Color(0xff232F34),
            ),
          ),
        ],
      ),
    );
  }

  void _showQrScannerDialog(BuildContext context) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    QRViewController? controller;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Scan QR Code',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff232F34),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: (QRViewController qrController) {
                      controller = qrController;
                      controller?.scannedDataStream.listen((scanData) {
                        String? qrCode = scanData.code;
                        if (quickDocketController.isProcessing == false) {
                          if (qrCode != null && qrCode.isNotEmpty) {
                            quickDocketController.eWayBillApi(eWayNumber: qrCode, isQrScan: true, isMenuScreen: true, context: context);
                          }
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff232F34),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const TmsText(
                    text: 'Cancel',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
