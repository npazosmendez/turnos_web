import 'package:flutter/material.dart';

void showErrorDialog({dynamic context, String title = "Algo salió mal", dynamic error}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)
        ),
        content: Text(error),
      );
    }
  );
}