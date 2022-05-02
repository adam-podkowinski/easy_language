import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({
    Key? key,
    required this.text,
    required this.numberString,
    required this.color,
  }) : super(key: key);

  final String text;
  final String numberString;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 13.w,
          height: 13.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          height: 9.h,
        ),
        Text(
          numberString,
          style: Theme.of(context).textTheme.headline6,
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
