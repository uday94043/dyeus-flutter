import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

final List<String> imgList = [
  'assets/dyeus.png',
  'assets/dyeus1.png',
  'assets/dyeus2.png'
];

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
              child: Image.asset(item)),
        ))
    .toList();

class CarouselWithIndicator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    double currentHeight = MediaQuery.of(context).size.height;
    return Column(children: [
      SizedBox(height: currentHeight / 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: imgList.map((item) {
          int index = imgList.indexOf(item);
          return Row(
            children: [
              SizedBox(width:5.0),
              Container(
                width: _current == index ? 14.0 : 8.0,
                height: _current == index ? 14.0 : 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index ? Color(0xFF5C5C6E) : Color(0xFFC7CDD5),
                ),
              ),
              SizedBox(width:5.0)
            ]
          );
        }).toList(),
      ),
      SizedBox(height: currentHeight / 40),
      CarouselSlider(
        items: imageSliders,
        options: CarouselOptions(
          height: currentHeight/3,
            viewportFraction: 0.55,
            autoPlay: false,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
    ]);
  }
}
