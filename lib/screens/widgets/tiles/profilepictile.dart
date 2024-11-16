import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:letss_app/models/person.dart';
import 'tile.dart';

class ProfilePicTile extends StatefulWidget {
  const ProfilePicTile({super.key, required this.title, required this.person});

  final String title;
  final Person person;

  @override
  ProfilePicTileState createState() {
    return ProfilePicTileState();
  }
}

class ProfilePicTileState extends State<ProfilePicTile> {
  int position = 0;

  @override
  Widget build(BuildContext context) {
    int nPics = widget.person.nProfilePics;
    nPics = nPics == 0 ? 1 : nPics;
    List<Widget> children = [
      CarouselSlider.builder(
          options: CarouselOptions(
            aspectRatio: 1 / 1,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (int index, CarouselPageChangedReason reason) {
              setState(() {
                this.position = index;
              });
            },
          ),
          itemCount: nPics,
          itemBuilder:
              (BuildContext context, int itemIndex, int pageViewIndex) =>
                  widget.person.profilePic(itemIndex)),
    ];
    if (nPics > 1) {
      children.add(Positioned.fill(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: DotsIndicator(
                      dotsCount: nPics,
                      position: position,
                      decorator: DotsDecorator(
                          color: Theme.of(context).colorScheme.primary,
                          activeColor: Theme.of(context)
                              .colorScheme
                              .primaryContainer))))));
    }
    return Tile(
      padding: true,
      child: Stack(children: children),
    );
  }
}
