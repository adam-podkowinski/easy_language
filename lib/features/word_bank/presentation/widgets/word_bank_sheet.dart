import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WordBankSheet extends StatelessWidget {
  const WordBankSheet({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryVariant,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
        ),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      'Lorem ipsum, $index',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Dolor sit amet, $index',
                      style: const TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
