import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final bool isTyping;
  const TypingIndicator({required this.isTyping, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isTyping) return SizedBox.shrink();
    return Row(
      children: [
        SizedBox(width: 4),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _dot(),
                _dot(delay: 200),
                _dot(delay: 400),
              ],
            ),
          ),
        ),
        SizedBox(width: 4),
        Text('Typing...', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _dot({int delay = 0}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 600),
      margin: EdgeInsets.symmetric(horizontal: 1),
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        shape: BoxShape.circle,
      ),
    );
  }
}
