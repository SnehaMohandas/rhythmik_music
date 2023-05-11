import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/details/rooms/favorites/favorites_entity.dart';
import 'package:on_audio_room/details/rooms/song_entity.dart';
import 'package:rhythmik_music_player/controllers/player_controller.dart';
import 'package:rhythmik_music_player/views/favourite.dart';
import 'package:rhythmik_music_player/views/home.dart';
import 'package:rhythmik_music_player/views/player_screen.dart';
import 'package:rhythmik_music_player/views/playlist.dart';
import 'package:rhythmik_music_player/views/settings.dart';

class BaseScreen extends StatelessWidget {
  final List<SongModel>? data;
  final List<FavoritesEntity>? favs;

  List<SongEntity>? playlistSongs;
  String? dataTitle;
  String? favsTitle;
  String? playlistSongTitle;
  BaseScreen({
    super.key,
    this.data,
    this.favs,
    this.playlistSongs,
    this.dataTitle,
    this.favsTitle,
    this.playlistSongTitle,
  });
  static ValueNotifier<int> selectedIndexNotifier = ValueNotifier(0);

  final pages = [
    HomeScreen(),
    PlaylistScreen(),
    FavouriteScreen(),
    SettingsScreen()
  ];
  final audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    var playerController = Get.put(PlayerController());
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 1, 48),
      bottomNavigationBar: BottomNavigation(),
      body: SafeArea(
          child: Column(children: [
        Expanded(
          child: ValueListenableBuilder(
              valueListenable: selectedIndexNotifier,
              builder: (BuildContext ctx, int updatedIndex, Widget? _) {
                return pages[updatedIndex];
              }),
        ),
        Obx(() => playerController.miniplayer.value
            ? FutureBuilder(builder: (context, snapshot) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 5, 1, 48),
                        Color.fromARGB(255, 5, 1, 48),
                        Color.fromARGB(255, 71, 4, 71),
                      ],
                    ),
                  ),
                  height: 60,
                  child: Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          activeTrackColor: Colors.white,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 1.0),
                          overlayShape:
                              const RoundSliderOverlayShape(overlayRadius: 1),
                        ),
                        child: Obx(
                          () => Slider(
                            min:
                                const Duration(seconds: 0).inSeconds.toDouble(),
                            max: playerController.max.value,
                            value: playerController.value.value,
                            onChanged: (newValue) {
                              playerController.changeDuration(newValue.toInt());
                              newValue = newValue;
                            },
                            thumbColor:
                                const Color.fromARGB(255, 135, 141, 207),
                            activeColor:
                                const Color.fromARGB(255, 135, 141, 207),
                            inactiveColor:
                                const Color.fromARGB(255, 146, 139, 139),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Obx(
                            () => IconButton(
                              onPressed: () {
                                if (playerController.isPlaying.value) {
                                  playerController.audioPlayer.pause();
                                  playerController.isPlaying(false);
                                } else {
                                  playerController.audioPlayer.play();
                                  playerController.isPlaying(true);
                                }
                              },
                              icon: playerController.isPlaying.value
                                  ? const Icon(
                                      Icons.pause,
                                      color: Color.fromARGB(255, 223, 217, 217),
                                      size: 35,
                                    )
                                  : const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.white,
                                      size: 37,
                                    ),
                            ),
                          ),
                          title: Text(
                            playerController.isAllsongOpen.value
                                ? dataTitle.toString()
                                : playerController.isFavOpen.value
                                    ? favsTitle.toString()
                                    : playerController.isPlaylistOpen.value
                                        ? playlistSongTitle.toString()
                                        : dataTitle.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 241, 236, 236),
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                          ),
                          trailing: IconButton(
                              onPressed: () {
                                playerController.miniplayer(false);
                                playerController.audioPlayer.pause();
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Color.fromARGB(255, 223, 217, 217),
                                size: 20,
                              )),
                          onTap: () {
                            Get.to(
                                () => PlayerScreen(
                                      data: data == null ? null : data,
                                      favs: favs == null ? null : favs,
                                      playlistSongs: playlistSongs == null
                                          ? null
                                          : playlistSongs,
                                    ),
                                transition: Transition.downToUp);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              })
            : const Visibility(visible: false, child: Text("")))
      ])),
    );
  }

  Widget BottomNavigation() {
    return ValueListenableBuilder(
        valueListenable: BaseScreen.selectedIndexNotifier,
        builder: (BuildContext ctx, int udatedIndex, Widget? _) {
          return CurvedNavigationBar(
              height: 55,
              color: Colors.transparent,
              buttonBackgroundColor: Colors.pink,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 500),
              backgroundColor: const Color.fromARGB(255, 5, 1, 48),
              index: udatedIndex,
              onTap: (newIndex) {
                BaseScreen.selectedIndexNotifier.value = newIndex;
              },
              items: const [
                Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                Icon(
                  Icons.playlist_add,
                  color: Colors.white,
                ),
                Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
                Icon(
                  Icons.settings,
                  color: Colors.white,
                )
              ]);
        });
  }
}
