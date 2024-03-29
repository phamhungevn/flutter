import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ML2Service{
  Interpreter? _interpreter;
  Future initialize() async {
    late Delegate delegate;
    try {
      if (Platform.isAndroid) {
        delegate = GpuDelegateV2(
          options: GpuDelegateOptionsV2(
            isPrecisionLossAllowed: false,
          ),
        );
      } else if (Platform.isIOS) {
        delegate = GpuDelegate(
          options: GpuDelegateOptions(
            allowPrecisionLoss: true,
          ),
        );
      }

      var interpreterOptions = InterpreterOptions()..addDelegate(delegate);
      //  print("interpreter kiem tra null");
      for (int i = 0; i < 5; i++) {
        _interpreter = await Interpreter.fromAsset(
            'assets/model.tflite',
            options: interpreterOptions);

        if (_interpreter != null) {
          break;
        }
        //      else {
        // if (kDebugMode) {
        //     print("interpreter bi null lan ${i}");
        // }
        //   }
      }
    } catch (e) {
      if (kDebugMode) {
        //    print('Failed to load model.');
      }
      if (kDebugMode) {
        // log(e);
      }
    }
  }
}