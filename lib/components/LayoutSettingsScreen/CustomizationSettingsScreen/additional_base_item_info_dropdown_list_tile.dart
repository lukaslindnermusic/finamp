import 'package:finamp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/finamp_models.dart';
import '../../../services/finamp_settings_helper.dart';

class AdditionalBaseItemInfoTitleListTile extends ConsumerWidget {
  const AdditionalBaseItemInfoTitleListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(AppLocalizations.of(context)!.additionalBaseItemInfoTitle),
      subtitle: Text(AppLocalizations.of(context)!.additionalBaseItemInfoSubtitle),
    );
  }
}

class AdditionalBaseItemInfoDropdownListTile extends ConsumerWidget {
  final TabContentType tabContentType;

  const AdditionalBaseItemInfoDropdownListTile({required this.tabContentType, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileAdditionalInfo = ref.watch(finampSettingsProvider.tileAdditionalInfo(tabContentType));
    final currentType = tileAdditionalInfo ?? TileAdditionalInfoType.adaptive;

    // Filter dropdown items based on tabContentType
    final dropdownItems = [
      TileAdditionalInfoType.adaptive,
      TileAdditionalInfoType.dateAdded,
      if ([TabContentType.artists, TabContentType.playlists].contains(tabContentType)) TileAdditionalInfoType.duration,
    ];

    return ListTile(
      title: Text(tabContentType.toLocalisedString(context)),
      trailing: DropdownButton<TileAdditionalInfoType>(
        value: currentType,
        items: dropdownItems
            .map(
              (e) => DropdownMenuItem<TileAdditionalInfoType>(value: e, child: Text(e.toLocalisedString(context))),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            FinampSetters.setTileAdditionalInfo(tabContentType, value);
          }
        },
      ),
    );
  }
}
