import 'package:flutter/material.dart';

class ListPlaceholder extends StatefulWidget {
  const ListPlaceholder({super.key});

  @override
  State<ListPlaceholder> createState() => _ListPlaceholderState();
}

class _ListPlaceholderState extends State<ListPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1.0, 0.0),
        end: const Offset(0.0, 0.0),
      ).animate(CurvedAnimation(
        parent: animationController,
        curve: Curves.decelerate,
      )),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: const TextSpan(
                text: 'There\'s ',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'nothing',
                    style: TextStyle(
                      fontSize: 32,
                      fontStyle: FontStyle.italic,
                      color: Color.fromARGB(255, 239, 59, 119),
                    ),
                  ),
                  TextSpan(text: ' here??!?'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: const TextSpan(
                text: 'And you call yourself a ',
                style: TextStyle(
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: 'shopperrr',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 28,
                      color: Color.fromARGB(255, 239, 59, 119),
                    ),
                  ),
                  TextSpan(
                    text: '...',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            const Text(
              'wow',
              style: TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 239, 59, 119),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
