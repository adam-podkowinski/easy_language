import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    return ElevatedButton(
      onPressed: userProvider.logout,
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
