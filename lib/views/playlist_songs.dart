import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:rhythmik_music_player/controllers/add_song_playlist_controller.dart';
import 'package:rhythmik_music_player/controllers/player_controller.dart';
import 'package:rhythmik_music_player/views/player_screen.dart';

class PlayListSongs extends StatelessWidget {
  final dynamic playListName;
  final int playListKey;

  PlayListSongs({
    Key? key,
    this.playListName,
    required this.playListKey,
  }) : super(key: key);

  final OnAudioRoom audioRoom = OnAudioRoom();
  final OnAudioQuery audioQuery = OnAudioQuery();

  @override
  Widget build(BuildContext context) {
    var addSongPlaylistController = Get.put(AddSongPlaylistController());
    var playerController = Get.find<PlayerController>();

    return GetBuilder<AddSongPlaylistController>(
      builder: (ctx) => Container(
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
          floatingActionButton: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                color: Colors.transparent),
            child: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 9, 1, 32),
              onPressed: () {
                Get.bottomSheet(
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        'Add songs to $playListName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Expanded(
                        child: FutureBuilder<List<SongModel>>(
                          future: audioQuery.querySongs(
                            sortType: null,
                          ),
                          builder: (context, item) {
                            if (item.data == null) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.pink),
                              ));
                            }
                            if (item.data!.isEmpty) {
                              return const Center(
                                  child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.pink),
                              ));
                            }

                            List<SongModel>? songs = item.data;

                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListView.separated(
                                itemCount: songs!.length,
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: ListTile(
                                      leading: QueryArtworkWidget(
                                        id: songs[index].id,
                                        type: ArtworkType.AUDIO,
                                        artworkWidth: 48,
                                        artworkHeight: 48,
                                        artworkBorder: BorderRadius.circular(7),
                                        keepOldArtwork: true,
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
                                            height: 48),
                                      ),
                                      title: Text(
                                        songs[index].title,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w300,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      subtitle: Text(
                                        songs[index].artist.toString(),
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 163, 162, 168),
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      onTap: () async {
                                        bool isAdded = await audioRoom.checkIn(
                                          RoomType.PLAYLIST,
                                          songs[index].id,
                                          playlistKey: playListKey,
                                        );

                                        addSongPlaylistController
                                            .songAddingPlaylist(
                                          index: index,
                                          playListkey: playListKey,
                                          songs: songs,
                                        );
                                        Get.back();
                                      },
                                    ),
                                  );
                                },
                                separatorBuilder: (conext, index) {
                                  return const Divider();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color.fromARGB(255, 6, 2, 41),
                );
              },
              child: const Icon(
                Icons.library_music,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
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
                            image: AssetImage(
                                "assets/images/playlist_song_cover.png"),
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
                            Color.fromARGB(181, 3, 11, 53),
                            Color.fromARGB(123, 89, 33, 129)
                          ])),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    Positioned(
                      left: 30,
                      bottom: 16,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playListName,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28),
                          ),
                          const Text(
                            "Playlist",
                            style: TextStyle(
                                color: Color.fromARGB(255, 221, 215, 215),
                                fontSize: 15),
                          )
                        ],
                      ),
                    )
                  ]),
                  const SizedBox(
                    height: 7,
                  ),
                  FutureBuilder<List<SongEntity>>(
                      future: OnAudioRoom().queryAllFromPlaylist(
                        playListKey,
                        sortType: null,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        }
                        if (snapshot.data!.isEmpty) {
                          return Column(
                            children: const [
                              SizedBox(
                                height: 150,
                              ),
                              Text(
                                'No songs',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          );
                        }

                        List<SongEntity> playlistSongs = snapshot.data!;

                        return Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Center(
                                child: ListTile(
                                  leading: QueryArtworkWidget(
                                    id: playlistSongs[index].id,
                                    type: ArtworkType.AUDIO,
                                    artworkWidth: 48,
                                    artworkHeight: 48,
                                    artworkBorder: BorderRadius.circular(7),
                                    keepOldArtwork: true,
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
                                        height: 48),
                                  ),
                                  title: Text(
                                    playlistSongs[index].title,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w300,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  subtitle: Text(
                                    playlistSongs[index].artist.toString(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 163, 162, 168),
                                        fontSize: 13,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        addSongPlaylistController
                                            .songDeleteFromPlaylist(
                                                index: index,
                                                playListKey: playListKey,
                                                playlistSongs: playlistSongs);
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        size: 28,
                                        color:
                                            Color.fromARGB(255, 135, 141, 207),
                                      )),
                                  onTap: () async {
                                    await playerController.isAllsongOpen(false);
                                    await playerController.isFavOpen(false);
                                    playerController.isPlaylistOpen(true);

                                    Get.to(() => PlayerScreen(
                                          playlistSongs: playlistSongs,
                                        ));
                                    playerController.playlistsongPlay(
                                        playlistSongs[index].lastData, index);
                                  },
                                ),
                              );
                            },
                            itemCount: playlistSongs.length,
                          ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
