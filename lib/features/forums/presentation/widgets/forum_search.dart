import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';

class ForumSearch extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;

  const ForumSearch(
      this.searchController,
      this.onSearch, {
        super.key,
      });

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        onChanged: (value) => onSearch(),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(28),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(28),
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: localization.searchForums,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
          prefixIcon: const Icon(Icons.search_rounded),
        ),
      ),
    );
  }
}
