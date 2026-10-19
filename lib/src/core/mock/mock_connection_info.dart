import '../tools/connection_info.dart';

/// Simula siempre conexión activa en modo mock.
class MockConnectionInfo implements ConnectionInfo {
  @override
  Future<bool> get isConnected async => true;
}
