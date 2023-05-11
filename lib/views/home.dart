import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:rhythmik_music_player/controllers/favourite_controller.dart';
import 'package:rhythmik_music_player/controllers/player_controller.dart';
import 'package:rhythmik_music_player/views/player_screen.dart';
import 'package:rhythmik_music_player/views/playlist.dart';
import 'package:rhythmik_music_player/views/search.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  OnAudioRoom audioRoom = OnAudioRoom();
  final audioPlayer = AudioPlayer();
  List<SongModel> songs = [];

  @override
  Widget build(BuildContext context) {
    var playerController = Get.put(PlayerController());
    var favController = Get.put(FavouriteController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 5, 1, 48),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GetBuilder<PlayerController>(
          builder: (playerController) => IconButton(
              onPressed: () {
                playerController.changeHomeBody();
              },
              icon: playerController.changingGridview
                  ? const Icon(Icons.grid_view_rounded)
                  : const Icon(Icons.list_sharp)),
        ),
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(songs: songs));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
        centerTitle: true,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "RHYTHMI",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "k",
              style: TextStyle(color: Colors.pink, fontSize: 38),
            )
          ],
        ),
      ),
      body: Center(
        child: Obx(
          () => !playerController.hasPermission.value
              ? const Text(
                  "No songs found",
                  style: TextStyle(color: Colors.white),
                )
              : FutureBuilder<List<SongModel>>(
                  future: playerController.audioQuery.querySongs(
                      ignoreCase: true,
                      orderType: OrderType.ASC_OR_SMALLER,
                      sortType: null,
                      uriType: UriType.EXTERNAL),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.data == null) {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.pink),
                      );
                    }
                    if (snapshot.data!.isEmpty) {
                      return const Text(
                        "No songs found",
                        style: TextStyle(color: Colors.white),
                      );
                    }
                    songs = snapshot.data!;

                    return Padding(
                      padding:
                          const EdgeInsets.only(top: 15, right: 12, left: 12),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.headphones,
                                  color: Colors.pink,
                                ),
                                Text(
                                  "All Songs",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          GetBuilder<PlayerController>(
                            builder: (controller) => Expanded(
                              child: playerController.changingGridview
                                  ? ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        final songs = snapshot.data;
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(26),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color.fromARGB(255, 5, 1, 48),
                                                Color.fromARGB(255, 71, 4, 71),
                                                Color.fromARGB(255, 5, 1, 48),
                                              ],
                                            ),
                                          ),
                                          margin:
                                              const EdgeInsets.only(bottom: 9),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                leading: QueryArtworkWidget(
                                                  artworkWidth: 48,
                                                  artworkHeight: 48,
                                                  artworkBorder:
                                                      BorderRadius.circular(9),
                                                  id: songs![index].id,
                                                  type: ArtworkType.AUDIO,
                                                  nullArtworkWidget: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      image:
                                                          const DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/music_icon.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                    ),
                                                    width: 48,
                                                    height: 48,
                                                  ),
                                                ),
                                                title: Text(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  songs[index].title,
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                                subtitle: Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  "${songs[index].artist}",
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 163, 162, 168),
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 13),
                                                ),
                                                trailing: PopupMenuButton(
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                    color: Color.fromARGB(
                                                        255, 135, 141, 207),
                                                  ),
                                                  color: const Color.fromARGB(
                                                      255, 24, 3, 63),
                                                  itemBuilder: (BuildContext
                                                          context) =>
                                                      <PopupMenuEntry<Text>>[
                                                    PopupMenuItem(
                                                        onTap: () async {
                                                          bool isAdded =
                                                              await audioRoom.checkIn(
                                                                  RoomType
                                                                      .FAVORITES,
                                                                  songs[index]
                                                                      .id);
                                                          audioRoom.addTo(
                                                            RoomType.FAVORITES,
                                                            songs[index]
                                                                .getMap
                                                                .toFavoritesEntity(),
                                                            ignoreDuplicate:
                                                                false,
                                                          );
                                                          favController
                                                              .addToFavourite(
                                                                  songs,
                                                                  index,
                                                                  isAdded);
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: const [
                                                            Text(
                                                              "Add to favourites",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            Icon(
                                                              Icons.favorite,
                                                              color:
                                                                  Colors.white,
                                                            )
                                                          ],
                                                        )),
                                                    PopupMenuItem(
                                                        child: GestureDetector(
                                                      onTap: () {
                                                        Get.back();
                                                        Get.to(() =>
                                                            PlaylistScreen(
                                                              songIndex: index,
                                                              songs: songs,
                                                            ));
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: const [
                                                          Text(
                                                            "Add to playlist",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Icon(
                                                            Icons.playlist_add,
                                                            color: Colors.white,
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                                  ],
                                                ),
                                                onTap: () async {
                                                  playerController
                                                      .isAllsongOpen(true);

                                                  Get.to(
                                                      () => PlayerScreen(
                                                            data: songs,
                                                          ),
                                                      transition:
                                                          Transition.downToUp);
                                                  playerController.playSong(
                                                      songs[index].uri, index);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                        // );
                                      },
                                    )
                                  : GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio: 7 / 8),
                                      itemCount: songs.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: const EdgeInsets.all(8),
                                          child: GridTile(
                                            header: Wrap(
                                              alignment:
                                                  WrapAlignment.spaceAround,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Get.to(() =>
                                                          PlaylistScreen(
                                                            songIndex: index,
                                                            songs: songs,
                                                          ));
                                                    },
                                                    icon: const Icon(
                                                        Icons.playlist_add,
                                                        color: Colors.white)),
                                                IconButton(
                                                    onPressed: () async {
                                                      bool isAdded =
                                                          await audioRoom
                                                              .checkIn(
                                                                  RoomType
                                                                      .FAVORITES,
                                                                  songs[index]
                                                                      .id);
                                                      audioRoom.addTo(
                                                        RoomType.FAVORITES,
                                                        songs[index]
                                                            .getMap
                                                            .toFavoritesEntity(),
                                                        ignoreDuplicate: false,
                                                      );
                                                      favController
                                                          .addToFavourite(songs,
                                                              index, isAdded);
                                                    },
                                                    icon: const Icon(
                                                      Icons.favorite,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                            //),
                                            footer: Container(
                                              color: Colors.black38,
                                              child: Column(
                                                children: [
                                                  Text(
                                                    songs[index].title,
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                  Text(
                                                    songs[index]
                                                        .artist
                                                        .toString(),
                                                    maxLines: 1,
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  )
                                                ],
                                              ),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                playerController
                                                    .isAllsongOpen(true);

                                                Get.to(
                                                    () => PlayerScreen(
                                                          data: songs,
                                                        ),
                                                    transition:
                                                        Transition.downToUp);
                                                playerController.playSong(
                                                    songs[index].uri, index);
                                              },
                                              child: QueryArtworkWidget(
                                                artworkWidth: 48,
                                                artworkHeight: 48,
                                                artworkBorder:
                                                    BorderRadius.circular(7),
                                                id: songs[index].id,
                                                type: ArtworkType.AUDIO,
                                                nullArtworkWidget: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      image:
                                                          const DecorationImage(
                                                        image: AssetImage(
                                                            'assets/images/music_icon.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              7),
                                                    ),
                                                    width: 48,
                                                    height: 48),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
        ),
      ),
    );
  }
}
