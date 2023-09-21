import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Model
class User {
  final String name;
  final String profilePictureUrl;
  final String bio;

  User({
    required this.name,
    required this.profilePictureUrl,
    required this.bio,
  });
}

// View
class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
      ),
      body: Consumer<UserPresenter>(
        builder: (context, presenter, child) {
          final user = presenter.user;

          if (user == null) {
            return const CircularProgressIndicator();
          }

          return Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user.profilePictureUrl,
                ),
              ),
              Text(user.name),
              Text(user.bio),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final presenter = Provider.of<UserPresenter>(context, listen: false);
          // Update the user profile through the presenter
          presenter.updateUserProfile(
            "ABC",
            "http://example.com/abc.jpg",
            "Hi, ABC here.",
          );
        },
        child: const Icon(Icons.replay_outlined),
      ),
    );
  }
}

// Presenter
class UserPresenter with ChangeNotifier {
  final UserRepository userRepository;
  User? user;

  UserPresenter({
    required this.userRepository,
  });

  Future<void> getUserProfile() async {
    user = await userRepository.getUserProfile();
    notifyListeners(); // Notify listeners to update the UI
  }

  Future<void> updateUserProfile(
      String name, String profilePictureUrl, String bio) async {
    await userRepository.updateUserProfile(name, profilePictureUrl, bio);
    user = User(name: name, profilePictureUrl: profilePictureUrl, bio: bio);
    notifyListeners(); // Notify listeners to update the UI
  }
}

// Repository
class UserRepository {
  Future<User> getUserProfile() async {
    // Simulate fetching user profile data from a remote API or database.
    await Future.delayed(const Duration(seconds: 2));
    return User(
      name: "NSS",
      profilePictureUrl: "http://example.com/nss.jpg",
      bio: "Hi, NSS here.",
    );
  }

  Future<void> updateUserProfile(
      String name, String profilePictureUrl, String bio) async {
    // Simulate updating user profile data in a remote API or database.
    await Future.delayed(const Duration(seconds: 2));
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserPresenter(
        userRepository: UserRepository(),
      ),
      child: const MaterialApp(
        home: UserProfileView(),
      ),
    ),
  );
}
