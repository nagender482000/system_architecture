// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:system/examples/mvc.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      TodoView(
        controller: TodoController(
          todos: [],
        ),
      ),
    );

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

// Section 7: Testing the Application

// // user_view_model_test.dart
// void main() {
//   test('UserViewModel fetches user successfully', () async {
//     final userRepository = MockUserRepository();
//     final getUserUseCase = GetUserUseCase(userRepository: userRepository);
//     final userViewModel = UserViewModel(getUserUseCase: getUserUseCase);

//     userViewModel.fetchUser('123');

//     expect(userViewModel.user, isNotNull);
//   });
// }

// class MockUserRepository implements UserRepository {
//   @override
//   Future<User> getUser(String userId) {
// // Mock implementation to return a user
//   }
// }
