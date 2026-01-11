import 'package:logger/logger.dart';

/// Definition of a tool that can be called by AI
class ToolDefinition {
  final String description;
  final bool requiresConfirmation;
  final bool
  requiresReview; // New: requires user review before sending data to AI
  final Function function;

  ToolDefinition({
    required this.description,
    required this.function,
    this.requiresConfirmation = false,
    this.requiresReview = false,
  });
}

class ToolsRegistry {
  // Private constructor
  ToolsRegistry._();

  // Singleton instance
  static ToolsRegistry? _instance;

  // Factory constructor that returns the singleton instance
  factory ToolsRegistry.getInstance() {
    _instance ??= ToolsRegistry();

    return _instance!;
  }

  ToolsRegistry();

  // Private map to store functions
  final Map<String, ToolDefinition> _functions = {};

  // Registers a function with a given name
  void registerFunction(
    String name,
    String description,
    Function function, {
    bool confirm = false,
    bool review = false,
  }) {
    _functions[name] = ToolDefinition(
      description: description,
      function: function,
      requiresConfirmation: confirm,
      requiresReview: review,
    );
    Logger().i(
      'Function "$name" registered with description: $description, confirm: $confirm, review: $review',
    );
  }

  List<String> getFunctionInfos() {
    var functions = _functions.entries.map((entry) {
      return '''{
"name":"${entry.key}",
"description": "${entry.value.description}",
"confirm": ${entry.value.requiresConfirmation}
}''';
    }).toList();

    return functions;
  }

  bool functionExists(String name) {
    return _functions.containsKey(name);
  }

  bool requiresConfirmation(String name) {
    return _functions[name]?.requiresConfirmation ?? false;
  }

  bool requiresReview(String name) {
    return _functions[name]?.requiresReview ?? false;
  }

  String? getDescription(String name) {
    return _functions[name]?.description;
  }

  // Retrieves the description of a function by its name
  // Calls a function by its name with optional parameters
  Future<String> callFunction(String name, List<dynamic> params) async {
    if (_functions.containsKey(name)) {
      return await Function.apply(_functions[name]!.function, params);
    } else {
      throw Exception('Function "$name" is not registered.');
    }
  }
}
