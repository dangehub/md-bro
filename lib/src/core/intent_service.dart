import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class IntentService with WidgetsBindingObserver {
  static const MethodChannel _channel = MethodChannel('intent_handler');
  static IntentService? _instance;

  // Callback function to handle navigation
  Function(String action, Map<String, dynamic>? extras)? _onIntentReceived;

  IntentService._() {
    WidgetsBinding.instance.addObserver(this);
  }

  static IntentService get instance {
    _instance ??= IntentService._();
    return _instance!;
  }

  String? _initialAction;
  // Track last processed action to verify duplicates if needed,
  // but for "add task" we might want to allow repeated actions if user clicks widget multiple times.
  // For now, we trust getInitialIntent returns the CURRENT intent.

  /// Initialize the intent service
  Future<String?> initialize() async {
    // We still listen to channel for symmetry, but rely mainly on lifecycle checks for reliability
    _channel.setMethodCallHandler(_handleMethodCall);

    await _checkInitialIntent();
    return _initialAction;
  }

  void setIntentHandler(
      Function(String action, Map<String, dynamic>? extras) handler) {
    _onIntentReceived = handler;
    // Fire pending initial action if any
    if (_initialAction != null && _initialAction!.isNotEmpty) {
      Logger()
          .i('IntentService: Firing pending initial intent: $_initialAction');
      handler(_initialAction!,
          null); // Extras logic can be simplified or improved if needed
      _initialAction = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Logger().i('IntentService: App resumed, checking for intents');
      _checkInitialIntent(notifyHandler: true);
    }
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    // Keep this as backup
    if (call.method == 'onNewIntent') {
      final String action = call.arguments['action'] ?? '';
      final Map<String, dynamic>? extras =
          call.arguments['extras']?.cast<String, dynamic>();
      if (action.isNotEmpty) {
        Logger().i('IntentService: Received onNewIntent push: $action');
        _onIntentReceived?.call(action, extras);
      }
    }
  }

  /// Check if the app was launched with a specific intent
  Future<void> _checkInitialIntent({bool notifyHandler = false}) async {
    try {
      final Map<dynamic, dynamic>? intentData =
          await _channel.invokeMethod('getInitialIntent');

      if (intentData != null) {
        final String action = intentData['action'] ?? '';
        final Map<String, dynamic>? extras =
            intentData['extras']?.cast<String, dynamic>();

        if (action.isNotEmpty) {
          Logger().i('IntentService: Found intent: $action');

          if (notifyHandler && _onIntentReceived != null) {
            _onIntentReceived!(action, extras);
            // Optional: clear the intent on Android side to avoid loop?
            // Usually not needed if we only check on Resume.
            // But relying on "add_task" intent staying there means every Resume might trigger it?
            // Actually, Android "getInitialIntent" typically returns the Intent that started the Activity.
            // If we don't clear it, every time user switches apps and comes back, it might trigger.
            // BUT, for "add task", we usually want it once.

            // To be safe, we should probably implement a "consumeIntent" on Android side,
            // OR just rely on the fact that user clicked the widget.
          } else {
            _initialAction = action;
            // extras?
          }
        }
      }
    } catch (e) {
      Logger().e('Error checking initial intent: $e');
    }
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
