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
                  Color.fromARGB(255, 82, 3, 69),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.6, 0.9])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text(
              playListName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          floatingActionButton: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                color: Colors.transparent),
            child: FloatingActionButton(
              backgroundColor: Color.fromARGB(255, 9, 1, 32),
              onPressed: () {
                Get.bottomSheet(
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Text(
                        'Add songs to ${playListName}',
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
                                        artworkWidth:
                                            MediaQuery.of(context).size.width *
                                                0.14,
                                        artworkHeight:
                                            MediaQuery.of(context).size.height *
                                                0.9,
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
                                        songs[index].title,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            color: Colors.white,
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
                  backgroundColor: const Color.fromARGB(255, 5, 1, 48),
                );
              },
              child: const Icon(
                Icons.library_music,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          body: FutureBuilder<List<SongEntity>>(
              future: OnAudioRoom().queryAllFromPlaylist(
                playListKey,
                //limit: 200,
                sortType: null,
              ),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No songs',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                List<SongEntity> playlistSongs = snapshot.data!;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin:
                          const EdgeInsets.only(left: 13, right: 13, top: 9),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 5, 1, 48),
                                Color.fromARGB(255, 82, 3, 69),
                              ],
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                              stops: [0.6, 0.9])),
                      child: Center(
                        child: ListTile(
                          leading: QueryArtworkWidget(
                            id: playlistSongs[index].id,
                            type: ArtworkType.AUDIO,
                            artworkWidth:
                                MediaQuery.of(context).size.width * 0.14,
                            artworkHeight:
                                MediaQuery.of(context).size.height * 0.9,
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
                                borderRadius: BorderRadius.circular(7),
                              ),
                              width: MediaQuery.of(context).size.width * 0.14,
                              height: MediaQuery.of(context).size.height * 0.9,
                            ),
                          ),
                          title: Text(
                            playlistSongs[index].title,
                            maxLines: 1,
                            style: const TextStyle(
                                color: Colors.white,
                                overflow: TextOverflow.ellipsis),
                          ),
                          subtitle: Text(
                            playlistSongs[index].artist.toString(),
                            maxLines: 1,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 163, 162, 168),
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
                                Icons.playlist_remove,
                                color: Colors.pink,
                                // size: 27,
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
                      ),
                    );
                  },
                  itemCount: playlistSongs.length,
                );
              }),
        ),
      ),
    );
  }
}
