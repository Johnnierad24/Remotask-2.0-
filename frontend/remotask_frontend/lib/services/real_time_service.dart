import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class RealTimeService {
  WebSocketChannel? _channel;
  Function(String, dynamic)? onEvent;

  void connect(String url) {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen((data) {
      final event = jsonDecode(data);
      if (onEvent != null && event is Map && event.containsKey('type')) {
        onEvent!(event['type'], event['payload']);
      }
    });
  }

  void send(String type, dynamic payload) {
    _channel?.sink.add(jsonEncode({'type': type, 'payload': payload}));
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
