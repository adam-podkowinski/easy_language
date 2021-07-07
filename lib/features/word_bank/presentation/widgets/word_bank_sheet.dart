import 'package:flutter/material.dart';

class WordBankSheet extends StatelessWidget {
  const WordBankSheet({
    Key? key,
    required this.radius,
  }) : super(key: key);

  final double radius;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.80,
      initialChildSize: 0.80,
      builder: (context, controller) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryVariant,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radius),
              topRight: Radius.circular(radius),
            ),
          ),
          child: Stack(
            children: [
              ListView.builder(
                controller: controller,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
                          color: Theme.of(context).primaryColorLight,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
