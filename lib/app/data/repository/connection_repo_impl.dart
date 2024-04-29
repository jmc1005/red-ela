import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

import '../../domain/repository/connection_repo.dart';
import '../services/remote/check_connection.dart';

class ConnectionRepoImpl implements ConnectionRepo {
  ConnectionRepoImpl(this._connectivity, this._checkConnection);

  final Connectivity _connectivity;
  final CheckConnection _checkConnection;

  @override
  Future<bool> get hasInternet async {
    try {
      final result = await _connectivity.checkConnectivity();

      if (result == ConnectivityResult.none) {
        return false;
      }

      return _checkConnection.hasInternet();
    } on PlatformException catch (e) {
      developer.log("Couldn't check connectivity status", error: e);
      return false;
    }
  }
}
