import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkController extends ChangeNotifier {
  bool isConnected = true;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  NetworkController() {
    _checkInternet();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        _updateConnectionStatus(results.first);
      }
    });
  }

  Future<void> _checkInternet() async {
    var result = await _connectivity.checkConnectivity();
    if (result.isNotEmpty) {
      _updateConnectionStatus(result.first);
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    bool newConnectionStatus = result != ConnectivityResult.none;
    if (isConnected != newConnectionStatus) {
      isConnected = newConnectionStatus;
      notifyListeners();
    }
  }

  Future<void> retryConnection() async {
    await _checkInternet();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}