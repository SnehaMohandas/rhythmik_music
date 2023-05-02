import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:rhythmik_music_player/controllers/favourite_controller.dart';
import 'package:rhythmik_music_player/controllers/player_controller.dart';
import 'package:rhythmik_music_player/views/player_screen.dart';
import 'package:rhythmik_music_player/views/playlist.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  OnAudioRoom audioRoom = OnAudioRoom();
  final audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    var playerController = Get.put(PlayerController());
    var favController = Get.put(FavouriteController());

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        // colors: [
        //   Color.fromARGB(255, 5, 1, 48),
        //   Color.fromARGB(255, 82, 3, 69),
        //   Color.fromARGB(255, 5, 1, 48),
        // ],
        // begin: Alignment.bottomCenter,
        // end: Alignment.topCenter,
        // stops: [0.1, 0.5, 0.7]
        colors: [
          Color.fromARGB(255, 5, 1, 48),
          Color.fromARGB(255, 5, 1, 48),
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {}, icon: const Icon(Icons.grid_view_rounded)),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ))
          ],
          centerTitle: true,
          // toolbarHeight: 80,
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
                      if (snapshot.data!.isEmpty) const Text("No songs found");

                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 15, right: 15, left: 15),
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final songs = snapshot.data;
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 5, 1, 48),
                                          Color.fromARGB(255, 82, 3, 69),
                                          Color.fromARGB(255, 5, 1, 48),
                                        ],
                                      ),
                                      // border: Border.all(
                                      //     color: Color.fromARGB(
                                      //         255, 183, 104, 194))
                                    ),
                                    margin: const EdgeInsets.only(bottom: 9),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: QueryArtworkWidget(
                                            artworkWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.14,
                                            artworkHeight:
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.9,
                                            artworkBorder:
                                                BorderRadius.circular(9),
                                            id: songs![index].id,
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
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.14,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.9,
                                            ),
                                          ),
                                          title: Text(
                                            overflow: TextOverflow.ellipsis,
                                            songs[index].title,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          subtitle: Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            "${songs[index].artist}",
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 163, 162, 168),
                                                fontWeight: FontWeight.w400,
                                                fontSize: 13),
                                          ),
                                          // trailing: playerController.playIndex == index &&
                                          //         playerController.isPlaying.value
                                          //     ? const Icon(Icons.pause)
                                          //     : Icon(Icons.play_arrow),
                                          trailing: PopupMenuButton(
                                            icon: const Icon(
                                              Icons.more_vert,
                                              color: Color.fromARGB(
                                                  255, 221, 128, 159),
                                            ),
                                            //shadowColor: Colors.black,
                                            //surfaceTintColor: Colors.amber,
                                            color:
                                                Color.fromARGB(255, 24, 3, 63),
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<Text>>[
                                              PopupMenuItem(
                                                  onTap: () async {
                                                    bool isAdded =
                                                        await audioRoom.checkIn(
                                                            RoomType.FAVORITES,
                                                            songs[index].id);
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
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: const [
                                                      Text(
                                                        "Add to favourites",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      Icon(
                                                        Icons.favorite,
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  )),
                                              PopupMenuItem(
                                                  child: GestureDetector(
                                                onTap: () {
                                                  Get.back();
                                                  Get.to(() => PlaylistScreen(
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
                                                          color: Colors.white),
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
                                            await playerController
                                                .isFavOpen(false);

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
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
          ),
        ),
      ),
    );

    //),
    //);
  }
}
// TextFormField(
//                   decoration: InputDecoration(
//                     prefixIcon: Icon(
//                       Icons.search,
//                       color: Color.fromARGB(255, 173, 178, 184),
//                     ),
//                     hintText: "Search music",
//                     hintStyle:
//                         TextStyle(color: Color.fromARGB(255, 173, 178, 184)),
//                     enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         borderSide: BorderSide(
//                             color: Color.fromARGB(255, 202, 141, 182))),
//                   ),
//                 ),