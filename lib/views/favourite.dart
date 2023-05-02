import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:rhythmik_music_player/controllers/favourite_controller.dart';
import 'package:rhythmik_music_player/controllers/player_controller.dart';
import 'package:rhythmik_music_player/views/player_screen.dart';

class FavouriteScreen extends StatelessWidget {
  FavouriteScreen({super.key});
  final List<Audio> convertList = [];

  final OnAudioRoom audioRoom = OnAudioRoom();

  @override
  Widget build(BuildContext context) {
    var playerController = Get.find<PlayerController>();
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 5, 1, 48),
                  Color.fromARGB(255, 82, 3, 69),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.6, 0.9])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            //toolbarHeight: 70,
            backgroundColor: Colors.transparent,
            centerTitle: true,
            title: const Text(
              "Favourite Songs",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          body: Center(
            child: GetBuilder<FavouriteController>(
              builder: (_) {
                return FutureBuilder<List<FavoritesEntity>>(
                    future: audioRoom.queryFavorites(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.pink),
                          ),
                        );
                      } else if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text(
                            "No Favourites",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                      List<FavoritesEntity> favourites = snapshot.data!;
                      return ListView.builder(
                          itemCount: favourites.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 1),
                              child: ListTile(
                                leading: QueryArtworkWidget(
                                  artworkWidth:
                                      MediaQuery.of(context).size.width * 0.14,
                                  artworkHeight:
                                      MediaQuery.of(context).size.height * 0.9,
                                  artworkBorder: BorderRadius.circular(9),
                                  id: favourites[index].id,
                                  type: ArtworkType.AUDIO,
                                  nullArtworkWidget: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      image: const DecorationImage(
                                        image: AssetImage(
                                            'assets/images/music_icon.png'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    width: MediaQuery.of(context).size.width *
                                        0.14,
                                    height: MediaQuery.of(context).size.height *
                                        0.9,
                                  ),
                                ),
                                title: Text(
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  favourites[index].title,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "${favourites[index].artist}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 163, 162, 168),
                                      fontSize: 13),
                                ),
                                trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              CupertinoAlertDialog(
                                                title:
                                                    const Text("Remove Song ?"),
                                                content: const Text(
                                                    "Are you sure ?"),
                                                actions: <Widget>[
                                                  CupertinoDialogAction(
                                                    onPressed: () async {
                                                      Get.find<
                                                              FavouriteController>()
                                                          .songsDeleteFromFavorites(
                                                              index: index,
                                                              favorites:
                                                                  favourites);

                                                      Get.back();
                                                    },
                                                    isDefaultAction: true,
                                                    child: Text(
                                                      'Yes',
                                                      style: TextStyle(
                                                          color: Colors
                                                              .green.shade600),
                                                    ),
                                                  ),
                                                  CupertinoDialogAction(
                                                    onPressed: () => Get.back(),
                                                    child: Text(
                                                      "No",
                                                      style: TextStyle(
                                                          color: Colors
                                                              .red.shade600),
                                                    ),
                                                  )
                                                ],
                                              ));
                                    },
                                    icon: const Icon(
                                      Icons.heart_broken,
                                      color: Colors.pink,
                                    )),
                                onTap: () async {
                                  await playerController.isAllsongOpen(false);

                                  playerController.isFavOpen(true);
                                  Get.to(() => PlayerScreen(
                                        favs: favourites,
                                      ));
                                  playerController.favSongplay(
                                      favourites[index].lastData, index);
                                },
                              ),
                            );
                          });
                    });
              },
            ),
          ),
        ));
  }
}
