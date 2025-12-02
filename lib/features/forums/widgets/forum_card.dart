import 'package:bnu_lms_app/features/forums/data/forums_data.dart';
import 'package:flutter/material.dart';

class ForumCard extends StatelessWidget {
  final ForumsData forum;
  const ForumCard({required this.forum,super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: AssetImage(forum.image),radius:30,),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(forum.title,style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Text(forum.description,style: TextStyle(fontWeight: FontWeight.normal),softWrap: true,),
            ],),
          ),
        ],
      ),
    );
  }
}
