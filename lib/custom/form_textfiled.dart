import 'package:flutter/material.dart';

class FormularioBilderTextField extends StatelessWidget {
  final String name;
  final double? width;

  final TextEditingController controller;

  const FormularioBilderTextField({
    super.key,
    required this.name,
    required this.controller,
    this.width,

  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width, 
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: name,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
