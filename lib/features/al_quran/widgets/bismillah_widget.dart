import 'package:flutter/material.dart';

class BismillahWidget extends StatelessWidget {
  const BismillahWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        "﷽\n",
        style: TextStyle(
        fontFamily: "Amiri",
        fontSize: 26,
        height: 1,
        color: Theme.of(context).colorScheme.primary,
        ),
        textAlign: TextAlign.center,
      ),
      ),
    );
  }
}