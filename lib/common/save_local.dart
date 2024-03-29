


import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
//import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class SaveLocal{
  String imagePath;
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }
  void setImagePath(String newImagePath){
    imagePath = newImagePath;
  }
  // Future<String> saveToLocal() async {
    // File originalFile             = File.fromUri(Uri(path: imagePath));
    // Uint8List imageBytes   = await originalFile.readAsBytes();
    // final img.Image? originalImage      = img.decodeImage(imageBytes)!;
    //
    // Uint8List imageBytesOrientated =img.encodeJpg(originalImage!);
    // String newURL = await _localPath +"/"+basename(imagePath);
    // File(newURL).writeAsBytes(imageBytesOrientated);
    // print("chụp anh"+newURL);
  //   String newURL="";
  //   return newURL;
  // }
  Future<String> saveToLocal() async {
    File originalFile             = File.fromUri(Uri(path: imagePath));
    Uint8List imageBytes   = await originalFile.readAsBytes();
    final img.Image originalImage      = img.decodeImage(imageBytes)!;

    List<int> imageBytesOrientated =img.encodeJpg(originalImage);
    String newURL = "${await _localPath}/${basename(imagePath)}";
    File(newURL).writeAsBytes(imageBytesOrientated);
   // print("chụp anh"+newURL);

    return newURL;
  }
  //Future<String> rotateImage() async {
    // File originalFile             = File.fromUri(Uri(path: imagePath));
    // Uint8List imageBytes   = await originalFile.readAsBytes();
    // final img.Image? originalImage      = img.decodeImage(imageBytes)!;
    // final img.Image orientedImage      = img.copyRotate(originalImage!, angle: 90);
    // Uint8List imageBytesOrientated =img.encodeJpg(orientedImage);
    //
    // var rng = Random();
    // String newURL = await _localPath+rng.nextInt(1000).toString();
    // File(newURL).writeAsBytes(imageBytesOrientated);
    // setImagePath(newURL);
    // print("da xoay anh"+imagePath);
  //   String newURL=" ";
  //   return newURL;
  //
  //
  // }
  Future<String> rotateImage() async {
    File originalFile             = File.fromUri(Uri(path: imagePath));
    Uint8List imageBytes   = await originalFile.readAsBytes();
    final img.Image originalImage      = img.decodeImage(imageBytes)!;
    final img.Image orientedImage      = img.copyRotate(originalImage,  90);//,interpolation:Interpolation.linear);
    List<int> imageBytesOrientated =img.encodeJpg(orientedImage);

    var rng = Random();
    String newURL = await _localPath+rng.nextInt(1000).toString();
    File(newURL).writeAsBytes(imageBytesOrientated);
    setImagePath(newURL);
    //print("da xoay anh"+imagePath);

    return newURL;


  }

  SaveLocal(this.imagePath);

// Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/counter.txt');
  // }
  // Future<int> readCounter() async {
  //   try {
  //     final file = await _localFile;
  //
  //     // Read the file
  //     final contents = await file.readAsString();
  //
  //     return int.parse(contents);
  //   } catch (e) {
  //     // If encountering an error, return 0
  //     return 0;
  //   }
  // }
  // Future<File> writeCounter(int counter) async {
  //   final file = await _localFile;
  //
  //   // Write the file
  //   return file.writeAsString('$counter');
  // }

}