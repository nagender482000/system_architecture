import 'package:flutter/material.dart';
import 'package:system/examples/mvc.dart';

void main() {
  runApp(MaterialApp(
    home: TodoView(
      controller: TodoController(todos: []),
    ),
  ));
}
