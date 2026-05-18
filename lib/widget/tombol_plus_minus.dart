import 'package:flutter/material.dart';

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;

  const PlusMinusButtons({
    Key? key,
    required this.addQuantity,
    required this.deleteQuantity,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: deleteQuantity,
          icon: const Icon(Icons.remove, color: Colors.white),
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        IconButton(
          onPressed: addQuantity,
          icon: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }
}