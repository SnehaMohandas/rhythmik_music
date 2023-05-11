import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayerController extends GetxController {
  final audioQuery = OnAudioQuery();
  var hasPermission = false.obs;

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

  var isAllsongOpen = false.obs;
  var isFavOpen = false.obs;
  var isPlaylistOpen = false.obs;

  bool changingGridview = true;

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

      updatePosition();
      isAudioCompleted();
    } catch (e) {}
  }

  favSongplay(String path, index) async {
    favPlayIndex.value = await index;
    try {
      audioPlayer.setAudioSource(AudioSource.file(path));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
      isAudioCompleted();
    } catch (e) {}
  }

  playlistsongPlay(String path, index) async {
    playlistPlayIndex.value = await index;
    try {
      audioPlayer.setAudioSource(AudioSource.file(path));
      audioPlayer.play();
      isPlaying(true);
      updatePosition();
      isAudioCompleted();
    } catch (e) {}
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
        isCompleted(true);
        audioPlayer.stop();
      }
    });
  }

  changeHomeBody() {
    changingGridview = !changingGridview;

    update();
  }
}
