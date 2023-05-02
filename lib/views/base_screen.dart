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
  String? dataIndex;
  String? favsIndex;
  String? playlistSongIndex;
  BaseScreen(
      {super.key,
      this.data,
      this.favs,
      this.playlistSongs,
      this.dataIndex,
      this.favsIndex,
      this.playlistSongIndex});
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
    var con = Get.put(PlayerController());
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 5, 1, 48),
                Color.fromARGB(255, 82, 3, 69),
                Color.fromARGB(255, 5, 1, 48),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [0.1, 0.5, 0.7])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
          Obx(() => con.miniplayer.value
              ? FutureBuilder(builder: (context, snapshot) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 192, 106, 135),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 57,
                    margin: EdgeInsets.only(
                      right: 20,
                      left: 20,
                    ),
                    child: ListTile(
                      leading: Obx(
                        () => IconButton(
                          onPressed: () {
                            if (con.isPlaying.value) {
                              con.audioPlayer.pause();
                              con.isPlaying(false);
                            } else {
                              con.audioPlayer.play();
                              con.isPlaying(true);
                            }
                          },
                          icon: con.isPlaying.value
                              ? Icon(Icons.pause, color: Colors.black)
                              : Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.black,
                                  size: 37,
                                ),
                        ),
                      ),
                      title: Text(
                        con.isAllsongOpen.value
                            ? dataIndex.toString()
                            : con.isFavOpen.value
                                ? favsIndex.toString()
                                : playlistSongIndex.toString(),
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            con.miniplayer(false);
                            con.audioPlayer.pause();
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.black,
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
                  );
                })
              : Visibility(visible: false, child: Text("")))
        ])),
      ),
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
              animationDuration: Duration(milliseconds: 500),
              backgroundColor: Color.fromARGB(255, 5, 1, 48),
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
