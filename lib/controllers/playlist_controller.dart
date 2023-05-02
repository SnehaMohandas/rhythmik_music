import 'package:get/get.dart';
import 'package:on_audio_room/on_audio_room.dart';

class PlaylistController extends GetxController {
  List<String> playListNameList = [];
  OnAudioRoom audioRoom = OnAudioRoom();

  createPlaylistName(value) {
    audioRoom.createPlaylist(value);
    update();
  }

  deletePlaylist(int playlistKey) {
    audioRoom.deletePlaylist(playlistKey);
    update();
  }
}
