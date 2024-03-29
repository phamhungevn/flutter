import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';



class DocumentScan extends StatefulWidget {
  const DocumentScan({Key? key}) : super(key: key);

  @override
  State<DocumentScan> createState() => _DocumentScanState();
}

class _DocumentScanState extends State<DocumentScan> {
  List<String> _pictures = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Your documents'),
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ElevatedButton(
                onPressed: onPressed, child: const Text("Add Pictures")),
            for (var picture in _pictures) Image.file(File(picture))
          ],
        )),
      ),
    );
  }

  void onPressed() async {
    List<String> pictures;
    try {
      log("vao day scan 1");
      pictures = await CunningDocumentScanner.getPictures(true) ?? [];
      log("vao day scan 3");
      if (!mounted) return;
      setState(() {
        _pictures = pictures;
      });
    } catch (exception) {
      log("vao day scan 2 ${exception.toString()}");
    }
  }
}
