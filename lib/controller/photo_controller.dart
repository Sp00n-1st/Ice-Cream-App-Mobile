import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:uuid/uuid.dart';

class PhotoC extends GetxController {
  final auth = FirebaseAuth.instance.currentUser!.uid;
  List<Widget> itemPhotosWidgetList = <Widget>[];
  final ImagePicker _picker = ImagePicker();
  XFile? photo;
  XFile? itemImagesList;
  var downloadUrl = ''.obs;
  var uploading = false.obs;
  var pathImage = ''.obs;

  pickPhotoFromGallery() async {
    photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      itemImagesList = photo!;
      pathImage.value = photo!.path;
    }
  }

  upload() async {
    await uplaodImageAndSaveItemInfo();
    uploading.value = false;
    itemPhotosWidgetList.clear();
    showToast("Edit Profile Successfully !",
        textStyle: GoogleFonts.poppins(),
        backgroundColor: Colors.green,
        position: const ToastPosition(align: Alignment.bottomCenter));
  }

  Future<String> uplaodImageAndSaveItemInfo() async {
    uploading.value = true;

    String? productId = const Uuid().v4();
    if (itemImagesList != null) {
      PickedFile? pickedFile = PickedFile(itemImagesList!.path.toString());
      await uploadImageToStorage(pickedFile, productId);
    }
    return productId;
  }

  uploadImageToStorage(PickedFile? pickedFile, String productId) async {
    Reference reference =
        FirebaseStorage.instance.ref().child('ProfileImages/$auth');
    await reference.putData(
      await pickedFile!.readAsBytes(),
      SettableMetadata(contentType: 'image/jpeg'),
    );
    String value = await reference.getDownloadURL();
    downloadUrl.value = value;
  }
}
