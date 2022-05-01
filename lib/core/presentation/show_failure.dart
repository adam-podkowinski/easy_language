import 'package:easy_language/core/error/failures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void showFailure(
  BuildContext context,
  InfoFailure? failure, {
  Function()? runAfter,
}) {
  if (failure != null && failure.showErrorMessage) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).backgroundColor,
          duration: const Duration(milliseconds: 2500),
          content: Text(
            failure.errorMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ),
      );
      runAfter?.call();
    });
  }
}
