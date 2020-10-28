import 'package:flutter/material.dart';

class SongDetails extends StatelessWidget {
  final String songTitle;
  final String artist;

  SongDetails({this.songTitle, this.artist});

  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: currentHeight / 20),
        Text(
          'Alan Walker Spectre',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, fontFamily: 'DMSans-Bold' ,color: Color(0xFF3A3A41)),
        ),
        SizedBox(height: currentHeight / 40),
        Text(
          'Alan Walker',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w400, fontFamily: 'DMSans-Normal', color: Color(0xFF5C5C6E)),
        ),
        SizedBox(height: currentHeight / 20),
      ],
    );
  }
}
