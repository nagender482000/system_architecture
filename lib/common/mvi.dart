import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class User {
  final String id;
  final String name;

  User({
    required this.id,
    required this.name,
  });
}

class UserDataSource {
  Future<User> getUser(String userId) async {
    // Simulate fetching user data from an API
    await Future.delayed(const Duration(milliseconds: 1000));
    return User(id: "001", name: "NSS");
  }
}

class UserRepository {
  final UserDataSource userDataSource;

  UserRepository({
    required this.userDataSource,
  });

  Future<User> getUser(String userId) {
    return userDataSource.getUser(userId);
  }
}

// State
class UserViewState {
  final User? user;

  UserViewState({this.user});
}

// Actions (Intents)
class FetchUserAction {
  final String userId;

  FetchUserAction({required this.userId});
}

// Reducer
UserViewState userReducer(UserViewState prevState, dynamic action) {
  if (action is FetchUserAction) {
    return UserViewState(user: null); // Loading state
  } else if (action is User) {
    return UserViewState(user: action);
  }
  return prevState;
}

class UserStore with ChangeNotifier {
  final UserRepository userRepository;

  UserStore({required this.userRepository});

  UserViewState _state = UserViewState();

  UserViewState get state => _state;

  Future<void> dispatch(dynamic action) async {
    if (action is FetchUserAction) {
      final user = await userRepository.getUser(action.userId);
      _state = userReducer(_state, user);
      notifyListeners();
    }
  }
}

class UserScreen extends StatelessWidget {
  final String userId;

  const UserScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final userStore = Provider.of<UserStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Center(
        child: userStore.state.user != null
            ? Text('User Name: ${userStore.state.user!.name}')
            : const CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userStore.dispatch(FetchUserAction(userId: userId));
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserStore(
        userRepository: UserRepository(
          userDataSource: UserDataSource(),
        ),
      ),
      child: const MaterialApp(
        home: UserScreen(userId: '123'),
      ),
    ),
  );
}
