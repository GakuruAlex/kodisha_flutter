
/// The strict list of domain targets supported by our form system
enum FormTarget { estate, house }

/// Base marker class for all UI execution intents
abstract class ActionInput {}

/// Specialized input strictly for authentication
class LoginInput extends ActionInput {
  final String email;
  final String password;

  LoginInput({required this.email, required this.password});
}

/// The single, unified action container that handles all creation and updates
class FormSubmitInput extends ActionInput {
  final FormTarget target;            // What model is being processed
  final Map<String, dynamic> payload; // The processed map data with text/files
  final int? id;                      // Null = Create, Filled = Update

  FormSubmitInput({
    required this.target,
    required this.payload,
    this.id,
  });
}