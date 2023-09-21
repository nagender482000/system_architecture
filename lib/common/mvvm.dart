import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// data_model.dart
class User {
  final String id;
  final String name;

  User({
    required this.id,
    required this.name,
  });
}

// user_data_source.dart
abstract class UserDataSource {
  Future<User> getUser(
    String userId,
  );
}

class ApiUserDataSource implements UserDataSource {
  @override
  Future<User> getUser(String userId) async {
// Implementation to fetch user data from an API
    await Future.delayed(const Duration(milliseconds: 1000));
    return User(id: "001", name: "NSS");
  }
}

// user_repository.dart
class UserRepository {
  final UserDataSource userDataSource;

  UserRepository({
    required this.userDataSource,
  });

  Future<User> getUser(String userId) {
    return userDataSource.getUser(userId);
  }
}

// Section 4: Building the Domain Layer

// user_use_case.dart
class GetUserUseCase {
  final UserRepository userRepository;

  GetUserUseCase({
    required this.userRepository,
  });

  Future<User> getUser(String userId) {
    return userRepository.getUser(userId);
  }
}

// user_view_model.dart
class UserViewModel extends ChangeNotifier {
  final GetUserUseCase getUserUseCase;

  UserViewModel({
    required this.getUserUseCase,
  });

  User? _user;
  User? get user => _user;

  void fetchUser(String userId) {
    getUserUseCase.getUser(userId).then((user) {
      _user = user;
      notifyListeners();
    }).catchError((error) {
// Handle error
    });
  }
}

// user_screen.dart
class UserScreen extends StatelessWidget {
  final String userId;

  const UserScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Center(
        child: userViewModel.user != null
            ? Text('User Name: ${userViewModel.user!.name}')
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userViewModel.fetchUser(userId);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

// main.dart
void main() {
// Dependency injection setup
  final userDataSource = ApiUserDataSource();
  final userRepository = UserRepository(userDataSource: userDataSource);
  final getUserUseCase = GetUserUseCase(userRepository: userRepository);
  final userViewModel = UserViewModel(getUserUseCase: getUserUseCase);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => userViewModel),
      ],
      child: const UserScreen(userId: "001"),
    ),
  );
}
