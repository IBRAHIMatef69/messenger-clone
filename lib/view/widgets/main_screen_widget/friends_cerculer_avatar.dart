
import 'package:flutter/material.dart';

import 'package:store_user/utils/constants.dart';
class FriendsImageAvatar extends StatelessWidget {
  String imageUrl ;
  double width;
  Color? color;
  FriendsImageAvatar(
      {required this.imageUrl, required this.width, this.color,  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: width,
      width: width,
      decoration: BoxDecoration(
        // image: DecorationImage(
        //   image: NetworkImage(
        //     "$imageUrl",
        //   ),
        // ),
        borderRadius: BorderRadius.circular(width * 2),
        border: Border.all(
          color: color ?? mainColor2,
          width: 1.3,
        ),
      ),
      child: Card(
        margin: EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 2)),
        child:   ClipRRect(
          borderRadius: BorderRadius.circular(width * 2),
          child:  FadeInImage.assetNetwork(
              fit: BoxFit.cover,
              placeholder: "assets/images/l.gif",
              image: imageUrl)
          ,
        ) ,
      ),
    );
  }

 }
