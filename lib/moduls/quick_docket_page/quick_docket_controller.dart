import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../app_routes.dart';
import '../../model/quick_docket_model/billing_response.dart';
import '../../model/quick_docket_model/custList_response.dart';
import '../../model/quick_docket_model/eway_bill_response.dart';
import '../../model/quick_docket_model/picode.dart';
import '../../model/quick_docket_model/product.dart';
import '../../model/quick_docket_model/quick_docket_submit_models/quick_docket_request.dart';
import '../../model/quick_docket_model/transport_response.dart';
import '../../moduls/docket_page/docket_controller.dart';
import '../../moduls/quick_docket_page/quick_docket_screen.dart';
import '../../utils/logging.dart';
import '../../utils/pref.dart';
import '../../utils/tmsapp_api.dart';
import '../../model/dash_board_model/location_master.dart';
import '../../model/quick_docket_model/city.dart';
import '../../model/quick_docket_model/city_type.dart';
import '../../model/quick_docket_model/packageType.dart';
import '../../model/quick_docket_model/quick_docket_submit_models/quick_docket_response.dart';
import '../../utils/tmsapi_method.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/submit_alert_dialog.dart';
import '../../widgets/tost.dart';

enum eWayBillScan { none, first, multiple }

enum docketCheck { none, right, wrong }

class QuickDocketController extends GetxController {
  final log = logger;

  List GeneralMasterTypeList = ["PAYTYP", "TRN"];

  RxList<BillingTypeList> payBasList = <BillingTypeList>[].obs;

  // RxList<BillingTypeList> transportModelList = <BillingTypeList>[].obs;
  RxList<TransportDatum> transportModelList = <TransportDatum>[].obs;
  Rx<eWayBill> eWayBillStatus = eWayBill.none.obs;

  // RxList<TransitMode> transitModeList = <TransitMode>[].obs;
  RxList<CustList> customerList = <CustList>[].obs;
  RxList<LocationList> location = <LocationList>[].obs;
  RxList<pinCodeObject> pinCodeList = <pinCodeObject>[].obs;
  RxList<ProductObject> productList = <ProductObject>[].obs;
  RxList<PackageTypeObject> packageTypeList = <PackageTypeObject>[].obs;
  RxList<CityObject> cityList = <CityObject>[].obs;

  TextEditingController noOfPackageController = TextEditingController();
  TextEditingController actualWeightController = TextEditingController();
  TextEditingController chargeWeightController = TextEditingController();
  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController docketDateController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController docketNoController = TextEditingController();
  TextEditingController eWayBillNoController = TextEditingController();
  TextEditingController declaredValueController = TextEditingController();
  TextEditingController valueMetricController = TextEditingController();
  TextEditingController toCityController = TextEditingController();
  TextEditingController fromCityController = TextEditingController();

  AppLoader appLoader = AppLoader();

  FocusNode noOfPackage = FocusNode();
  FocusNode actualWeight = FocusNode();
  FocusNode chargeWeight = FocusNode();
  FocusNode invoiceNumber = FocusNode();
  FocusNode destination = FocusNode();
  FocusNode odaCategory = FocusNode();
  FocusNode docketNumber = FocusNode();
  FocusNode docketFocus = FocusNode();
  FocusNode eWayBillNo = FocusNode();
  FocusNode declaredValue = FocusNode();
  FocusNode valueMetric = FocusNode();
  FocusNode noOfPKG = FocusNode();
  FocusNode length = FocusNode();
  FocusNode breadth = FocusNode();
  FocusNode height = FocusNode();

  RxList<CityDatum> CityType = <CityDatum>[].obs;
  Rx<DataStatus> payBaseDataStatus = DataStatus.loading.obs;
  Rx<DataStatus> transportModelDataStatus = DataStatus.loading.obs;
  Rx<DataStatus> productDataStatus = DataStatus.loading.obs;
  Rx<DataStatus> packageTypeDataStatus = DataStatus.loading.obs;
  Rx<eWayBillScan> eWayBillScanStatus = eWayBillScan.none.obs;

  RxList<XFile> selectedImages = <XFile>[].obs;
  List<String> base64Images = [];
  RxList<DocketInvoiceList> docketInvoiceList = <DocketInvoiceList>[].obs;

  late EwayBillResponse eWayBillResponse;

  void onInit() {
    billingTypeApi();
    // transportModelApi();
    cityApi();
    super.onInit();
  }

  String convertDateFormat({required String date}) {
    // Check if the input date is empty or null
    if (date.isEmpty) {
      return "";
    }

    // Parse the input date string in ISO 8601 format
    DateTime inputDate = DateTime.parse(date);

    // Format the date to 'dd MMM yyyy'
    String formattedDate = DateFormat("dd MMM yyyy").format(inputDate);

    return formattedDate;
  }


  String originLocation = Pref().getBranchCode() == 'HQTR' ? Pref().getBaseLocation() : Pref().getBranchCode();
  RxString billingType = 'Select Paybase Type'.obs;
  RxString billingId = ''.obs;
  String consignorId = '';
  RxString consignorName = 'Select Billing Party'.obs;
  RxString selectTransportModel = 'Select Transport Mode'.obs;
  RxString selectTransportId = ''.obs;
  RxString pinCode = 'Select Pincode'.obs;
  String docketNm = "";
  String fromCity = "";
  String selectProduct = "";
  String selectPackage = "";
  String csgncd = '';
  String csgnm = '';
  String csgnAdd = '';
  String csgecd = '';
  String csgenm = '';
  String csgeAdd = '';
  String eWayBillExpiredDate = '';
  String eWayBillInvoiceDate = '';
  int toPincode = 0;
  dynamic area;

  bool isProcessing = false;

  RxBool isEWayNumber = true.obs;
  RxBool isDeclared = true.obs;
  RxBool isInvoice = true.obs;
  RxBool isNumberOfPkg = true.obs;
  RxBool isActualWeight = true.obs;
  RxBool isHeight = true.obs;
  RxBool isBreadth = true.obs;
  RxBool isLength = true.obs;
  RxBool isEWBEmpty = true.obs;
  RxBool transportMode = false.obs;
  RxBool docketDate = true.obs;

  RxBool isValueMetrics = false.obs;

  textFocus() {
    noOfPackage.unfocus();
    actualWeight.unfocus();
    invoiceNumber.unfocus();
    eWayBillNo.unfocus();
    docketFocus.unfocus();
    height.unfocus();
    breadth.unfocus();
    length.unfocus();
    eWayBillNo.unfocus();
    noOfPKG.unfocus();
    declaredValue.unfocus();
  }

  ctrlClear() {
    noOfPackageController.clear();
    actualWeightController.clear();
    invoiceNoController.clear();
    docketDateController.clear();
    docketNoController.clear();
    eWayBillNoController.clear();
    destinationController.clear();
    toCityController.clear();
    docketInvoiceList.clear();
    chargeWeightController.clear();
    base64Images.clear();
    selectedImages.clear();
    declaredValueController.clear();
    consignorName = ''.obs;
    fromCity = '';
    consignorId = '';
    consignorName = ''.obs;
    eWayBillExpiredDate = '';
    selectProduct = "";
    docketNm = "";
    selectPackage = "";
    isEWBEmpty.value = true;
  }


  eWayBillApi({required String eWayNumber, required bool isQrScan, required isMenuScreen, required BuildContext context}) async {
    if (isQrScan == true) {
      Get.back();
      // Get.back();
    }

    AppLoader().show();
    isProcessing = true;
    var data = {
      "lsno": eWayNumber,
    };

    final response = await WebService.tmsPostRequest(
      url: ApiService.eWayBill,
      body: json.encode(data),
    );
    AppLoader().hide();
    try {
      if (response.statusCode == 200) {
        eWayBillResponse = ewayBillResponseFromJson(response.data);
        if (eWayBillResponse.data.status == 1) {
          if (docketInvoiceList.length <= 1) {
            if (eWayBillStatus.value == eWayBill.withEWayBill) {
              destinationController.text = eWayBillResponse.data.destcd;
              toCityController.text = eWayBillResponse.data.toCity;
              csgecd = eWayBillResponse.data.csgecd;
              eWayBillExpiredDate = eWayBillResponse.data.eWayBillExpiredDate;
              eWayBillInvoiceDate = eWayBillResponse.data.eWayBillInvoiceDate;
              docketDateController.text = convertDateFormat(date:  eWayBillResponse.data.eWayBillInvoiceDate);
              docketDate.value = false;
              csgenm = eWayBillResponse.data.csgenm;
              csgnAdd = eWayBillResponse.data.csgnAdd;
              csgeAdd = eWayBillResponse.data.csgeAdd;
              csgnm = eWayBillResponse.data.csgnm;
              area = eWayBillResponse.data.area;
              toPincode = eWayBillResponse.data.toPincode;
              csgncd = eWayBillResponse.data.csgncd;
              fromCity = eWayBillResponse.data.fromCity;
              pinCode.value = eWayBillResponse.data.pincode.toString();
              isValueMetrics.value = eWayBillResponse.data.volYn == "Y" ? true : false;
              isEWayNumber.value = false;
              isEWBEmpty.value = true;
              isInvoice.value = true;
              isDeclared.value = true;
              isNumberOfPkg = true.obs;
              isActualWeight = true.obs;
              isHeight = true.obs;
              isBreadth = true.obs;
              isLength = true.obs;
              isEWBEmpty = true.obs;
              for (var data in payBasList) {
                if (data.codeId == eWayBillResponse.data.paybas) {
                  billingType.value = data.codeDesc;
                }
              }
              billingId.value = eWayBillResponse.data.paybas;
              for (var data in transportModelList) {
                if (data.codeId == eWayBillResponse.data.transMode) {
                  selectTransportModel.value = data.codeDesc;
                  print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${selectTransportModel.value}");
                }
              }
              selectTransportId.value = eWayBillResponse.data.transMode;
              consignorName.value = eWayBillResponse.data.partyName;
              consignorId = eWayBillResponse.data.partyCode;
              pinCode.value = eWayBillResponse.data.toPincode.toString();
              eWayBillNoController.text = eWayBillResponse.data.ewaybillNo;
              invoiceNoController.text = eWayBillResponse.data.invno;
              declaredValueController.text = eWayBillResponse.data.decval.toString();
            } else {
              eWayBillNoController.text = eWayBillResponse.data.ewaybillNo;
              invoiceNoController.text = eWayBillResponse.data.invno;
              eWayBillExpiredDate = eWayBillResponse.data.eWayBillExpiredDate;
              eWayBillInvoiceDate = eWayBillResponse.data.eWayBillInvoiceDate;
              declaredValueController.text = eWayBillResponse.data.decval.toString();
              isNumberOfPkg = true.obs;
              isActualWeight = true.obs;
              isHeight = true.obs;
              isBreadth = true.obs;
              isLength = true.obs;
              isEWBEmpty = true.obs;
              isDeclared = true.obs;
              isInvoice = true.obs;
              docketDate.value = true;
            }
          } else {
            if (consignorId == eWayBillResponse.data.partyCode) {
              eWayBillNoController.text = eWayBillResponse.data.ewaybillNo;
              invoiceNoController.text = eWayBillResponse.data.invno;
              eWayBillExpiredDate = eWayBillResponse.data.eWayBillExpiredDate;
              eWayBillInvoiceDate = eWayBillResponse.data.eWayBillInvoiceDate;
              declaredValueController.text = eWayBillResponse.data.decval.toString();
              isNumberOfPkg = true.obs;
              isActualWeight = true.obs;
              isHeight = true.obs;
              isBreadth = true.obs;
              isLength = true.obs;
              isEWBEmpty = true.obs;
              docketDate.value = true;
            } else {
              TmsToast.msg("EWayBill not match");
            }
          }

          if (isMenuScreen == true) {
            Get.toNamed(AppRoutes.quickDocketScreen);
            custListApi(context: context);
          }
          isProcessing = false;
        } else {
          TmsToast.msg("Data not found");
          isProcessing = false;
          eWayBillNoController.clear();
        }
      } else {
        TmsToast.msg("Data not found");
        isProcessing = false;
        eWayBillNoController.clear();
      }
    } catch (error) {
      TmsToast.msg("Data not found");
      isProcessing = false;
      eWayBillNoController.clear();
    }
  }

  ///Billing Type
  Future<void> billingTypeApi() async {
    payBaseDataStatus.value = DataStatus.loading;
    String url = "${ApiService.baseUrl}V1/Master/GetGeneralMasterData?CodeType=PAYTYP";
    try {
      final dio.Response response = await WebService.tmsGetRequest(url);
      if (response.statusCode == 200) {
        log.i(jsonDecode(response.data), error: "Billing Type Api ${response.statusMessage}");
        BillingTypeResponse billingTypeResponse = billingTypeResponseFromJson(response.data);
        billingTypeResponse.removeCodeId("P01");
        payBasList.value = billingTypeResponse.billingTypeList;
        payBaseDataStatus.value = DataStatus.completed;
      } else {
        payBaseDataStatus.value = DataStatus.error;
        log.e(jsonDecode(response.data), error: "Billing Type Api ${response.statusMessage}");
        if (kDebugMode) {
          print(response.statusMessage);
        }
      }
    } catch (error) {
      payBaseDataStatus.value = DataStatus.error;
      log.e(error, error: "Billing Type Api Error");
      if (kDebugMode) {
        print(error.reactive);
      }
    }
  }

  // Future<void> transportModelApi() async {
  //   try {
  //     final dio.Response response = await WebService.tmsGetRequest(ApiService.GeneralMasterData + "?CodeType=TRN");
  //     if (response.statusCode == 200) {
  //       BillingTypeResponse transportModelResponse = billingTypeResponseFromJson(response.data);
  //       transportModelList.value = transportModelResponse.billingTypeList;
  //     } else {
  //       if (kDebugMode) {
  //         print(response.statusMessage);
  //       }
  //     }
  //   } catch (error) {
  //     if (kDebugMode) {
  //       print(error.reactive);
  //     }
  //   }
  // }

  Future<void> transportModelApi({
    required String Custcode,
    required String Paybas,
  }) async {
    AppLoader().show();
    try {
      final dio.Response response = await WebService.tmsGetRequest("${ApiService.GetTransportMode}?Custcode=$Custcode&Paybas=$Paybas" );
      AppLoader().hide();
      if (response.statusCode == 200) {
        TransportResponseModel transportModelResponse = transportResponseModelFromJson(response.data);
        transportModelList.value = transportModelResponse.transportData;
        transportMode.value = true;
      } else {
        if (kDebugMode) {
          print(response.statusMessage);
          transportMode.value = false;
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.reactive);
        transportMode.value = false;
      }
    }
  }

  Future<void> cityApi() async {
    try {
      final dio.Response response = await WebService.tmsGetRequest(ApiService.GetFromToCity);
      if (response.statusCode == 200) {
        CityResponse cityResponse = cityResponseFromJson(response.data);
        cityList.value = cityResponse.cityList;
      } else {
        if (kDebugMode) {
          print(response.statusMessage);
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.reactive);
      }
    }
  }

  Future<void> custListApi({required BuildContext context}) async {
    appLoader.show();
    String url = "${ApiService.baseUrl}V1/Master/GetCustomerList?Search=%&Location=${Pref().getBaseLocation()}&Paybas=$billingType";
    print(url);
    try {
      final dio.Response response = await WebService.tmsGetRequest(url);

      if (response.statusCode == 200) {
        log.i(jsonDecode(response.data), error: "Customer List Api ${response.statusMessage}");

        CustListResponse custListResponse = custListResponseFromJson(response.data);

        customerList.value = custListResponse.custList;
        appLoader.hide();
      } else {
        customerList.clear();
        log.e(jsonDecode(response.data), error: "Customer List Api ${response.statusMessage}");
        TmsToast.msg('Docket check error ${response.statusMessage}');
        if (kDebugMode) {
          print(response.statusMessage);
        }
        appLoader.hide();
      }
    } catch (error) {
      appLoader.hide();
      customerList.clear();
      log.e(error, error: "Customer List Api Error");
      TmsToast.msg('No Data Found');
    }
  }

  Future<void> getFromToCityType({required String locationID}) async {
    try {
      final dio.Response response = await WebService.tmsGetRequest("${ApiService.GetFromToCity}?type=$locationID");
      if (response.statusCode == 200) {
        dynamic responseData = response.data;
        CityTypeResponseModel cityTypeResponseModel = cityTypeResponseModelFromJson(responseData);
        CityType.value = cityTypeResponseModel.cityData;
      } else {
        if (response.statusCode == 401) {
          // tokenExpire();
        } else {
          print('${response.statusCode} : ${response.data.toString()}');
        }
      }
    } catch (error) {
      print(error);
    }
  }

  // ///Quick Docket
  // Future<void> docketCheckApi({
  //   required BuildContext context,
  //   required bool isPayBaseType,
  //   required GlobalKey<FormState> billingTypeFromKey,
  //   required GlobalKey<FormState> billingPartyFromKey,
  //   required GlobalKey<FormState> transportModelFromKey,
  //   required GlobalKey<FormState> invoiceNoFromKey,
  //   required GlobalKey<FormState> docketDateFromKey,
  //   required GlobalKey<FormState> numberPkgFromKey,
  //   required GlobalKey<FormState> declaredValueFromKey,
  //   required GlobalKey<FormState> actualWeightFromKey,
  // }) async {
  //   appLoader.show();
  //   String addUrl =
  //       '?DocketNo=${docketNoController.text}&LocCode=${Pref().getBaseLocation()}&UserId=${Pref().getUserId()}';
  //   var response = await WebService.tmsPostRequest(
  //     url: ApiService.checkValidDocketNo + addUrl,
  //     body: '',
  //   );
  //   appLoader.hide();
  //   try {
  //     if (response.statusCode == 200) {
  //       CheckValidDocketNoResponse checkValidDocketNoResponse =
  //           checkValidDocketNoResponseFromJson(response.data);
  //
  //       if (checkValidDocketNoResponse.status == 200) {
  //         if (checkValidDocketNoResponse.data.codeId == '1') {
  //           if (isPayBaseType == false) {
  //             TmsToast.msg(
  //                 "${docketNoController.text} is a valid docket number");
  //             submitValidator(
  //               billingTypeFromKey: billingTypeFromKey,
  //               billingPartyFromKey: billingPartyFromKey,
  //               transportModelFromKey: transportModelFromKey,
  //               invoiceNoFromKey: invoiceNoFromKey,
  //               numberPkgFromKey: numberPkgFromKey,
  //               declaredValueFromKey: declaredValueFromKey,
  //               actualWeightFromKey: actualWeightFromKey,
  //               docketDateFromKey: docketDateFromKey,
  //             );
  //           }
  //           if (isPayBaseType == true) {
  //             TmsToast.msg(
  //                 "${docketNoController.text} is a valid docket number");
  //           }
  //           log.i(jsonDecode(response.data),
  //               error:
  //                   "Docket Check Api ${checkValidDocketNoResponse.message}");
  //         } else {
  //           log.e(jsonDecode(response.data),
  //               error:
  //                   "Docket Check Api ${checkValidDocketNoResponse.message}");
  //           docketNoController.clear();
  //
  //           TmsToast.msg('Please Enter valid Docket Number');
  //         }
  //       } else {
  //         log.e(jsonDecode(response.data),
  //             error: "Docket Check Api ${response.statusMessage}");
  //         TmsToast.msg(checkValidDocketNoResponse.message);
  //         docketNoController.clear();
  //       }
  //     } else {
  //       log.i(jsonDecode(response.data),
  //           error: "Docket Check Api ${response.statusMessage}");
  //       TmsToast.msg("Docket no check - ${response.statusMessage}");
  //       docketNoController.clear();
  //     }
  //   } catch (error) {
  //     appLoader.hide();
  //     log.e(error, error: "Docket Check Api Error");
  //     TmsToast.msg('Docket check error ${error.toString()}');
  //     docketNoController.clear();
  //   }
  // }

  Future<String> getLocationCode(String value) async {
    String locationName = value;
    String locationCode = locationName.split("-")[0].replaceAll(" ", '');
    return locationCode;
  }

  /// Billing Type
  billingSelectType(String value) {
    for (var data in payBasList) {
      if (data.codeDesc == value) {
        billingType.value = data.codeId;
        print("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<${billingType}");
      }
    }
  }

  /// Consignor Name
  consignorSelectName(String value) {
    consignorName.value = value;
    consignorId = customerList.where((innerValue) => innerValue.custnm.contains(value)).first.custcd;
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

  ///Quick Docket Submit Request
  quickDocketApiRequest() {
    QuickDocketSubmit quickDocketSubmitRequest = QuickDocketSubmit(
      dockdt: docketDateController.text,
      partYCode: consignorId,
      partyName: consignorName.value,
      orgncd: "${Pref().getBaseLocation()}",
      destcd: destinationController.text,
      paybas: billingType.value,
      currFinYear: Pref().getFinYear(),
      baseCompanyCode: Pref().getCompanyCode(),
      toCity: toCityController.text,
      transPortModel: selectTransportId.value,
      dockno: docketNoController.text,
      pincode: "",
      baseUserName: Pref().getUserId(),
      volYn: isValueMetrics.isTrue ? "Y" : "N",
      csgeAdd: csgeAdd,
      csgecd: csgecd,
      csgenm: csgenm,
      csgnAdd: csgnAdd,
      csgncd: csgncd,
      csgnm: csgnm,
      fromCity: fromCityController.text /*Pref().getCity()*/,
      toPincode: toPincode.toString(),
      docketInvoiceList: docketInvoiceList,
    );
    return quickDocketSubmitRequest;
  }

  ///Quick Docket
  Future<void> quickDocketSubmitApi({required BuildContext context}) async {
    appLoader.show();
    var response = await WebService.tmsPostRequest(
      url: ApiService.quickDocketAPI,
      body: quickDocketSubmitToJson(quickDocketApiRequest()),
    );
    appLoader.hide();
    try {
      if (response.statusCode == 200) {
        QuickDocketSubmitResponse quickDocketSubmitResponse = quickDocketSubmitResponseFromJson(response.data);
        if (quickDocketSubmitResponse.status == 200) {
          log.i(jsonDecode(response.data), error: "Quick Docket Submit Api ${quickDocketSubmitResponse.message}");
          docketNm = quickDocketSubmitResponse.data.docketno;
          ctrlClear();
          submitAlertDialog(
            context: context,
            isPrintShow: true,
            title: '${quickDocketSubmitResponse.data.docketno}\nDocket number create successfully',
            onTap: () {
              Get.toNamed(AppRoutes.dashboardScreen);
              ctrlClear();
            },
            printerTap: () {
              Get.back();
              Get.toNamed(AppRoutes.docketDetails, arguments: quickDocketSubmitResponse.data.docketno);
            },
            onTapText: 'Done',
            image: 'assets/images/dashboardimages/succes.png',
          );
        } else {
          log.e(jsonDecode(response.data), error: "Quick Docket Submit Api ${quickDocketSubmitResponse.message}");
          TmsToast.msg(quickDocketSubmitResponse.message);
        }
      } else {
        TmsToast.msg("Quick Docket submit ${response.statusMessage}");
      }
    } catch (error) {
      TmsToast.msg('Quick Docket Submit error ${error.toString()}');
    }
  }

  submitValidator({
    required GlobalKey<FormState> billingTypeFromKey,
    required GlobalKey<FormState> billingPartyFromKey,
    required GlobalKey<FormState> transportModelFromKey,
    required GlobalKey<FormState> fromCityFromKey,
    required GlobalKey<FormState> toCityFromKey,
    required GlobalKey<FormState> invoiceNoFromKey,
    required GlobalKey<FormState> numberPkgFromKey,
    required GlobalKey<FormState> docketDateFromKey,
    required GlobalKey<FormState> declaredValueFromKey,
    required GlobalKey<FormState> actualWeightFromKey,
    required GlobalKey<FormState> chargeWeightFromKey,
  }) {
    if ((eWayBillStatus.value == eWayBill.withoutEWayBill) ? (billingTypeFromKey.currentState!.validate() && billingPartyFromKey.currentState!.validate()) : true) {
      if (billingTypeFromKey.currentState!.validate() && billingPartyFromKey.currentState!.validate() && transportMode.isTrue
          ? (transportModelFromKey.currentState!.validate())
          : fromCityFromKey.currentState!.validate() &&
              toCityFromKey.currentState!.validate() &&
              invoiceNoFromKey.currentState!.validate() &&
              numberPkgFromKey.currentState!.validate() &&
              declaredValueFromKey.currentState!.validate() &&
              actualWeightFromKey.currentState!.validate() &&
              chargeWeightFromKey.currentState!.validate()) {
        docketInvoiceList.add(
          DocketInvoiceList(
            invno: invoiceNoController.text,
            prodcd: "",
            pkgsty: "",
            pkgs: parseInputToInt(noOfPackageController.text),
            decval: parseInputToDouble(declaredValueController.text),
            actuwt: parseInputToDouble(actualWeightController.text),
            chrgwt: parseInputToDouble(chargeWeightController.text),
            ewbno: eWayBillNoController.text,
            voLL: 0.0,
            voLB: 0.0,
            voLH: 0.0,
            eWayBillExpiredDate: eWayBillExpiredDate.isEmpty ? null : eWayBillExpiredDate,
            eWayBillInvoiceDate: eWayBillInvoiceDate.isEmpty ? null : eWayBillInvoiceDate,
            image: base64Images.isNotEmpty?base64Images[0]:"",
          ),
        );

        isEWayNumber.value = true;
        isDeclared.value = true;
        isInvoice.value = true;
        invoiceNoController.clear();
        noOfPackageController.clear();

        declaredValueController.clear();

        actualWeightController.clear();

        actualWeightController.clear();
        chargeWeightController.clear();
        eWayBillNoController.clear();
        quickDocketSubmitApi(context: Get.context!);
      }
    }
  }
}
