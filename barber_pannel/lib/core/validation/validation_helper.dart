class ValidatorHelper {

  static String? serching(String? text){
    return null;
  }

  static String? validateEmailId(String? email){
    if(email == null || email.isEmpty){
       return 'Please enter email';
    }

    return null;
  }
  static String? validateLocation(String? text){
    if (text == null || text.isEmpty) {
      return 'Plase fill the field';
    }else{
       if(text.startsWith(' ')){
       return "Cannot start with a space.";
     }
    }
    return null;
  }
 
  // validate amount
   static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter amount';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid amount';
    }
    if (double.tryParse(value) == 0) {
      return 'Amount cannot be 0';
    }
    final pattern = RegExp(r'^(0|[1-9]\d*)(\.\d{2})?$');

    if (!pattern.hasMatch(value)) {
      return 'Enter a valid amount (e.g. 10.00), only 2 digits after dot';
    }

    return null;
  }
  static String? validatePassword(String? password){
    if(password == null || password.isEmpty){
      return 'please enter password';
    }else if(password.length > 25){
      return 'Oops! That password doesn’t look right.';
    }
    return null;
  }

    static String? validatePasswordMatch(
      String? password, String? confirmPassword) {
    if (password == null || password.isEmpty) {
      return 'Create a new Password';
    }
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please fill the field';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match.';
    }
    return null;
  }


    static String? validateText(String? text){
    if (text == null || text.isEmpty) {
      return 'Plase fill the field';
    }else{
       if(text.startsWith(' ')){
       return "Cannot start with a space.";
    }

    if (!RegExp(r'^[A-Z]').hasMatch(text)){
      return "The first letter must be uppercase.";
    }
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'enter valid phone number';
    }
    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the year';
    } else if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'enter valid year';
    }
    return null;
  }
}