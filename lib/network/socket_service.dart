// socket_service.dart
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:otobix_crm/utils/socket_events.dart';

class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  static SocketService get instance => _instance;

  IO.Socket? _socket; // <-- nullable
  bool get isConnected => _socket?.connected == true;

  void initSocket(String serverUrl) {
    if (_socket != null) return; // idempotent: ignore double init

    final s = IO.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'reconnection': true,
      'reconnectionAttempts': 10,
      'reconnectionDelay': 3000,
    });

    _socket = s;

    s.connect();

    s.onConnect((_) {
      debugPrint('🟢 Connected to Otobix\'s Websocket Server.');
      _onReconnect();
    });

    s.onDisconnect((_) {
      debugPrint('🔴 Disconnected from Otobix\'s Websocket Server');
    });

    s.onConnectError((e) => debugPrint('⚠️ Connect error: $e'));
    s.onError((e) => debugPrint('❌ Socket error: $e'));
  }

  // Public API — never access _socket outside this class
  void joinRoom(String roomId) => _socket?.emit(SocketEvents.joinRoom, roomId);
  void leaveRoom(String roomId) =>
      _socket?.emit(SocketEvents.leaveRoom, roomId);
  void on(String event, Function(dynamic) handler) =>
      _socket?.on(event, handler);
  void off(String event, [void Function(dynamic)? handler]) {
    if (_socket == null) return;
    handler != null ? _socket!.off(event, handler) : _socket!.off(event);
  }

  void emit(String event, dynamic data) => _socket?.emit(event, data);

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }

  void _onReconnect() {
    // Rejoin rooms only if socket exists
    _socket?.emit(SocketEvents.joinRoom, SocketEvents.upcomingBidsSectionRoom);
    _socket?.emit(SocketEvents.joinRoom, SocketEvents.liveBidsSectionRoom);
    _socket?.emit(SocketEvents.joinRoom, SocketEvents.otobuyCarsSectionRoom);
    _socket?.emit(
        SocketEvents.joinRoom, SocketEvents.auctionCompletedCarsSectionRoom);
    debugPrint('🔄 Socket reconnected, rooms rejoined');
  }
}
