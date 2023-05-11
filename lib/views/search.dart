import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rhythmik_music_player/controllers/player_controller.dart';
import 'package:rhythmik_music_player/views/player_screen.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<SongModel> songs = [];

  CustomSearchDelegate({required this.songs});

  @override
  TextStyle get searchFieldStyle =>
      const TextStyle(fontWeight: FontWeight.w600, color: Colors.white);
  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          color: Color.fromARGB(255, 5, 1, 48),
        ),
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white)));
  }

  @override
  buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
            close(context, null);
          },
          icon: const Icon(
            Icons.clear,
          )),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    List<String> matchQeuryartist = [];

    for (var item in songs) {
      if (item.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item.title);
        matchQeuryartist.add(item.artist.toString());
      }
    }
    if (matchQuery.isEmpty) {
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
        child: const Center(
          child: Text(
            "No songs",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
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
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery[index];
            var artist = matchQeuryartist[index];

            int filterIndex = songs
                .indexWhere((element) => element.title == matchQuery[index]);

            return ListTile(
              leading: buildListTileLeading(songs, filterIndex, context),
              title: Text(
                result,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              subtitle: Text(
                artist,
                maxLines: 1,
                style: const TextStyle(
                    color: Color.fromARGB(255, 163, 162, 168), fontSize: 13),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();

                var playerController = Get.find<PlayerController>();
                playerController.isAllsongOpen(false);
                playerController.isFavOpen(false);
                playerController.isPlaylistOpen(false);

                Get.to(PlayerScreen(data: songs));
                playerController.playSong(songs[filterIndex].uri, filterIndex);
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    List<String> matchQeuryartist = [];
    for (var item in songs) {
      if (item.title.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item.title);
        matchQeuryartist.add(item.artist.toString());
      }
    }

    if (matchQuery.isEmpty) {
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
        child: const Center(
          child: Text(
            'No songs',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

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
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery[index];
            var artist = matchQeuryartist[index];

            int filterIndex = songs
                .indexWhere((element) => element.title == matchQuery[index]);

            return ListTile(
              leading: buildListTileLeading(songs, filterIndex, context),
              title: Text(
                result,
                maxLines: 1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
              subtitle: Text(
                artist,
                maxLines: 1,
                style: const TextStyle(
                    color: Color.fromARGB(255, 163, 162, 168), fontSize: 13),
              ),
              onTap: () {
                FocusScope.of(context).unfocus();
                var playerController = Get.find<PlayerController>();
                playerController.isAllsongOpen(false);
                playerController.isFavOpen(false);
                playerController.isPlaylistOpen(false);

                Get.to(PlayerScreen(data: songs));
                playerController.playSong(songs[filterIndex].uri, filterIndex);
              },
            );
          },
        ),
      ),
    );
  }

  buildListTileLeading(
    image,
    index,
    context,
  ) {
    return QueryArtworkWidget(
      id: image[index].id,
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
                'assets/images/music_icon.png',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          width: 48,
          height: 48),
    );
  }
}
