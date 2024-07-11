import 'package:video_player/video_player.dart';

import '../song_model.dart';

class MusicState{

  VideoPlayerController? controller;
  List<SongModel>? listSongs;
  int? index;
  String? text;
  MusicState({ this.controller, this.listSongs, this.index, this.text});
}
class LoadedMusicState extends MusicState{
  LoadedMusicState({super.controller, super.listSongs, super.index, super.text});
}
class LoadingMusicState extends MusicState{}