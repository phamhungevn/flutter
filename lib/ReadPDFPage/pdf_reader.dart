import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';

class PDFReader extends StatefulWidget {
  const PDFReader({super.key});

  @override
  PDFReaderExampleState createState() => PDFReaderExampleState();
}

// Example class for pdf text reader plugin
class PDFReaderExampleState extends State<PDFReader> {
  String _pdfText = '';
  List<String> _pdfList = [];
  int _pdfLength = 0;

  bool _loading = false;
  bool _paginated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Center(
              child: Text(
                "Pages : $_pdfLength",
              ),
            ),
          ),
        ],
        title: const Text('PDF Plugin example app'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );

                    if (result != null) {
                      // This example uses file picker to get the path
                      File file = File(result.files.single.path ?? "");
                      setState(() {
                        _loading = true;
                      });
                      // Call the function to parse text from pdf
                      getPDFtext(file.path).then((pdfText) {
                        final text = pdfText.replaceAll("\n", " ");
                        setState(() {
                          _pdfText = text;
                          _paginated = false;
                          _loading = false;
                        });
                      });
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: const Text("Get pdf text"),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      File file = File(result.files.single.path ?? "");
                      // This example uses file picker to get the path
                      setState(() {
                        _loading = true;
                      });
                      // Call the function to parse text from pdf
                      getPDFtextPaginated(file.path).then((pdfList) {
                        List<String> list = <String>[];
                        // Remove new lines
                        for (var element in pdfList) {
                          list.add(element.replaceAll("\n", " "));
                        }

                        setState(() {
                          _pdfList = list;
                          _paginated = true;
                          _loading = false;
                        });
                      });
                    }
                  },
                  child: const Text("Get pdf text paginated"),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      File file = File(result.files.single.path ?? "");
                      setState(() {
                        _loading = true;
                      });
                      // Call the function to parse text from pdf
                      getPDFlength(file.path).then((length) {
                        setState(() {
                          _pdfLength = length;

                          // Reset variables
                          _pdfList = [];
                          _pdfText = " ";
                          _loading = false;
                        });
                      });
                    }
                  },
                  child: const Text("Get document length (pages)"),
                ),
              ),
            ],
          ),
          _loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  // Check if returning text page by page or the whole document as one string
                  child: _paginated
                      ? ListView.builder(
                          itemCount: _pdfList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    _pdfList[index],
                                  ),
                                ),
                              ),
                            );
                          })
                      : SingleChildScrollView(
                          child: Text(_pdfText),
                        ),
                ),
        ],
      ),
    );
  }

  // Gets all the text from a PDF document, returns it in string.
  Future<String> getPDFtext(String path) async {
    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(path);
    } on PlatformException {
      log("Failed to get PDF text.");
    }
    return text;
  }

  // Gets all the text from PDF document, returns it in array where each element is a page of the document.
  Future<List<String>> getPDFtextPaginated(String path) async {
    List<String> textList = <String>[];
    try {
      textList = await ReadPdfText.getPDFtextPaginated(path);
    } on PlatformException {
      log("Failed to get PDF text.");
    }
    return textList;
  }

  // Gets the length of the PDF document.
  Future<int> getPDFlength(String path) async {
    int length = 0;
    try {
      length = await ReadPdfText.getPDFlength(path);
    } on PlatformException {
      log("Failed to get PDF text.");
    }
    return length;
  }
}
