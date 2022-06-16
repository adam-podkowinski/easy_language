import 'package:easy_language/core/constants.dart';
import 'package:easy_language/core/error/failures.dart';
import 'package:easy_language/core/presentation/show_failure.dart';
import 'package:easy_language/features/user/presentation/manager/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RemoveAccountWithGoogleDialog extends StatelessWidget {
  const RemoveAccountWithGoogleDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remove account'),
      insetPadding: EdgeInsets.zero,
      shape: const ContinuousRectangleBorder(),
      actionsPadding: EdgeInsets.only(right: 10.w, bottom: 10.h),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        SizedBox(
          width: 10.w,
        ),
        ElevatedButton(
          onPressed: () async {
            // Validation
            if (!await context.read<UserProvider>().removeAccount(
                  context: context,
                  withGoogle: true,
                )) {
              // Couldn't remove an account
              Navigator.of(context).pop();
              Clipboard.setData(const ClipboardData(text: contactAddress));

              showFailure(
                context,
                InfoFailure(
                  errorMessage:
                      'Could not remove an account. Please, contact us about your issue: $contactAddress.'
                      '\nE-mail copied to clipboard.',
                ),
              );
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red),
          ),
          child: const Text('Proceed'),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            removeAccountWithGoogleContent,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(
    BuildContext context, {
    required String hint,
  }) {
    final radius = 15.r;
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        ),
      ),
    );
  }
}
