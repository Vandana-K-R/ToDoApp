import 'package:flutter/material.dart';

void showErrorMesaage(BuildContext context, {required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(backgroundColor: Colors.red),
    ),
    backgroundColor: Colors.red,
  ));
}
void showSuccessMesaage(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
