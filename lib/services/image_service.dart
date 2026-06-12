import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<String?> pickImageAsBase64({int maxWidth = 1600, int quality = 85}) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth.toDouble(),
        imageQuality: quality,
      );
      if (file == null) return null;
      return await _fileToBase64(file);
    } catch (e) {
      if (kDebugMode) debugPrint('pickImage error: $e');
      return null;
    }
  }

  Future<String?> takePhotoAsBase64({int maxWidth = 1600, int quality = 85}) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth.toDouble(),
        imageQuality: quality,
      );
      if (file == null) return null;
      return await _fileToBase64(file);
    } catch (e) {
      if (kDebugMode) debugPrint('takePhoto error: $e');
      return null;
    }
  }

  Future<String> _fileToBase64(XFile file) async {
    final bytes = await File(file.path).readAsBytes();
    return 'data:image/${_ext(file.path)};base64,${base64Encode(bytes)}';
  }

  String _ext(String path) {
    final dot = path.lastIndexOf('.');
    if (dot < 0) return 'jpeg';
    return path.substring(dot + 1).toLowerCase();
  }

  static Uint8List base64ToBytes(String dataUri) {
    final comma = dataUri.indexOf(',');
    final raw = comma >= 0 ? dataUri.substring(comma + 1) : dataUri;
    return base64Decode(raw);
  }
}
