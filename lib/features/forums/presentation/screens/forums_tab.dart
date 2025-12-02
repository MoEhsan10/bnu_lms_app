import 'package:bnu_lms_app/features/forums/data/forums_data.dart';
import 'package:bnu_lms_app/features/forums/widgets/forum_card.dart';
import 'package:bnu_lms_app/features/forums/widgets/forum_search.dart';
import 'package:bnu_lms_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ForumsTab extends StatefulWidget {
  const ForumsTab({super.key});

  @override
  State<ForumsTab> createState() => _ForumsTabState();
}

class _ForumsTabState extends State<ForumsTab> {
    TextEditingController searchController = TextEditingController();
    List<ForumsData> forumsData = [
    ForumsData(title: 'Introduction to Programming', description: 'General discussion about the course', image: 'assets/images/programming.png'),
    ForumsData(title: 'Calculus II', description: 'Questions about assignments and exams', image: 'assets/images/calculus.png'),
    ForumsData(title: 'Linear Algebra', description: 'Share resources and study tips', image: 'assets/images/linear_algebra.png'),
    ForumsData(title: 'Data Structures', description: 'Discuss project ideas and collaboration', image: 'assets/images/data_structures.png'),
  ];
    late List<ForumsData> filteredForums ;
    void filteredForumsSearch(){
      String query = searchController.text;
      if(query.isEmpty){
        filteredForums = forumsData;
      }else{
        filteredForums= forumsData.where((forumData)=>forumData.title.toLowerCase().contains(query.toLowerCase())).toList();
      }
      setState(() {

      });


    }

  @override
  void initState() {
    super.initState();
    filteredForums = forumsData;
  }
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;


    return Scaffold(
      appBar: AppBar(
        title: Text(localization.forums),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: ForumSearch(searchController,filteredForumsSearch),
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context,index){
          final ForumsData forum = filteredForums[index];
          return ForumCard(forum: forum);
        },
        separatorBuilder: (BuildContext context, int index) =>Divider(),
        itemCount: filteredForums.length,
      ),


    );
  }
}
