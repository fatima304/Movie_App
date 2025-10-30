import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';

class CrashlyticsHelper {
  static bool _isInitialized = false;
  
  static Future<void> init() async {
    try {
      _isInitialized = Firebase.apps.isNotEmpty;
      
      if (_isInitialized) {
        FlutterError.onError = (errorDetails) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        };

        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          return true;
        };
      }
    } catch (e) {
      _isInitialized = false;
    }
  }

  static void logError(dynamic error, StackTrace? stack, {bool fatal = false}) {
    if (_isInitialized) {
      try {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: fatal);
      } catch (e) {
        // Ignore if Crashlytics not available
      }
    }
  }

  static void logMessage(String message) {
    if (_isInitialized) {
      try {
        FirebaseCrashlytics.instance.log(message);
      } catch (e) {
        // Ignore if Crashlytics not available
      }
    }
  }

  static void setUserId(String userId) {
    if (_isInitialized) {
      try {
        FirebaseCrashlytics.instance.setUserIdentifier(userId);
      } catch (e) {
        // Ignore if Crashlytics not available
      }
    }
  }

  static void setCustomKey(String key, dynamic value) {
    if (_isInitialized) {
      try {
        FirebaseCrashlytics.instance.setCustomKey(key, value);
      } catch (e) {
        // Ignore if Crashlytics not available
      }
    }
  }
}
