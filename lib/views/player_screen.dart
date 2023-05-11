import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/favorites/favorites_entity.dart';
import 'package:on_audio_room/details/rooms/song_entity.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:rhythmik_music_player/controllers/favourite_controller.dart';
import 'package:rhythmik_music_player/controllers/player_controller.dart';
import 'package:rhythmik_music_player/views/base_screen.dart';

class PlayerScreen extends StatelessWidget {
  final audioQuery = OnAudioQuery();
  OnAudioRoom audioRoom = OnAudioRoom();

  final List<SongModel>? data;
  final List<FavoritesEntity>? favs;
  List<SongEntity>? playlistSongs;

  final audioPlayer = AudioPlayer();
  PlayerScreen({super.key, this.data, this.favs, this.playlistSongs});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PlayerController>();
    var favController = Get.find<FavouriteController>();
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: [
          Color.fromARGB(255, 35, 58, 78),
          Color.fromARGB(255, 133, 88, 153),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 50,
          centerTitle: true,
          title: const Text(
            "Now Playing",
            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 24),
          ),
          leading: IconButton(
              onPressed: () {
                Get.offAll(
                    () => BaseScreen(
                          data: data == null ? null : data,
                          favs: favs == null ? null : favs,
                          playlistSongs:
                              playlistSongs == null ? null : playlistSongs,
                          dataTitle: data == null
                              ? null
                              : data![controller.playIndex.value].title,
                          favsTitle: favs == null
                              ? null
                              : favs![controller.favPlayIndex.value].title,
                          playlistSongTitle: playlistSongs == null
                              ? null
                              : playlistSongs![
                                      controller.playlistPlayIndex.value]
                                  .title,
                        ),
                    transition: Transition.upToDown);

                controller.miniplayer(true);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 65,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 35, 58, 78),
                          Color.fromARGB(255, 133, 88, 153),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                  height: 500,
                  width: 350,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            height: 180,
                            width: 180,
                            decoration:
                                const BoxDecoration(shape: BoxShape.rectangle),
                            alignment: Alignment.center,
                            child: QueryArtworkWidget(
                              artworkQuality: FilterQuality.medium,
                              id: controller.isAllsongOpen.value
                                  ? data![controller.playIndex.value].id
                                  : controller.isFavOpen.value
                                      ? favs![controller.favPlayIndex.value].id
                                      : controller.isPlaylistOpen.value
                                          ? playlistSongs![controller
                                                  .playlistPlayIndex.value]
                                              .id
                                          : data![controller.playIndex.value]
                                              .id,
                              type: ArtworkType.AUDIO,
                              artworkHeight: double.infinity,
                              artworkWidth: double.infinity,
                              nullArtworkWidget: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/music_icon.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                height: 180,
                                width: 180,
                              ),
                            )),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                controller.isAllsongOpen.value
                                    ? data![controller.playIndex.value].title
                                    : controller.isFavOpen.value
                                        ? favs![controller.favPlayIndex.value]
                                            .title
                                        : controller.isPlaylistOpen.value
                                            ? playlistSongs![controller
                                                    .playlistPlayIndex.value]
                                                .title
                                            : data![controller.playIndex.value]
                                                .title,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                controller.isAllsongOpen.value
                                    ? data![controller.playIndex.value]
                                        .artist
                                        .toString()
                                    : controller.isFavOpen.value
                                        ? favs![controller.favPlayIndex.value]
                                            .artist
                                            .toString()
                                        : controller.isPlaylistOpen.value
                                            ? playlistSongs![controller
                                                    .playlistPlayIndex.value]
                                                .artist
                                                .toString()
                                            : data![controller.playIndex.value]
                                                .artist
                                                .toString(),
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
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 2.5,
                                        activeTrackColor: Colors.white,
                                        thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 7),
                                        overlayShape:
                                            const RoundSliderOverlayShape(
                                                overlayRadius: 7),
                                      ),
                                      child: Slider(
                                        min: const Duration(seconds: 0)
                                            .inSeconds
                                            .toDouble(),
                                        max: controller.max.value,
                                        value: controller.value.value,
                                        onChanged: (newValue) {
                                          controller
                                              .changeDuration(newValue.toInt());
                                          newValue = newValue;
                                        },
                                        thumbColor: const Color.fromARGB(
                                            255, 135, 141, 207),
                                        activeColor: const Color.fromARGB(
                                            255, 135, 141, 207),
                                        inactiveColor: const Color.fromARGB(
                                            255, 146, 139, 139),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (controller.isAllsongOpen.value) {
                                        if (controller.playIndex.value - 1 ==
                                            -1) {
                                          controller.playSong(
                                              data![data!.length - 1].uri,
                                              data!.length - 1);
                                        } else {
                                          controller.playSong(
                                              data![controller.playIndex.value -
                                                      1]
                                                  .uri,
                                              controller.playIndex.value - 1);
                                        }
                                      } else if (controller.isFavOpen.value) {
                                        if (controller.favPlayIndex.value - 1 ==
                                            -1) {
                                          controller.favSongplay(
                                              favs![favs!.length - 1].lastData,
                                              favs!.length - 1);
                                        } else {
                                          controller.favSongplay(
                                              favs![controller
                                                          .favPlayIndex.value -
                                                      1]
                                                  .lastData,
                                              controller.favPlayIndex.value -
                                                  1);
                                        }
                                      } else if (controller
                                          .isPlaylistOpen.value) {
                                        if (controller.playlistPlayIndex.value -
                                                1 ==
                                            -1) {
                                          controller.playlistsongPlay(
                                              playlistSongs![
                                                      playlistSongs!.length - 1]
                                                  .lastData,
                                              playlistSongs!.length - 1);
                                        } else {
                                          controller.playlistsongPlay(
                                              playlistSongs![controller
                                                          .playlistPlayIndex
                                                          .value -
                                                      1]
                                                  .lastData,
                                              controller
                                                      .playlistPlayIndex.value -
                                                  1);
                                        }
                                      } else {
                                        if (controller.playIndex.value - 1 ==
                                            -1) {
                                          controller.playSong(
                                              data![data!.length - 1].uri,
                                              data!.length - 1);
                                        } else {
                                          controller.playSong(
                                              data![controller.playIndex.value -
                                                      1]
                                                  .uri,
                                              controller.playIndex.value - 1);
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
                                              ? const Icon(Icons.pause,
                                                  color: Colors.white)
                                              : const Icon(
                                                  Icons.play_arrow_rounded,
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
                                              data![controller.playIndex.value +
                                                      1]
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
                                              favs![controller
                                                          .favPlayIndex.value +
                                                      1]
                                                  .lastData,
                                              controller.favPlayIndex.value +
                                                  1);
                                        }
                                      } else if (controller
                                          .isPlaylistOpen.value) {
                                        if (controller.playlistPlayIndex.value +
                                                1 ==
                                            playlistSongs!.length) {
                                          controller.playlistsongPlay(
                                              playlistSongs![0].lastData, 0);
                                        } else {
                                          controller.playlistsongPlay(
                                              playlistSongs![controller
                                                          .playlistPlayIndex
                                                          .value +
                                                      1]
                                                  .lastData,
                                              controller
                                                      .playlistPlayIndex.value +
                                                  1);
                                        }
                                      } else {
                                        if (controller.playIndex.value + 1 ==
                                            data!.length) {
                                          controller.playSong(data![0].uri, 0);
                                        } else {
                                          controller.playSong(
                                              data![controller.playIndex.value +
                                                      1]
                                                  .uri,
                                              controller.playIndex.value + 1);
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
