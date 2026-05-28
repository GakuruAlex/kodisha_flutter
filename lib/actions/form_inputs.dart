
enum FormTarget { estate, house }

abstract class ActionInput {}

class LoginInput extends ActionInput {
  final String email;
  final String password;

  LoginInput({required this.email, required this.password});
}

class FormSubmitInput extends ActionInput {
  final FormTarget target;            
  final Map<String, dynamic> payload; 
  final int? id;                      

  FormSubmitInput({
    required this.target,
    required this.payload,
    this.id,
  });
}