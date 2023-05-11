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

  final OnAudioRoom audioRoom = OnAudioRoom();

  @override
  Widget build(BuildContext context) {
    var playerController = Get.find<PlayerController>();
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 5, 1, 48),
            Color.fromARGB(255, 46, 4, 46),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(60),
                          bottomRight: Radius.circular(60)),
                      image: DecorationImage(
                          image: AssetImage("assets/images/fav_cover.png"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(60),
                            bottomRight: Radius.circular(60)),
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(132, 3, 11, 53),
                          Color.fromARGB(99, 89, 33, 129)
                        ])),
                  ),
                  const Positioned(
                    left: 30,
                    bottom: 16,
                    child: Text(
                      "Favourites",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28),
                    ),
                  )
                ]),
                const SizedBox(
                  height: 5,
                ),
                Center(
                  child: GetBuilder<FavouriteController>(
                    builder: (_) {
                      return FutureBuilder<List<FavoritesEntity>>(
                          future: audioRoom.queryFavorites(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.pink),
                                ),
                              );
                            } else if (snapshot.data!.isEmpty) {
                              return Column(
                                children: const [
                                  SizedBox(
                                    height: 150,
                                  ),
                                  Text(
                                    "No Favourites",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              );
                            }
                            List<FavoritesEntity> favourites = snapshot.data!;
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: favourites.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 1),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 9),
                                      color: Colors.black26,
                                      child: ListTile(
                                        leading: QueryArtworkWidget(
                                          artworkWidth: 48,
                                          artworkHeight: 48,
                                          artworkBorder:
                                              BorderRadius.circular(9),
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
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                            ),
                                            width: 48,
                                            height: 48,
                                          ),
                                        ),
                                        title: Text(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          favourites[index].title,
                                          style: const TextStyle(
                                            // c
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "${favourites[index].artist}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 163, 162, 168),
                                              fontSize: 13),
                                        ),
                                        trailing: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          CupertinoAlertDialog(
                                                            title: const Text(
                                                                "Remove Song ?"),
                                                            content: const Text(
                                                                "Are you sure ?"),
                                                            actions: <Widget>[
                                                              CupertinoDialogAction(
                                                                onPressed:
                                                                    () async {
                                                                  Get.find<FavouriteController>().songsDeleteFromFavorites(
                                                                      index:
                                                                          index,
                                                                      favorites:
                                                                          favourites);

                                                                  Get.back();
                                                                },
                                                                isDefaultAction:
                                                                    true,
                                                                child: Text(
                                                                  'Yes',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .green
                                                                          .shade600),
                                                                ),
                                                              ),
                                                              CupertinoDialogAction(
                                                                onPressed: () =>
                                                                    Get.back(),
                                                                child: Text(
                                                                  "No",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .red
                                                                          .shade600),
                                                                ),
                                                              )
                                                            ],
                                                          ));
                                            },
                                            icon: const Icon(
                                              Icons.heart_broken,
                                              color: Colors.pink,
                                              size: 22,
                                            )),
                                        onTap: () async {
                                          await playerController
                                              .isAllsongOpen(false);

                                          playerController.isFavOpen(true);
                                          Get.to(() => PlayerScreen(
                                                favs: favourites,
                                              ));
                                          playerController.favSongplay(
                                              favourites[index].lastData,
                                              index);
                                        },
                                      ),
                                    ),
                                  );
                                });
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
