import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MyHeaderBar extends StatelessWidget {
  final String title;

  const MyHeaderBar({required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: InkWell(
                onTap: () => Modular.to.canPop() ? Modular.to.pop() : null,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: colorScheme.onPrimary,
                  child: Icon(
                    Icons.arrow_back_sharp,
                    color: colorScheme.primary,
                    size: 15,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: FittedBox(
                  child: Text(
                    title,
                    maxLines: 1,
                    style: TextStyle(
                      color: colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const Flexible(child: SizedBox(width: 40)),
          ],
        ),
      ),
    );
  }
}
