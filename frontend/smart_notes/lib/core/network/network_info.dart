import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<InternetConnectionStatus> get onStatusChange;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker? connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected {
    if (kIsWeb || connectionChecker == null) {
      // On web, assume we're connected since we can't check reliably
      return Future.value(true);
    }
    return connectionChecker!.hasConnection;
  }

  @override
  Stream<InternetConnectionStatus> get onStatusChange {
    if (kIsWeb || connectionChecker == null) {
      // On web, return a stream that always indicates connected
      return Stream.value(InternetConnectionStatus.connected);
    }
    return connectionChecker!.onStatusChange;
  }
}
