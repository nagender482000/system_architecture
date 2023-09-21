import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Model
class ChatState {
  final List<ChatMessage> messages;

  ChatState({required this.messages});
}

class ChatMessage {
  final String sender;
  final String message;

  ChatMessage({required this.sender, required this.message});
}

// View
class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatStore = Provider.of<ChatStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Consumer<ChatStore>(
        builder: (context, chatStore, child) {
          final state = chatStore.state;

          return ListView.builder(
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final message = state.messages[index];

              return ListTile(
                title: Text(message.sender),
                subtitle: Text(message.message),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          chatStore.dispatch(SendChatMessageIntent(message: 'Hello!'));
        },
        child: const Icon(Icons.send),
      ),
    );
  }
}

// Intent
class SendChatMessageIntent {
  final String message;

  SendChatMessageIntent({required this.message});
}

// Store
class ChatStore with ChangeNotifier {
  ChatState _state = ChatState(messages: []);

  ChatState get state => _state;

  void dispatch(SendChatMessageIntent intent) {
    // Reducer logic to update state
    _state = reducer(_state, intent);
    notifyListeners();
  }

  ChatState reducer(ChatState state, SendChatMessageIntent intent) {
    return ChatState(
      messages: [
        ...state.messages,
        ChatMessage(sender: 'Me', message: intent.message),
      ],
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatStore(),
      child: const MaterialApp(
        home: ChatView(),
      ),
    ),
  );
}
