import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class MessagesTab extends StatelessWidget {
  const MessagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    var localization=AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localization!.forums),
        centerTitle: true,
      ),
    );
  }
}
