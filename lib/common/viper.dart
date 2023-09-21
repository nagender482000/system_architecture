import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Entity
class User {
  final String id;
  final String name;

  User({
    required this.id,
    required this.name,
  });
}

// UserRepository
class UserRepository {
  Future<User> getUser(String userId) async {
    // Simulate fetching user data from an API or database
    await Future.delayed(const Duration(milliseconds: 1000));
    return User(id: "001", name: "NSS");
  }
}

// View
class UserScreen extends StatelessWidget {
  final String userId;

  const UserScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<UserPresenter>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Center(
        child: presenter.user != null
            ? Text('User Name: ${presenter.user!.name}')
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          presenter.fetchUser(userId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// Interactor
class UserInteractor {
  final UserRepository userRepository;

  UserInteractor({required this.userRepository});

  Future<User> fetchUser(String userId) async {
    return userRepository.getUser(userId);
  }
}

// Presenter
class UserPresenter with ChangeNotifier {
  final UserInteractor userInteractor;
  User? _user;
  User? get user => _user;

  UserPresenter({required this.userInteractor});

  void fetchUser(String userId) async {
    final user = await userInteractor.fetchUser(userId);

    _user = user;
    notifyListeners();
  }
}

// Router
class Router {
  void navigateToUserScreen(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => UserPresenter(
            userInteractor: UserInteractor(
              userRepository: UserRepository(),
            ),
          ),
          child: UserScreen(userId: userId),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: ChangeNotifierProvider(
        create: (context) => UserPresenter(
          userInteractor: UserInteractor(
            userRepository: UserRepository(),
          ),
        ),
        child: const UserScreen(userId: '123'),
      ),
    ),
  );
}
