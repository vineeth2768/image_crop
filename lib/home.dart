import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? imageFile;

  Future _pickImage() async {
    final pickImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickImage != null) {
      setState(() {
        imageFile = File(pickImage.path);
      });
    }
  }

  void _clearImage() {
    setState(() {
      imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My image editor"),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 3,
              child: imageFile != null
                  ? Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Image.file(imageFile!),
                    )
                  : const Center(
                      child: Text("Add a picture"),
                    )),
          Expanded(
              child: Center(
                  child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildIconButton(icon: Icons.add, onpressed: _pickImage),
              _buildIconButton(icon: Icons.crop, onpressed: _cropImage),
              _buildIconButton(icon: Icons.clear, onpressed: _clearImage),
            ],
          )))
        ],
      ),
    );
  }

  Future _cropImage() async {
    if (imageFile != null) {
      CroppedFile? cropped = await ImageCropper()
          .cropImage(sourcePath: imageFile!.path, aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio16x9,
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: "Crop",
            cropGridColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(title: "Crop")
      ]);
      if (cropped != null) {
        setState(() {
          imageFile = File(cropped.path);
        });
      }
    }
  }
}

Widget _buildIconButton(
    {required IconData icon, required void Function()? onpressed}) {
  return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(10)),
      child: IconButton(
        onPressed: onpressed,
        icon: Icon(icon),
        color: Colors.white,
      ));
}
