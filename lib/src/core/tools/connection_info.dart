import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class ConnectionInfo {
  Future<bool> get isConnected;
}

class ConnectionInfoImpl implements ConnectionInfo {
  ConnectionInfoImpl(this.connectionChecker);
  final InternetConnectionChecker connectionChecker;

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}
