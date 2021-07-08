import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordBankControls extends StatelessWidget {
  const WordBankControls({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Currently remembering:',
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(
          width: 11.w,
        ),
        DropdownButton<String>(
          value: 'English',
          onChanged: (value) {},
          items: ['English', 'Polish', 'Spanish', 'New...']
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
