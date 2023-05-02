import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:on_audio_room/on_audio_room.dart';
import 'package:rhythmik_music_player/controllers/playlist_controller.dart';
import 'package:rhythmik_music_player/views/playlist_songs.dart';

class PlaylistScreen extends StatelessWidget {
  PlaylistScreen({super.key, this.songs, this.songIndex});
  final OnAudioRoom audioRoom = OnAudioRoom();
  final List<SongModel>? songs;
  final int? songIndex;

  @override
  Widget build(BuildContext context) {
    TextEditingController playListNameController = TextEditingController();
    var playListController = Get.put(PlaylistController());
    final formkey = GlobalKey<FormState>();

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
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Playlist",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                showDialog<bool>(
                  context: Get.overlayContext!,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text('Create a playlist'),
                      content: Card(
                        color: Colors.transparent,
                        elevation: 0.0,
                        child: Column(
                          children: <Widget>[
                            Form(
                              key: formkey,
                              child: TextFormField(
                                controller: playListNameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'please enter a name';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: "Enter a name ?",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        CupertinoDialogAction(
                          isDefaultAction: true,
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.green.shade600),
                          ),
                          onPressed: () {
                            if (formkey.currentState!.validate()) {
                              Get.back();

                              playListController.createPlaylistName(
                                  playListNameController.text);
                              playListNameController.clear();
                            }
                          },
                        ),
                        CupertinoDialogAction(
                          onPressed: () {
                            Get.back();
                            playListNameController.clear();
                          },
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.red.shade600),
                          ),
                        )
                      ],
                    );
                  },
                );
              },
              child: Icon(
                Icons.playlist_add,
                size: 27,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: Column(
              children: [
                Expanded(
                  child: GetBuilder<PlaylistController>(builder: (context) {
                    return FutureBuilder<List<PlaylistEntity>>(
                        future: OnAudioRoom().queryPlaylists(),
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
                                "No Playlists",
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          }
                          List<PlaylistEntity> playlists = snapshot.data!;

                          return ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  color: Color.fromARGB(255, 144, 158, 202),
                                );
                              },
                              itemCount: playlists.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Container(
                                    height: 50,
                                    width: 45,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/playlists.png"),
                                            fit: BoxFit.fitWidth)),
                                  ),
                                  title: Text(
                                    playlists[index].playlistName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: Get.overlayContext!,
                                            builder: (BuildContext context) =>
                                                CupertinoAlertDialog(
                                                  title: const Text(
                                                      "Delete The Playlist"),
                                                  content: const Text(
                                                      "Are you sure ?"),
                                                  actions: <Widget>[
                                                    CupertinoDialogAction(
                                                      onPressed: () {
                                                        playListController
                                                            .deletePlaylist(
                                                                playlists[index]
                                                                    .key);
                                                        Get.back();
                                                      },
                                                      isDefaultAction: true,
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                            color: Colors.green
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
                                                                .red.shade600),
                                                      ),
                                                    )
                                                  ],
                                                ));
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.pink,
                                      )),
                                  onTap: () async {
                                    if (songs == null) {
                                      return Get.to(() => PlayListSongs(
                                            playListName:
                                                playlists[index].playlistName,
                                            playListKey: playlists[index].key,
                                          ));
                                    } else {
                                      bool isAdded = await audioRoom.checkIn(
                                        RoomType.PLAYLIST,
                                        songs![songIndex!].id,
                                        playlistKey: playlists[index].key,
                                      );

                                      await audioRoom.addTo(
                                        RoomType.PLAYLIST,
                                        songs![songIndex!]
                                            .getMap
                                            .toSongEntity(),
                                        playlistKey: playlists[index].key,
                                        ignoreDuplicate: false,
                                      );

                                      Get.back();
                                      if (isAdded == true) {
                                        Get.snackbar(
                                          '',
                                          '',
                                          titleText: Text(
                                            'Message from ${playlists[index].playlistName}',
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          ),
                                          messageText: Text(
                                            'Song Already Added to ${playlists[index].playlistName}',
                                            maxLines: 2,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor:
                                              Color.fromARGB(255, 24, 3, 63),
                                        );
                                      } else {
                                        Get.snackbar(
                                          '',
                                          '',
                                          titleText: Text(
                                            'Message from ${playlists[index].playlistName}',
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                          messageText: Text(
                                            '${songs![songIndex!].title}  Song Added to ${playlists[index].playlistName} ',
                                            maxLines: 2,
                                          ),
                                          backgroundColor: Colors.white,
                                        );
                                      }
                                      Get.to(
                                        () => PlayListSongs(
                                          playListName:
                                              playlists[index].playlistName,
                                          playListKey: playlists[index].key,
                                        ),
                                      );
                                    }
                                  },
                                );
                              });
                        });
                  }),
                ),
              ],
            ),
          )),
    );
  }
}
