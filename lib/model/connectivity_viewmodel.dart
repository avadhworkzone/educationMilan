import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../utils/collection_utils.dart';

class ConnectivityViewModel extends GetxController {
  final Connectivity _connectivity = Connectivity();
  bool? _isOnline;
  bool? get isOnline => _isOnline;

  /// Start monitoring connectivity changes
  void startMonitoring() async {
    await _initConnectivity();

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.none) {
        _isOnline = false;
      } else {
        _isOnline = await _hasNetworkAccess();
      }
      update();
    });
  }

  /// Initialize connectivity check at startup
  Future<void> _initConnectivity() async {
    try {
      final status = await _connectivity.checkConnectivity();
      _isOnline = status != ConnectivityResult.none;
      update();
    } on PlatformException catch (e) {
      log("PlatformException: $e");
      _isOnline = false;
      update();
    }
  }

  /// Confirm actual internet access
  Future<bool> _hasNetworkAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  /// Fetch app metadata from Firestore
  Future<Map<String, dynamic>?> getAppMetaData() async {
    try {
      final doc = await CollectionUtils.appMetaDataCollection.doc("snehMilanMetaData").get();
      final data = doc.data();
      if (data != null) {
        log("Fetched App MetaData: $data");
        return data;
      } else {
        log("No metadata found in Firestore.");
        return null;
      }
    } catch (e) {
      log("Error fetching metadata: $e");
      return null;
    }
  }
}
