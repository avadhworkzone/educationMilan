import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

// Future<File?> compressFile(File file) async {
//   try {
//     Uint8List uint8list = await file.readAsBytes();
//     final tempDir = await getTemporaryDirectory();
//     print(
//         'before Compress Size file: ${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB');
//     print(
//         'before Compress Size: ${(uint8list.length / (1024 * 1024)).toStringAsFixed(2)} MB');
//     print('before Compress Size file :${file.lengthSync()}');
//     print('before Compress Size :${uint8list.length}');
//     final extension = file.path.substring(file.path.lastIndexOf('.') + 1);
//     final result = await FlutterImageCompress.compressAndGetFile(file.path,
//         '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}.$extension',
//         quality: 25, format: CompressFormat.jpeg);
//     final compressedSize = File(result!.path).lengthSync();
//     // print('after Compress Size :${File(result!.path).lengthSync()}');
//     print(
//         'after Compress Size: ${(compressedSize / (1024 * 1024)).toStringAsFixed(2)} MB');
//     return File(result.path);
//   } on Exception catch (e) {
//     return null;
//   }
// }

// class FileAndSize {
//   final File file;
//   final int size;
//
//   FileAndSize(this.file, this.size);
// }
//
// Future<FileAndSize?> compressFile(XFile xFile) async {
//   try {
//     File file = File(xFile.path);
//
//     Uint8List uint8list = await file.readAsBytes();
//     final tempDir = await getTemporaryDirectory();
//     print(
//         'before Compress Size file: ${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB');
//     print(
//         'before Compress Size: ${(uint8list.length / (1024 * 1024)).toStringAsFixed(2)} MB');
//
//     final extension = file.path.substring(file.path.lastIndexOf('.') + 1);
//     final result = await FlutterImageCompress.compressAndGetFile(
//       file.path,
//       '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}.$extension',
//       quality: 80,
//       format: CompressFormat.jpeg,
//     );
//
//     if (result != null) {
//       final compressedSize = File(result.path).lengthSync();
//       print(
//           'after Compress Size: ${(compressedSize / (1024 * 1024)).toStringAsFixed(2)} MB');
//       return FileAndSize(result, compressedSize);
//     } else {
//       return null;
//     }
//   } catch (e) {
//     print('Compression error: $e');
//     return null;
//   }
// }
Future<File?> compressFile(File file) async {
  try {
    Uint8List uint8list = await file.readAsBytes();
    final tempDir = await getTemporaryDirectory();
    print(
        'Before Compress Size file: ${(file.lengthSync() / (1024 * 1024)).toStringAsFixed(2)} MB');
    print(
        'Before Compress Size: ${(uint8list.length / (1024 * 1024)).toStringAsFixed(2)} MB');
    print('Before Compress Size file: ${file.lengthSync()}');
    print('Before Compress Size: ${uint8list.length}');
    print('file.path,: ${file.path}');

    final extension =
        file.path.split('.').last.toLowerCase(); // Get lowercased extension

    if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}.$extension',
        quality: 25,
        format: extension == 'png' ? CompressFormat.png : CompressFormat.jpeg,
      );

      if (result != null) {
        final compressedSize = File(result.path).lengthSync();
        print(
            'After Compress Size: ${(compressedSize / (1024 * 1024)).toStringAsFixed(2)} MB');
        return File(result.path);
      } else {
        return null;
      }
    } else {
      // Handle other image formats or show an error message
      print(
          'Unsupported image format. Please select a JPG, JPEG, or PNG image.');
      return null;
    }
  } on Exception catch (e) {
    print('Compression error: $e');
    return null;
  }
}
