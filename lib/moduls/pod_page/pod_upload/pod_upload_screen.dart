import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../widgets/app_size.dart';
import '../../../widgets/dashboard_widgets/custom_box.dart';

class PodUpLoadScreen extends StatefulWidget {
  const PodUpLoadScreen({Key? key}) : super(key: key);

  @override
  State<PodUpLoadScreen> createState() => _PodUpLoadScreenState();
}

class _PodUpLoadScreenState extends State<PodUpLoadScreen> {
  List<File> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pod-Upload'),
        centerTitle: true,
        backgroundColor: const Color(0xff03045E),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Flexible(
              child: SizedBox(
                width: AppSize.size(context).width,
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  children: [
                    DashBoardContainer(
                      image: 'assets/images/dashboardimages/Gallery.png',
                      ontap: pickImagesFromGallery,
                      text: 'Pick Images',
                    ),
                    DashBoardContainer(
                      image: 'assets/images/dashboardimages/camera.png',
                      ontap: captureImageFromCamera,
                      text: 'Capture Image',
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              color: Color(0xff03045E),
            ),
            SizedBox(
              height: AppSize.size(context).height * 0.12,
              child: buildSelectedImages(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImagesFromGallery() async {
    final List<XFile> selectedFiles = await ImagePicker().pickMultiImage();
    List<File> tempImages = [];
    for (XFile file in selectedFiles) {
      tempImages.add(File(file.path));
    }
    setState(() {
      selectedImages.addAll(tempImages);
    });
  }

  Future<void> captureImageFromCamera() async {
    final XFile? capturedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (capturedFile != null) {
      setState(() {
        selectedImages.add(File(capturedFile.path));
      });
    }
  }

  Widget buildSelectedImages() {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 1,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      children: List.generate(selectedImages.length, (index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xff03045E),
              width: 3
            ),

          ),
          child: Image.file(selectedImages[index],fit: BoxFit.cover,),
        );
      }),
    );
  }
}
