import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../moduls/pod_page/pod_controller.dart';
import '../../sqflite/database_model/pod_tabel_model.dart';
import '../../sqflite/pod_table.dart';
import '../../utils/pref.dart';
import '../../widgets/tms_normaltext.dart';
import '../../widgets/tost.dart';

import '../../model/pod_models/getpod_res.dart';
import '../../utils/tms_color.dart';
import '../../widgets/app_size.dart';
import '../../widgets/tms_button.dart';
import '../../widgets/tms_richtext.dart';

Timer? timer;

class PodScreen extends StatefulWidget {
  const PodScreen({Key? key}) : super(key: key);

  @override
  State<PodScreen> createState() => _PodScreenState();
}

class _PodScreenState extends State<PodScreen> {
  PODController podController = Get.put(PODController());
  RxBool isSetState = false.obs;

  @override
  void initState() {
    super.initState();
    podController.checkInternetAvailability();
    podController.connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((result) {
      podController.connectivityResult.value = result;
      if (kDebugMode) {
        print(podController.connectivityResult.value);
      }
    });
    if (timer == null ? true : !(timer!.isActive)) {
      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        if (podController.connectivityResult.value ==
                ConnectivityResult.mobile ||
            podController.connectivityResult.value == ConnectivityResult.wifi) {
          List<PodTableModel> podTableData = await TmsPodTable().query();
          if (podTableData.isNotEmpty) {
            for (PodTableModel data in podTableData) {
              if ((data.podImage
                          .replaceAll('[', '')
                          .replaceAll(']', '')
                          .split(',')
                          .toList()
                          .length >
                      1) &&
                  (data.podImage != '[]')) {
                Future.delayed(const Duration(seconds: 1), () {
                  podController.podDocketUploadService(
                      podId: data.id!,
                      pOdImages: data.podImage
                          .replaceAll('[', '')
                          .replaceAll(']', '')
                          .split(',')
                          .map((e) => e.replaceAll(' ', ''))
                          .toList());
                });
              }
            }
          }
        }
      });
    }
  }

  podView(
      {required BuildContext context,
      required String text1,
      required String richText1,
      required RxString status,
      required Pod pod,
      required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TmsImageTextView(
                      text: richText1,
                      image: "assets/images/dashboardimages/Docket.png",
                      height: 25,
                      color: AppColor.black),
                  SizedBox(
                    height: 5,
                  ),
                  TmsRichText(
                    text: 'Status :',
                    richText: status.value,
                    color: Color(0xff232F34),
                    color1: AppColor.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    fontSize1: 12,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xff232F34),
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: TmsText(
                          text:
                          'only two images are allowed to be uploaded at a time',
                          fontSize: 10,
                          color: AppColor.bloodRed,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: AppSize.size(context).height * 0.05,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: onTap,
                          child: SizedBox(
                            child: Image(
                              image: AssetImage(
                                "assets/images/dashboardimages/Group 70 (1).png",
                              ),
                            ),
                          ),
                        ),
                        TmsButton(
                          text: 'Submit',
                          textSize: 12,
                          onPressed: () async {
                            if (pod.selectedImages.length > 1) {
                              await TmsPodTable()
                                  .insert(PodTableModel(
                                      docNo: pod.dockno!,
                                      podImage: pod.selectedImages
                                          .map((e) => e.path)
                                          .toList()
                                          .toString(),
                                      status:
                                          pod.selectedImages.isEmpty ? 0 : 1))
                                  .whenComplete(() => podController
                                      .getPodListRes.data!.pod
                                      .removeWhere((element) =>
                                          element.dockno == pod.dockno));
                              TmsToast.msg(
                                  '${pod.dockno!} submitted successfully');
                              setState(() {});
                            } else {
                              TmsToast.msg('please select more then 1 image');
                            }
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POD', style: TextStyle(color: Colors.white)),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            )),
        centerTitle: true,
        backgroundColor: const Color(0xff232F34),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
                children: podController.getPodListRes.data!.pod
                    .map<Widget>((e) => podView(
                          pod: e,
                          text1: 'Dock No : ',
                          richText1: '${e.dockno}',
                          status: e.selectedImages.isEmpty
                              ? 'NULL'.obs
                              : '${e.selectedImages.length} photo uploaded'.obs,
                          onTap: () async {
                            List<File> selectedImages =
                                await ScannedDocketNumberAlertDialog(
                                      pod: e,
                                      context: context,
                                      title: '',
                                      description: 'description',
                                      index: 1,
                                      onTapText: 'Done',
                                      selectedImages: e.selectedImages.value,
                                      onTap: () {
                                        Get.back();
                                      },
                                      cancelOnTap: () {},
                                    ) ??
                                    [];
                            if (selectedImages.isNotEmpty) {
                              e.selectedImages.value = selectedImages;
                            }
                            setState(() {});
                          },
                          context: context,
                        ))
                    .toList()),
          ),
        ),
      ),
    );
  }
}

ScannedDocketNumberAlertDialog(
    {required BuildContext context,
    required String title,
    required String description,
    required int index,
    required String onTapText,
    required Function() onTap,
    required Function() cancelOnTap,
    required List<File> selectedImages,
    required Pod pod}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (
      BuildContext context,
    ) {
      return UploadPodDailog(
        onTap: onTap,
        title: title,
        description: description,
        index: index,
        cancelOnTap: cancelOnTap,
        selectedImages: selectedImages,
        onTapText: onTapText,
        pod: pod,
      );
    },
  );
}

class UploadPodDailog extends StatefulWidget {
  const UploadPodDailog(
      {required this.onTap,
      required this.title,
      required this.description,
      required this.index,
      required this.cancelOnTap,
      required this.onTapText,
      required this.selectedImages,
      required this.pod,
      super.key});

  final String title;
  final String description;
  final int index;
  final String onTapText;
  final Function() onTap;
  final Function() cancelOnTap;
  final List<File> selectedImages;
  final Pod pod;

  @override
  State<UploadPodDailog> createState() => _UploadPodDailogState();
}

class _UploadPodDailogState extends State<UploadPodDailog> {
  List<File> selectedImages = [];

  Future<void> pickImagesFromGallery() async {
    final List<XFile> selectedFiles = await ImagePicker().pickMultiImage();
    for (XFile file in selectedFiles) {
      if (selectedImages.isEmpty) {
        File renamed = await renameImage(
            file: File(file.path),
            docketNo: widget.pod.dockno!,
            userName: Pref().getUserName(),
            brcd: Pref().getBaseLocation(),
            isFront: true);
        setState(() {
          selectedImages.add(renamed);
        });
      } else if (selectedImages.length == 1) {
        File renamed = await renameImage(
            file: File(file.path),
            docketNo: widget.pod.dockno!,
            userName: Pref().getUserName(),
            brcd: Pref().getBaseLocation(),
            isFront: false);
        setState(() {
          selectedImages.add(renamed);
        });
      } else {
        File renamed = await renameImage(
            file: File(file.path),
            docketNo: widget.pod.dockno!,
            userName: Pref().getUserName(),
            brcd: Pref().getBaseLocation(),
            isFront: false,
            isMoreThenTwo: true);
        setState(() {
          selectedImages.add(renamed);
        });
      }
    }
  }

  Future<void> captureImageFromCamera() async {
    final XFile? capturedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (capturedFile != null) {
      if (selectedImages.isEmpty) {
        File renamed = await renameImage(
            file: File(capturedFile.path),
            docketNo: widget.pod.dockno!,
            userName: Pref().getUserName(),
            brcd: Pref().getBaseLocation(),
            isFront: true);
        setState(() {
          selectedImages.add(renamed);
        });
      } else if (selectedImages.length == 1) {
        File renamed = await renameImage(
            file: File(capturedFile.path),
            docketNo: widget.pod.dockno!,
            userName: Pref().getUserName(),
            brcd: Pref().getBaseLocation(),
            isFront: false);
        setState(() {
          selectedImages.add(renamed);
        });
      } else {
        File renamed = await renameImage(
            file: File(capturedFile.path),
            docketNo: widget.pod.dockno!,
            userName: Pref().getUserName(),
            brcd: Pref().getBaseLocation(),
            isFront: false,
            isMoreThenTwo: true);
        setState(() {
          selectedImages.add(renamed);
        });
      }
    }
  }

  Future<File> renameImage(
      {required File file,
      required String docketNo,
      required String userName,
      required String brcd,
      required bool isFront,
      bool isMoreThenTwo = false}) async {
    String originalPath = file.path;
    String directory = (await getTemporaryDirectory()).path;
    String newName = modifiImageName(
      docketNo: docketNo,
      userName: userName,
      brcd: brcd,
      isFront: isFront,
      isMoreThenTwo: isMoreThenTwo,
    ); // New name for the image

    String newPath = '$directory/$newName';

    File renamedFile = await file.rename(newPath);
    return renamedFile;
  }

  String modifiImageName(
      {required String docketNo,
      required String userName,
      required String brcd,
      required bool isFront,
      bool isMoreThenTwo = false}) {
    String name =
        'P@$docketNo@$userName@$brcd${isMoreThenTwo ? '' : (isFront ? "_F" : "_B")}.jpg';
    return name;
  }

  void selectImage(File image) {
    setState(() {
      if (selectedImages.length > 2) {
        if (selectedImages.contains(image)) {
          selectedImages.remove(image);
        }

        final extraImages = selectedImages.sublist(2);
        selectedImages = selectedImages.sublist(0, 2);
        TmsToast.msg(
            '${selectedImages.length} images selected. ${extraImages.length} extra images removed.');
      }
    });
  }

  Widget buildSelectedImages() {
    if (selectedImages.isEmpty) {
      return const SizedBox.shrink();
    }

    List<File> displayedImages = selectedImages.take(2).toList();


    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: List.generate(displayedImages.length, (index) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xff232F34), width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(07),
                  child: Image.file(selectedImages[index], fit: BoxFit.fill,
                      errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  }),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    selectedImages.removeAt(index);
                  });
                },
                icon: const Icon(CupertinoIcons.xmark_circle_fill,
                    color: Colors.red),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedImages = widget.selectedImages;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xffF8F9FA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: AppSize.size(context).height * 0.01,
            ),
            TmsText(
              text: "Add image",
              color: Color(0xff232F34),
              fontWeight: FontWeight.w500,
            ),
            Divider(
              thickness: 2,
              color: Color(0xff232F34),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: SizedBox(
                height: AppSize.size(context).height * 0.055,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          pickImagesFromGallery();
                          selectedImages;
                        });
                      },
                      child: Image(
                        image: AssetImage(
                            'assets/images/dashboardimages/uploadGallery.png'),
                      ),
                    ),
                    // const Spacer(),
                    InkWell(
                      onTap: () {
                        setState(() {
                          captureImageFromCamera();
                          selectedImages;
                        });
                      },
                      child: Image(
                        image: AssetImage(
                            'assets/images/dashboardimages/image_2__2_-removebg-preview.png'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (selectedImages.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: AppSize.size(context).height * 0.09,
                  child: buildSelectedImages(),
                ),
              ),
            SizedBox(height: AppSize.size(context).height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TmsButton(
                  color: Color(0xffE9ECEF),
                  textColor: Color(0xff232F34),
                  textSize: 12,
                  text: "Cancel",
                  borderColor: Color(0xff232F34),
                  borderWidth: 1,
                  onPressed: () {
                    selectedImages.clear();
                    Get.back();
                  },
                ),
                TmsButton(
                  textSize: 12,
                  text: widget.onTapText,
                  onPressed: () {
                    widget.onTap;
                    if (selectedImages.isNotEmpty) {
                      selectImage(selectedImages.last);
                    }
                    Navigator.pop(context, selectedImages);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
