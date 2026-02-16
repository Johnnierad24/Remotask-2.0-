import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  static String chatTitle(BuildContext context) => Intl.message('Messages', name: 'chatTitle');
  static String searchHint(BuildContext context) => Intl.message('Search messages or users', name: 'searchHint');
  static String noConversations(BuildContext context) => Intl.message('No conversations yet', name: 'noConversations');
  static String startConversation(BuildContext context) => Intl.message("Start a conversation by visiting someone's profile and tapping the message button", name: 'startConversation');
  static String typing(BuildContext context) => Intl.message('Typing...', name: 'typing');
  // Add more localized strings as needed
}
