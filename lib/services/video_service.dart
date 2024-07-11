import 'dart:developer';

import 'package:video_player/video_player.dart';

class VideoService {
  VideoPlayerController? _videoController;

  VideoPlayerController? get videoController => _videoController;

  VideoPlayerController? initialize(String path) {
    try {
      _videoController = VideoPlayerController.asset(path)..initialize();
      return _videoController;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  VideoPlayerController? changeSong(String path) {
    try {
     // print("goi vao day");
      _videoController = VideoPlayerController.asset(path)..initialize();

      return _videoController;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
