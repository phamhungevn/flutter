abstract class MusicEvent{}
class MusicEventUploadImage extends MusicEvent{}
class MusicEventLoading extends MusicEvent{}
class MusicEventChange extends MusicEvent{}
class MusicEventStartService extends MusicEvent{}
class MusicEventStopService extends MusicEvent{}
class MusicEventChangeSong extends MusicEvent{
  int? index;

  MusicEventChangeSong({this.index});
}