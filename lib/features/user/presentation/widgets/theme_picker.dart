import 'package:easy_language/features/user/domain/entities/user.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemePicker extends StatelessWidget {
  const ThemePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserProvider>();
    if (!state.loading) {
      return DropdownButton(
        iconEnabledColor: Theme.of(context).primaryColor,
        value: state.themeModeString,
        onChanged: (value) {
          state.editUser({
            User.themeModeId: value ?? User.systemThemeId,
          });
        },
        items: User.availableThemesIds
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
