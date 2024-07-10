// conditional_import_io.dart
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

WebSocketChannel getWebSocketChannel(String uri) {
  return IOWebSocketChannel.connect(
    Uri.parse(uri),
    pingInterval: const Duration(seconds: 15),
  );
}
