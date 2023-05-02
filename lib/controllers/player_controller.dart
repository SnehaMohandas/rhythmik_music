import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  var hasPermission = false.obs;
  var shouldMiniPlayerBeVisible = false.obs;

  final audioPlayer = AudioPlayer();
  var playIndex = 0.obs;
  var isPlaying = false.obs;
  var duration = "".obs;
  var position = "".obs;
  var max = 0.0.obs;
  var value = 0.0.obs;
  var isCompleted = false.obs;
  var favPlayIndex = 0.obs;
  var playlistPlayIndex = 0.obs;
  var miniplayer = false.obs;
  var isAllsongMiniPlayer = false.obs;
  var isFavsongMiniPlayer = false.obs;

  var isPlaylistsongMiniPlayer = false.obs;

  var isAllsongOpen = false.obs;
  var isFavOpen = false.obs;
  var isPlaylistOpen = false.obs;

  @override
  void onInit() {
    checkAndRequestPermissions();

    super.onInit();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    hasPermission.value = (await audioQuery.checkAndRequest(
      retryRequest: retry,
    ));
  }

  playSong(String? uri, index) {
    playIndex.value = index;
    try {
      audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      audioPlayer.play();
      isPlaying(true);
      miniPlayeropn();

      updatePosition();
      isAudioCompleted();
    } catch (e) {
      print(e.toString());
    }
  }

  favSongplay(String path, index) async {
    favPlayIndex.value = await index;
    try {
      audioPlayer.setAudioSource(AudioSource.file(path));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
      isAudioCompleted();
    } catch (e) {
      print(e.toString());
    }
  }

  playlistsongPlay(String path, index) async {
    playlistPlayIndex.value = await index;
    try {
      audioPlayer.setAudioSource(AudioSource.file(path));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
      isAudioCompleted();
    } catch (e) {
      print(e.toString());
    }
  }

  updatePosition() {
    audioPlayer.durationStream.listen((d) {
      duration.value = d.toString().split(".")[0];

      max.value = d!.inSeconds.toDouble();
    });

    audioPlayer.positionStream.listen((p) {
      position.value = p.toString().split(".")[0];

      value.value = p.inSeconds.toDouble();
    });
  }

  changeDuration(seconds) {
    var durations = Duration(seconds: seconds);
    audioPlayer.seek(durations);
  }

  isAudioCompleted() {
    audioPlayer.playerStateStream.listen((c) {
      isPlaying.value = c.playing;
      if (c.processingState == ProcessingState.completed) {
        isPlaying(false);
        audioPlayer.seek(Duration.zero);
        // audioPlayer.hasNext ? audioPlayer.seekToNext() : audioPlayer.stop();
        isCompleted(true);
        audioPlayer.stop();
      }
    });
  }

  miniPlayeropn() {
    audioPlayer.playerStateStream.listen((event) {
      if (event.playing) {
      } else {
        shouldMiniPlayerBeVisible(false);
      }
    });
  }
}
