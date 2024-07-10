// conditional_import_web.dart
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/html.dart';

WebSocketChannel getWebSocketChannel(String uri) {
  return HtmlWebSocketChannel.connect(uri);
}
