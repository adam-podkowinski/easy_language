import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoFlashcards extends StatelessWidget {
  const NoFlashcards({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Not enough words to use flashcards',
          style: Theme.of(context).textTheme.headline6,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 18.h,
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Theme.of(context).colorScheme.secondary,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.r),
              ),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: const Text(
              'Home',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
