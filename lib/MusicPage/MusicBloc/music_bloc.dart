import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

import '../../services/video_service.dart';
import '../song_model.dart';
import 'music_event.dart';
import 'music_state.dart';

List<SongModel> listSongs2 = [];
VideoService videoService2 = VideoService();
VideoPlayerController? controller;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    //print("da tắt");
    service.stopSelf();
  });
  service.on('startService').listen((event) {
    //print("da tắt");
    controller = videoService2.initialize(listSongs2[event?["index"]].path!);
    controller!.play();
  });
  service.on('changeSong').listen((event) {
    if (controller!.value.isPlaying) {
      controller?.pause();
      controller?.dispose();
    }
    controller = videoService2.initialize(listSongs2[event?["index"]].path!);
    controller!.play();
  });

  //listSongs2.add(SongModel(name: "Trọng Tấn", path: "assets/videos/ttat.mp4"));
  listSongs2.add(SongModel(name: "Trần Tiến", path: "assets/videos/tt.mp4"));
 // listSongs2.add(SongModel(name: "Đàm Vĩnh Hưng", path: "assets/videos/dvh.mp4"));
}

Future<void> initializeService() async {
  //  print("chuan bi khoi tao service");
  final service = FlutterBackgroundService();

  try {
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will be executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,

        //notificationChannelId: 'my_foreground',
        // initialNotificationTitle: 'AWESOME SERVICE',
        //initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will be executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
  } catch (e) {
    // print(e.toString());
  }
  //  print("da khoi tao service");
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  return true;
}

class MusicBloc extends Bloc<MusicEvent, MusicState> {
  MusicBloc() : super(MusicState()) {
    on<MusicEventChange>((event, emit) async {
      emit(LoadingMusicState());
      change();
      emit(LoadedMusicState(controller: controller, listSongs: listSongs));
    });
    on<MusicEventChangeSong>((event, emit) async {
      emit(LoadingMusicState());
      index = event.index!;
      changeSongUseService(index: index);
      if (kDebugMode) {
        print(" da doi trang thai$index");
      }
      service.invoke("changeSong", {"index": index});
      emit(LoadedMusicState(
          controller: controller, listSongs: listSongs, index: index));
    });
    on<MusicEventLoading>((event, emit) async {
      emit(LoadingMusicState());
      await initializeService();
      await init();
      service.invoke("startService", {"index": index});
      emit(LoadedMusicState(controller: controller, listSongs: listSongs));
    });

    on<MusicEventStopService>((event, emit) async {
      emit(LoadingMusicState());
      stopService();
      emit(LoadedMusicState(controller: controller, listSongs: listSongs));
    });
  }

  static List<SongModel> listSongs = [];
  static VideoPlayerController? controller;
  static final service = FlutterBackgroundService();

  static int index = 0;

  static VideoService videoService = VideoService();

  static const notificationChannelId = 'my_foreground';

// this will be used for notification id, So you can update your custom notification with this id.
  static const notificationId = 888;

  Future<void> init() async {
    listSongs = [];
    index = 0;
  //  listSongs.add(SongModel(name: "Trọng Tấn", path: "assets/videos/ttat.mp4"));
    listSongs.add(SongModel(name: "Trần Tiến", path: "assets/videos/tt.mp4"));
  //  listSongs.add(SongModel(name: "Đàm Vĩnh Hưng", path: "assets/videos/dvh.mp4"));

    controller = videoService.initialize(listSongs[index].path!);
  }

  void change() {
    controller!.value.isPlaying ? controller!.pause() : controller!.play();
  }

  void changeSongUseService({required int index}) {
    try {
      controller?.pause();
      controller?.dispose();

      controller = videoService.initialize(listSongs[index].path!);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<void> stopService() async {
    bool isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke("stopService");
    }
  }
}
