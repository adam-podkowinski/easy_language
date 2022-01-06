import 'package:easy_language/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget forgotPasswordDialog(BuildContext context) => AlertDialog(
      title: const Text('Reset password'),
      insetPadding: EdgeInsets.zero,
      shape: const ContinuousRectangleBorder(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            resetPasswordContent,
            textAlign: TextAlign.justify,
          ),
          TextButton(
            child: Text(
              contactAddress,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onPressed: () {
              Clipboard.setData(
                const ClipboardData(
                  text: contactAddress,
                ),
              ).then(
                (_) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    SnackBar(
                      backgroundColor: Theme.of(context).backgroundColor,
                      content: Text(
                        'Copied!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
