import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class ForumSearch extends StatelessWidget {
  TextEditingController searchController = TextEditingController();
  void Function() onSearch;
  ForumSearch(this.searchController,this.onSearch,{super.key});
  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) => onSearch(),
        controller: searchController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.circular(28)),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey),borderRadius: BorderRadius.circular(28)),
          filled: true,
          fillColor: Colors.white,
          hintText: localization.searchForums,
          hintStyle: TextStyle(color: Colors.grey,fontSize: 18),
          prefixIcon: Icon(Icons.search_rounded)
        ),
      ),
    );
  }
}
