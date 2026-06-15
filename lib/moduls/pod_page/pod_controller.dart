import 'dart:async';
import 'package:get/get.dart';
import '../../sqflite/pod_table.dart';
import '../../utils/tmsapp_api.dart';
import '../../widgets/custom_loader.dart';
import '../../model/pod_models/getpod_req.dart';
import '../../model/pod_models/getpod_res.dart';
import '../../utils/tmsapi_method.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PODController extends GetxController {
  late GetPodListRes getPodListRes;
  late GetPodListRes uploadImagePodRes;

  late RxList<ConnectivityResult> connectivityResult;
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;
  RxList<Pod> PodList = <Pod>[].obs;

  Future<void> checkInternetAvailability() async {
    var connectivity = await Connectivity().checkConnectivity();
    // connectivityResult.value = connectivity;
  }

  Future<void> podDocketListService(
      {required GetPodListReq getPodListReq}) async {
    AppLoader().show();
    await WebService.tmsPostRequest(
            url: ApiService.getPodList,
            body: getPodListReqToJson(getPodListReq))
        .then((value) {
      AppLoader().hide();
      getPodListRes = getPodListResFromJson(value.data);
      PodList.value = getPodListRes.data!.pod;
    });
  }

  Future<void> podDocketUploadService(
      {required List<String> pOdImages, required int podId}) async {
    await WebService.tmsMultiPartRequest(
            url: ApiService.uploadPODImage,
            pOdImage: pOdImages.first,
            podImageBack: pOdImages[1])
        .then((value) async {
      uploadImagePodRes = getPodUploadImageFromJson(value);
      if (uploadImagePodRes.message == "Success") {
        await TmsPodTable().delete(data: podId);
      }
    });
  }
}
