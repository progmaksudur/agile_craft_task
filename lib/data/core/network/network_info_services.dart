import 'dart:async';
import 'dart:io';


import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';



class DeviceNetworkInfo{
  final Connectivity connectivity;

  DeviceNetworkInfo({required this.connectivity});




  Future<bool> isConnected() async {
    List<ConnectivityResult> results = await connectivity.checkConnectivity();

    if (results.contains(ConnectivityResult.none)) {
      return false;
    }

    return await _hasInternetAccess();
  }

  /// Checks actual internet access by pinging an external server.
  Future<bool> _hasInternetAccess() async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Internet lookup failed: $e");
      }
    }
    return false;
  }

  Stream<bool> get onConnectivityChanged async* {
    await for (var result in connectivity.onConnectivityChanged) {
      yield await _checkInternetStatus(result);
    }
  }

  Future<bool> _checkInternetStatus(List<ConnectivityResult> results) async {
    if (results.contains(ConnectivityResult.none)) {
      return false;
    }
    return await _hasInternetAccess();
  }





}