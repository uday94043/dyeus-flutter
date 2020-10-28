import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Map<int, Color> color =
{
  50:Color.fromRGBO(235,243,247, .1),
  100:Color.fromRGBO(235,243,247, .2),
  200:Color.fromRGBO(235,243,247, .3),
  300:Color.fromRGBO(235,243,247, .4),
  400:Color.fromRGBO(235,243,247, .5),
  500:Color.fromRGBO(235,243,247, .6),
  600:Color.fromRGBO(235,243,247, .7),
  700:Color.fromRGBO(235,243,247, .8),
  800:Color.fromRGBO(235,243,247, .9),
  900:Color.fromRGBO(235,243,247, 1),
};

MaterialColor colorCustom = MaterialColor(0xFFEBF3F7, color);

String audioURL = 'https://firebasestorage.googleapis.com/v0/b/dyeus-a3ce2.appspot.com/o/Alan-Walker-Spectre.MP3?alt=media&token=127923c3-4df5-4979-8346-eaba65f20673';

