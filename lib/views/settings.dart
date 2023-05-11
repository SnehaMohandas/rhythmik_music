import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:rhythmik_music_player/const.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "About",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.to(() => Theme(
                          data: Theme.of(context).copyWith(
                            textTheme: const TextTheme(
                                labelSmall: TextStyle(color: Colors.white)),
                            cardColor: const Color.fromARGB(255, 5, 1, 48),
                            scaffoldBackgroundColor:
                                const Color.fromARGB(255, 5, 1, 48),
                          ),
                          child: const LicensePage(
                            applicationName: "Rhythmik",
                            applicationVersion: "1.0.0",
                          ),
                        ));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Privacy Policy",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.to(() => const PrivacyPolicy());
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.text_snippet_rounded,
                    color: Colors.white,
                  ),
                  title: const Text(
                    "Terms And Conditions",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.to(() => const TermsAndConditions());
                  },
                ),
                const Spacer(),
                Column(
                  children: const [
                    Text(
                      'Version',
                      style: TextStyle(
                          letterSpacing: 1, fontSize: 17, color: Colors.grey),
                    ),
                    Text(
                      '1.0.0',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 40,
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBar(
            title: const Text("Privacy Policy"),
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: privacyPolicy,
          ))),
    );
  }
}

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBar(
            title: const Text("Terms And conditions"),
          ),
          body: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            child: termsAndConditions,
          ))),
    );
  }
}
