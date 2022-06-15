import 'package:easy_language/core/constants.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return ElevatedButton(
      onPressed: () async {
        if (await userProvider.logout()) {
          Navigator.of(context).pushReplacementNamed(
            authenticatePageId,
          );
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          Colors.red,
        ),
      ),
      child: const Text(
        'Logout',
      ),
    );
  }
}
