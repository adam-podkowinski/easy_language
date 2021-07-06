import 'package:easy_language/features/settings/domain/entities/settings.dart';
import 'package:easy_language/features/settings/presentation/manager/settings_bloc.dart';
import 'package:easy_language/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemePicker extends StatefulWidget {
  const ThemePicker({Key? key}) : super(key: key);

  @override
  _ThemePickerState createState() => _ThemePickerState();
}

class _ThemePickerState extends State<ThemePicker> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingletonSettingsBloc, SettingsState>(
      builder: (context, state) {
        if (state is SettingsInitialized) {
          return DropdownButton(
            iconEnabledColor: Theme.of(context).primaryColor,
            value: state.themeModeString,
            onChanged: (value) {
              sl<SingletonSettingsBloc>().add(
                ChangeSettingsEvent(
                  changedSettings: {
                    Settings.themeModeId: value ?? Settings.systemThemeId
                  },
                ),
              );
            },
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
          );
        }
      },
    );
  }
}
