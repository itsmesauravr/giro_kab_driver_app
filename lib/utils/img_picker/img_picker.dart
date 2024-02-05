import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
export 'package:image_picker/image_picker.dart';


class ImgPicker {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage({required ImageSource source}) async {
    try {
      final pickedFile = await _picker.pickImage(source: source,imageQuality: 50);
      if (pickedFile == null) return null;
      final image = File(pickedFile.path);
      return image;
    } on PlatformException catch (e) {
      log(e.toString());
      return null;
    } catch (e){
      return null;
    }
  }
}
