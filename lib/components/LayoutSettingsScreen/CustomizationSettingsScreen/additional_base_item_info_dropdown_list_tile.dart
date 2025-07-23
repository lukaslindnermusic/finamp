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
    final additionalBaseItemInfos = ref.watch(finampSettingsProvider.additionalBaseItemInfo);
    final currentType = additionalBaseItemInfos[tabContentType] ?? AdditionalBaseItemInfoTypes.adaptive;

    // Filter dropdown items based on tabContentType
    final dropdownItems = AdditionalBaseItemInfoTypes.values.where((type) {
      if (type == AdditionalBaseItemInfoTypes.adaptive ||
          type == AdditionalBaseItemInfoTypes.dateAdded ||
          type == AdditionalBaseItemInfoTypes.none) {
        return true;
      }

      switch (tabContentType) {
        case TabContentType.tracks:
          return type == AdditionalBaseItemInfoTypes.playCount ||
              type == AdditionalBaseItemInfoTypes.dateLastPlayed ||
              type == AdditionalBaseItemInfoTypes.dateReleased;
        case TabContentType.albums:
          return type == AdditionalBaseItemInfoTypes.duration || type == AdditionalBaseItemInfoTypes.dateReleased;
        case TabContentType.playlists:
        case TabContentType.artists:
          return type == AdditionalBaseItemInfoTypes.duration;
        default:
          return false;
      }
    }).toList();

    return ListTile(
      title: Text(tabContentType.toLocalisedString(context)),
      trailing: DropdownButton<AdditionalBaseItemInfoTypes>(
        value: currentType,
        items: dropdownItems
            .map(
              (e) => DropdownMenuItem<AdditionalBaseItemInfoTypes>(value: e, child: Text(e.toLocalisedString(context))),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            final newAdditionalBaseItemInfos = Map<TabContentType, AdditionalBaseItemInfoTypes>.from(
              additionalBaseItemInfos,
            );
            newAdditionalBaseItemInfos[tabContentType] = value;
            FinampSetters.setAdditionalBaseItemInfo(newAdditionalBaseItemInfos);
          }
        },
      ),
    );
  }
}
