import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Drawer/drawer.dart';
import '../common/theme.dart';
import '../common/widgets/button_common.dart';
import 'ont_model.dart';

class ExcelPage extends StatelessWidget {
  const ExcelPage({super.key});

// ignore: depend_on_referenced_packages

  ///To save the Excel file in the device
  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    //Get the storage folder location using path_provider package.
    String? path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      final Directory directory =
          await path_provider.getApplicationSupportDirectory();
      path = directory.path;
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }
    final File file =
        File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    if (Platform.isAndroid || Platform.isIOS) {
      //Launch the file (used open_file package)
      await open_file.OpenFile.open('$path/$fileName');
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'],
          runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'],
          runInShell: true);
    }
  }

  Future<void> mainFn(List<String>? args) async {
    //đọc file vào
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    File? file;
    if (result != null) {
      // File
      file = File(result.files.single.path!);
      print("dia chi$file.path");
    } else {
      // User canceled the picker
    }

    //var file = "/Users/kawal/Desktop/excel/test/test_resources/example.xlsx";
    var bytes = File(file!.path).readAsBytesSync();
    var excel2 = Excel.decodeBytes(bytes);
    //het đọc file, tự tạo file
    var excel = Excel.createExcel();

    ///
    /// Change sheet from rtl to ltr and vice-versa i.e. (right-to-left -> left-to-right and vice-versa)
    ///
    //   var sheet1rtl = excel['Sheet1'].isRTL;
    // tạo sheet 1
    excel['Sheet1'].isRTL = false;
    // print(
    //      'Sheet1: ((previous) isRTL: $sheet1rtl) ---> ((current) isRTL: ${excel['Sheet1'].isRTL})');
    // tạo sheet 2
    //  var sheet2rtl = excel['Sheet2'].isRTL;
    excel['Sheet2'].isRTL = true;
    //  print(
    //       'Sheet2: ((previous) isRTL: $sheet2rtl) ---> ((current) isRTL: ${excel['Sheet2'].isRTL})');

    ///
    ///
    /// declaring a cellStyle object
    ///
    ///
    CellStyle cellStyle = CellStyle(
      bold: true,
      italic: true,
      textWrapping: TextWrapping.WrapText,
      fontFamily: getFontFamily(FontFamily.Comic_Sans_MS),
      rotation: 0,
    );

    var sheet = excel['mySheet'];
    // or
    int totalRow = 0;
    OntModel
        ontModel; //=OntModel(ontId1: ontId1, ontId2: ontId2, serialNumber: serialNumber, ontLineProfileId: ontLineProfileId, ontSrvProfileId: ontSrvProfileId, vlanId: vlanId, vlanId2: vlanId2, vlanId3: vlanId3, password: password, username: username, portRoute: portRoute);
    for (var table in excel2.tables.keys) {
      for (var row in excel2.tables[table]!.rows) {
        totalRow++;
        if (totalRow > 1) {
          //print("${row.map((e) => e?.value)}");
          String ontId1 = row[0]!.value.toString();
          String ontId2 = row[1]!.value.toString();
          String snId = row[2]!.value.toString();
          String ontLineProfileId = row[3]!.value.toString();
          String ontSrvProfileId = row[4]!.value.toString();
          String vlanId = row[5]!.value.toString();
          String vlanId2 = row[6]!.value.toString();
          String vlanId3 = row[7]!.value.toString();
          String username = row[8]!.value.toString();
          String password = row[9]!.value.toString();
          String portRoute = row[10]!.value.toString();

          //chua có trong danh sách lớp --> chua có trong list

          ontModel = OntModel(
              ontId1: ontId1,
              ontId2: ontId2,
              serialNumber: snId,
              ontLineProfileId: ontLineProfileId,
              ontSrvProfileId: ontSrvProfileId,
              vlanId: vlanId,
              vlanId2: vlanId2,
              vlanId3: vlanId3,
              password: password,
              username: username,
              portRoute: portRoute);
          String line1 =
              "ont add ${ontModel.ontId1} ${ontModel.ontId2} sn-auth ${ontModel.serialNumber} omci ont-lineprofile-id ${ontModel.ontLineProfileId} ont-srvprofile-id ${ontModel.ontSrvProfileId} desc ONT_NO_DESCRIPTION";
          line1 =
              "$line1\n ont ipconfig $ontId1 $ontId2 dhcp vlan $vlanId priority 3";
          line1 =
              "$line1\n ont ipconfig $ontId1 $ontId2 ip-index 1 pppoe vlan $vlanId2 priority 0 user-account username $username password $password";
          line1 = "$line1\n ont internet-config $ontId1 $ontId2 ip-index 1";
          line1 =
              "$line1\n ont wan-config $ontId1 $ontId2 ip-index 1 profile-id 0";
          line1 =
              "$line1\n ont port route $ontId1 $portRoute eth 1 enable \n ont port route $ontId1 $portRoute eth 2 enable \n ont port route $ontId1 $portRoute eth 3 enable    \n ont port route $ontId1 $portRoute eth 4 enable";

          line1 =
              "$line1\n service-port vlan $vlanId3 gpon 0/1/14 ont $ontId2 gemport 3 multi-service user-vlan $vlanId3 tag-transform translate";
          line1 =
              "$line1\n service-port vlan $vlanId gpon 0/1/14 ont $ontId2 gemport 1 multi-service user-vlan $vlanId tag-transform translate";
          line1 =
              "$line1\n service-port vlan $vlanId2 gpon 0/1/14 ont $ontId2 gemport 3 multi-service user-vlan $vlanId2 tag-transform translate";
          var cell = sheet.cell(CellIndex.indexByString("A$totalRow"));
          cell.value = TextCellValue(line1);
          cell.cellStyle = cellStyle;
        }
      }
    }

    //var cell = sheet.cell(CellIndex.indexByString("A1"));

    // var cell2 = sheet.cell(CellIndex.indexByString("B1"));
    // cell2.value = const TextCellValue("Heya How night");
    // cell2.cellStyle = cellStyle;

    /// printing cell-type
    // print("CellType: " + switch(cell.value) {
    //   null => 'empty cell',
    //   TextCellValue() => 'text',
    //   FormulaCellValue() => 'formula',
    //   IntCellValue() => 'int',
    //   BoolCellValue() => 'bool',
    //   DoubleCellValue() => 'double',
    //   DateCellValue() => 'date',
    //   TimeCellValue => 'time',
    //   DateTimeCellValue => 'date with time',
    // });
    // print("CellType:
    // ${ switch (cell.value) {
    //       null => 'empty',
    //       TextCellValue() => 'text',
    //       FormulaCellValue() => 'Formula',
    //       IntCellValue() => 'int',
    //       DoubleCellValue() => 'double',
    //       DateCellValue() => 'date',
    //       DateTimeCellValue() => 'date+time',
    //       TimeCellValue() => 'time',
    //       BoolCellValue() => 'bool',
    //     }});

    ///
    ///
    /// Iterating and changing values to desired type
    ///
    ///
    // for (int row = 0; row < sheet.maxRows; row++) {
    //   sheet.row(row).forEach((Data? cell1) {
    //     if (cell1 != null) {
    //       cell1.value = const TextCellValue(' My custom Value ');
    //     }
    //   });
    // }

    excel.rename("mySheet", "myRenamedNewSheet");
    String outputFile = "r.xlsx";
    var directory = await path_provider.getApplicationDocumentsDirectory();
    //getExternalStorageDirectories(type: StorageDirectory.downloads);
    String path = "${directory.path}/$outputFile";
//    String path ="$directory/$outputFile";
    List<int>? fileBytes = excel.save(fileName: outputFile);
    await saveAndLaunchFile(fileBytes!, 'Invoice.xlsx');
    var sheet1 = excel['Sheet1'];
    sheet1.cell(CellIndex.indexByString('A1')).value =
        const TextCellValue('Sheet1');

    /// fromSheet should exist in order to sucessfully copy the contents
    excel.copy('Sheet1', 'newlyCopied');

    var sheet2 = excel['newlyCopied'];
    sheet2.cell(CellIndex.indexByString('A1')).value =
        const TextCellValue('Newly Copied Sheet');

    /// renaming the sheet
    excel.rename('oldSheetName', 'newSheetName');

    /// deleting the sheet
    excel.delete('Sheet1');

    /// unlinking the sheet if any link function is used !!
    excel.unLink('sheet1');

    sheet = excel['sheet'];

    /// appending rows and checking the time complexity of it
    Stopwatch stopwatch = Stopwatch()..start();
    List<List<TextCellValue>> list = List.generate(
      9000,
      (index) => List.generate(20, (index1) => TextCellValue('$index $index1')),
    );

    //print('list creation executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    for (var row in list) {
      sheet.appendRow(row);
    }
    //print('appending executed in ${stopwatch.elapsed}');

    sheet.appendRow([const IntCellValue(8)]);
    bool isSet = excel.setDefaultSheet(sheet.sheetName);
    // isSet is bool which tells that whether the setting of default sheet is successful or not.
    if (isSet) {
      //print("${sheet.sheetName} is set to default sheet.");
    } else {
      //   print("Unable to set ${sheet.sheetName} to default sheet.");
    }

    var columnIterableSheet = excel['ColumnIterables'];

    var columnIterables = ['A', 'B', 'C', 'D', 'E'];
    int columnIndex = 0;

    for (var columnValue in columnIterables) {
      columnIterableSheet
          .cell(CellIndex.indexByColumnRow(
            rowIndex: columnIterableSheet.maxRows,
            columnIndex: columnIndex,
          ))
          .value = TextCellValue(columnValue);
    }

    // Saving the file

    //stopwatch.reset();
    //List<int>? fileBytes = excel.save();
    //print('saving executed in ${stopwatch.elapsed}');
    //  var directory = await getApplicationDocumentsDirectory();
    //  String path ="${directory.path}/$outputFile";
    // if (fileBytes != null) {
    //   File(join(path))
    //     ..createSync(recursive: true)
    //     ..writeAsBytesSync(fileBytes);
    //   print("da ghi$path");
    // }
    PermissionStatus status = await Permission.storage.request();
    if ((fileBytes != null) && (status == PermissionStatus.granted)) {
      await File(path).writeAsBytes(fileBytes, flush: true).then((value) {
        log('saved');
      });
    } else if (status == PermissionStatus.denied) {
      log('Denied. Show a dialog with a reason and again ask for the permission.');
    } else if (status == PermissionStatus.permanentlyDenied) {
      log('Take the user to the settings page.');
    }

    await OpenFile.open(path);
    Uri fileUri = Uri.parse(path);
    if (await canLaunchUrl(fileUri)) {
      await launchUrl(fileUri);
      //  await launchUrlString(path);
    } else {
      throw 'Could not open file';
    }
    // if (fileBytes != null) {
    //   File(join(outputFile))
    //     ..createSync(recursive: true)
    //     ..writeAsBytesSync(fileBytes);
    // }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Time Table"),
          backgroundColor: appTheme.primaryColor,
        ),
        drawer: MyDrawer.provider(),
        body: OrientationBuilder(builder: (context, orientation) {
          return Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ButtonCommon(
                      label: 'Import Excel',
                      onTap: () {mainFn(["Hung"]);},
                      icon: Icons.upload_rounded,
                      color: appTheme.primaryColor,
                      padding: 8,
                    )
                  ],
                ),
              ],
            ),
          );
        }));
  }
}
