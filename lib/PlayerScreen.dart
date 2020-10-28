
import 'package:flutter/material.dart';
import 'CarouselWithIndicator.dart';
import 'PlayerWidget.dart';
import 'Constants.dart';


class PlayerScreen extends StatefulWidget {
  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CarouselWithIndicator(),
          PlayerWidget(url: audioURL),
        ],
      ),
    );
  }
}
