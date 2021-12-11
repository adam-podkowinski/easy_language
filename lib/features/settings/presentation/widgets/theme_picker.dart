import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsProvider>();
    if (!state.loading) {
      return DropdownButton(
        iconEnabledColor: Theme.of(context).primaryColor,
        value: state.themeModeString,
        onChanged: (value) async => state.changeSettings({
          Settings.themeModeId: value ?? Settings.systemThemeId,
        }),
        items: Settings.availableThemesIds
            .map(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
      );
    } else {
      return DropdownButton(
        items: const [],
        onChanged: null,
      );
    }
  }
}
