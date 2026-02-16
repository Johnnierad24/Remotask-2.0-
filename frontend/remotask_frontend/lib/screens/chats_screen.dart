import 'package:flutter/material.dart';
import '../widgets/typing_indicator.dart';
import '../l10n/app_localizations.dart';
import '../services/real_time_service.dart';

class ChatsScreen extends StatefulWidget {
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final RealTimeService _realTimeService = RealTimeService();
  List<Map<String, dynamic>> conversations = [
    {
      'username': 'kagwanjajames7',
      'avatarUrl': null,
      'lastMessage': 'kazi tunaanza lini?',
      'timestamp': 'Mon',
      'unread': true,
      'delivered': true,
      'read': false,
      'isTyping': false,
    },
    {
      'username': 'janedoe',
      'avatarUrl': null,
      'lastMessage': 'Project sent! Check your email.',
      'timestamp': 'Sun',
      'unread': false,
      'delivered': true,
      'read': true,
      'isTyping': true,
    },
    // Add more conversations here as needed
  ];
  String searchQuery = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Connect to real-time chat server (replace with your WebSocket URL)
    _realTimeService.connect('wss://your-chat-server.example/ws');
    _realTimeService.onEvent = (type, payload) {
      if (type == 'new_message') {
        setState(() {
          conversations.insert(0, payload);
        });
      }
      if (type == 'typing') {
        setState(() {
          final idx = conversations.indexWhere((c) => c['username'] == payload['username']);
          if (idx != -1) conversations[idx]['isTyping'] = payload['isTyping'];
        });
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filteredConvos = conversations.where((c) =>
      c['username'].toLowerCase().contains(searchQuery.toLowerCase()) ||
      c['lastMessage'].toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.chatTitle(context),
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode, color: Colors.orange),
            onPressed: () {
              // Toggle dark mode (requires app-level support)
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: AppLocalizations.searchHint(context),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey[900] : Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),
          Expanded(
            child: isLoading
                ? ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, i) => ListTile(
                      leading: CircleAvatar(backgroundColor: Colors.grey[300]),
                      title: Container(height: 12, width: 80, color: Colors.grey[300]),
                      subtitle: Container(height: 10, width: 120, color: Colors.grey[200]),
                    ),
                  )
                : filteredConvos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(AppLocalizations.noConversations(context),
                                style: const TextStyle(fontSize: 18, color: Colors.black54)),
                            const SizedBox(height: 8),
                            Text(AppLocalizations.startConversation(context),
                                style: const TextStyle(color: Colors.black38),
                                textAlign: TextAlign.center),
                            const SizedBox(height: 32),
                            FloatingActionButton(
                              onPressed: () {},
                              backgroundColor: Colors.orange,
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredConvos.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final convo = filteredConvos[index];
                          return Dismissible(
                            key: ValueKey(convo['username']),
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 24),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            secondaryBackground: Container(
                              color: Colors.blue,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 24),
                              child: const Icon(Icons.archive, color: Colors.white),
                            ),
                            onDismissed: (direction) {
                              setState(() => conversations.removeWhere((c) => c['username'] == convo['username']));
                            },
                            child: ListTile(
                              leading: convo['avatarUrl'] != null
                                  ? CircleAvatar(backgroundImage: NetworkImage(convo['avatarUrl']))
                                  : CircleAvatar(child: Text(convo['username'][0].toUpperCase())),
                              title: Row(
                                children: [
                                  Text(convo['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
                                  if (convo['isTyping'] == true) ...[
                                    SizedBox(width: 6),
                                    TypingIndicator(isTyping: true),
                                  ]
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  Expanded(child: Text(convo['lastMessage'])),
                                  if (convo['delivered'] == true && convo['read'] == false)
                                    Icon(Icons.done_all, size: 16, color: Colors.grey),
                                  if (convo['read'] == true)
                                    Icon(Icons.done_all, size: 16, color: Colors.blue),
                                ],
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(convo['timestamp'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  if (convo['unread'])
                                    Container(
                                      margin: const EdgeInsets.only(top: 4),
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              onTap: () {
                                // Navigate to chat detail
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
