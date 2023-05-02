import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/favorites/favorites_entity.dart';
import 'package:on_audio_room/details/rooms/song_entity.dart';
import 'package:rhythmik_music_player/controllers/player_controller.dart';
import 'package:rhythmik_music_player/views/base_screen.dart';

class PlayerScreen extends StatelessWidget {
  final audioQuery = OnAudioQuery();

  final List<SongModel>? data;
  final List<FavoritesEntity>? favs;
  List<SongEntity>? playlistSongs;

  final audioPlayer = AudioPlayer();
  PlayerScreen({
    super.key,
    this.data,
    this.favs,
    this.playlistSongs,
  });

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 104, 61, 104),
          Color.fromARGB(255, 5, 1, 48),
          Color.fromARGB(255, 104, 61, 104),
        ],
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.offAll(
                    () => BaseScreen(
                          data: data == null ? null : data,
                          favs: favs == null ? null : favs,
                          playlistSongs:
                              playlistSongs == null ? null : playlistSongs,
                          dataIndex: data == null
                              ? null
                              : data![controller.playIndex.value].title,
                          favsIndex: favs == null
                              ? null
                              : favs![controller.favPlayIndex.value].title,
                          playlistSongIndex: playlistSongs == null
                              ? null
                              : playlistSongs![
                                      controller.playlistPlayIndex.value]
                                  .title,
                        ),
                    transition: Transition.upToDown);

                controller.miniplayer(true);
              },
              icon: Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    height: 200,
                    width: 200,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: QueryArtworkWidget(
                      artworkQuality: FilterQuality.medium,
                      id: controller.isAllsongOpen.value
                          ? data![controller.playIndex.value].id
                          : controller.isFavOpen.value
                              ? favs![controller.favPlayIndex.value].id
                              : playlistSongs![
                                      controller.playlistPlayIndex.value]
                                  .id,
                      type: ArtworkType.AUDIO,
                      artworkHeight: double.infinity,
                      artworkWidth: double.infinity,
                      nullArtworkWidget: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                          image: const DecorationImage(
                            image: AssetImage('assets/images/music_icon.png'),
                            fit: BoxFit.cover,
                          ),
                          // borderRadius: BorderRadius.circular(7),
                        ),
                        width: MediaQuery.of(context).size.width * 0.47,
                        height: MediaQuery.of(context).size.height * 0.50,
                      ),
                    )),
              ),
              SizedBox(
                height: 50,
              ),
              Obx(
                () => Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "${controller.isAllsongOpen.value ? data![controller.playIndex.value].title : controller.isFavOpen.value ? favs![controller.favPlayIndex.value].title : playlistSongs![controller.playlistPlayIndex.value].title}",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${controller.isAllsongOpen.value ? data![controller.playIndex.value].artist.toString() : controller.isFavOpen.value ? favs![controller.favPlayIndex.value].artist.toString() : playlistSongs![controller.playlistPlayIndex.value].artist.toString()}",
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 163, 162, 168),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(
                          () => Column(
                            children: [
                              Slider(
                                min: Duration(seconds: 0).inSeconds.toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue) {
                                  controller.changeDuration(newValue.toInt());
                                  newValue = newValue;
                                },
                                thumbColor: Colors.pink,
                                activeColor: Colors.pink,
                                inactiveColor:
                                    Color.fromARGB(255, 146, 139, 139),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.position.value,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 197, 195, 204),
                                          fontSize: 13),
                                    ),
                                    Text(
                                      controller.duration.value,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 197, 195, 204),
                                          fontSize: 13),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                if (controller.isAllsongOpen.value) {
                                  if (controller.playIndex.value - 1 == -1) {
                                    controller.playSong(
                                        data![data!.length - 1].uri,
                                        data!.length - 1);
                                  } else {
                                    controller.playSong(
                                        data![controller.playIndex.value - 1]
                                            .uri,
                                        controller.playIndex.value - 1);
                                  }
                                } else if (controller.isFavOpen.value) {
                                  if (controller.favPlayIndex.value - 1 == -1) {
                                    controller.favSongplay(
                                        favs![favs!.length - 1].lastData,
                                        favs!.length - 1);
                                  } else {
                                    controller.favSongplay(
                                        favs![controller.favPlayIndex.value - 1]
                                            .lastData,
                                        controller.favPlayIndex.value - 1);
                                  }
                                } else {
                                  if (controller.playlistPlayIndex.value - 1 ==
                                      -1) {
                                    controller.playlistsongPlay(
                                        playlistSongs![
                                                playlistSongs!.length - 1]
                                            .lastData,
                                        playlistSongs!.length - 1);
                                  } else {
                                    controller.playlistsongPlay(
                                        playlistSongs![controller
                                                    .playlistPlayIndex.value -
                                                1]
                                            .lastData,
                                        controller.playlistPlayIndex.value - 1);
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.skip_previous_rounded,
                                color: Colors.white,
                              ),
                              iconSize: 36,
                            ),
                            Obx(
                              () => Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    color: Colors.transparent),
                                child: Transform.scale(
                                  scale: 1,
                                  child: IconButton(
                                    onPressed: () {
                                      if (controller.isPlaying.value) {
                                        controller.audioPlayer.pause();
                                        controller.isPlaying(false);
                                      } else {
                                        controller.audioPlayer.play();
                                        controller.isPlaying(true);
                                      }
                                    },
                                    icon: controller.isPlaying.value
                                        ? Icon(Icons.pause, color: Colors.white)
                                        : Icon(Icons.play_arrow_rounded,
                                            color: Colors.white),
                                    iconSize: 39,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (controller.isAllsongOpen.value) {
                                  if (controller.playIndex.value + 1 ==
                                      data!.length) {
                                    controller.playSong(data![0].uri, 0);
                                  } else {
                                    controller.playSong(
                                        data![controller.playIndex.value + 1]
                                            .uri,
                                        controller.playIndex.value + 1);
                                  }
                                } else if (controller.isFavOpen.value) {
                                  if (controller.favPlayIndex.value + 1 ==
                                      favs!.length) {
                                    controller.favSongplay(
                                        favs![0].lastData, 0);
                                  } else {
                                    controller.favSongplay(
                                        favs![controller.favPlayIndex.value + 1]
                                            .lastData,
                                        controller.favPlayIndex.value + 1);
                                  }
                                } else {
                                  if (controller.playlistPlayIndex.value + 1 ==
                                      playlistSongs!.length) {
                                    controller.playlistsongPlay(
                                        playlistSongs![0].lastData, 0);
                                  } else {
                                    controller.playlistsongPlay(
                                        playlistSongs![controller
                                                    .playlistPlayIndex.value +
                                                1]
                                            .lastData,
                                        controller.playlistPlayIndex.value + 1);
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.skip_next_rounded,
                                color: Colors.white,
                              ),
                              iconSize: 36,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
