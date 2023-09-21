import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Model
class User {
  final String id;
  final String name;

  User({required this.id, required this.name});
}

// user_data_source.dart
abstract class UserDataSource {
  Future<User> getUser(String userId);
}

class ApiUserDataSource implements UserDataSource {
  @override
  Future<User> getUser(String userId) async {
    // Implementation to fetch user data from an API
    await Future.delayed(const Duration(milliseconds: 1000));
    return User(id: "001", name: "NSS");
  }
}

class UserRepository {
  final UserDataSource userDataSource;

  UserRepository({required this.userDataSource});

  Future<User> getUser(String userId) {
    return userDataSource.getUser(userId);
  }
}

// View
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userPresenter = Provider.of<UserPresenter>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Center(
        child: Consumer<UserPresenter>(
          builder: (context, userPresenter, child) {
            final user = userPresenter.user;
            if (user != null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('User ID: ${user.id}'),
                  Text('Name: ${user.name}'),
                ],
              );
            } else {
              return const Text('User data loading...');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Notify the presenter that the user wants to fetch the user data
          userPresenter.fetchUser('123');
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// Presenter
class UserPresenter with ChangeNotifier {
  final UserRepository userRepository;
  User? user;

  UserPresenter({required this.userRepository});

  void fetchUser(String userId) async {
    user = await userRepository.getUser(userId);

    // Notify listeners to update the UI
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserPresenter(
        userRepository: UserRepository(
          userDataSource: ApiUserDataSource(),
        ),
      ),
      child: const MaterialApp(
        home: UserScreen(),
      ),
    ),
  );
}
