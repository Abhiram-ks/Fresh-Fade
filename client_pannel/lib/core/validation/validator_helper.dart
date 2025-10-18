

class ValidatorHelper {

  
  static String? validatePhoneNumber(String? value){
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
    return 'enter valid phone number';
  }
   return null;
  }


  static String? validateName(String? name){
      if (name == null || name.isEmpty) {
      return 'Please fill the field';
    }
    if (name.startsWith(' ')) {
      return "Name cannot start with a space.";
    }

    if (!RegExp(r'[A-Za-z]').hasMatch(name)) {
      return 'Invalid Name please try.';
    }

    if (!RegExp(r'^[A-Z]').hasMatch(name)) {
      return 'The first letter must be Uppercase.';
    }

    if (name.length < 3) {
      return "Name must be at least 3 characters long";
    }

   return null;
  }

  static String? validatePassword(String? password) {
    
   if (password == null || password.isEmpty) {
      return 'Please fill the field';
   }

    if (password.length < 6 || password.length > 15) {
      return 'Password must be between 6 and 15 range.';
    }

    if (password.contains(' ')) {
      return 'Spaces are not allowed in the password.';
    }

    if (!RegExp(r'^[A-Z]').hasMatch(password)) {
      return 'The first letter must be uppercase.';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }
  
static const double maxTopUpLimit = 10000.0;
static const double minTopUpLimit = 1;
static const double maxWalletCapacity = 30000.0;

static String? validateWallet(String balanceStr, String? amountStr) {
  if (amountStr == null || amountStr.trim().isEmpty) {
    return 'Enter your top-up amount';
  }

  final double? balance = double.tryParse(balanceStr);
  final double? amount = double.tryParse(amountStr);

  if (balance == null) {
    return 'Invalid wallet balance';
  }

  if (amount == null|| amountStr.contains('-')) {
    return 'Please enter a valid positive whole number';
  }

  if (amount < minTopUpLimit || amount > maxTopUpLimit) {
    return 'Top-up amount must be between ₹${minTopUpLimit.toInt()} and ₹${maxTopUpLimit.toInt()}';
  }

  if (balance >= maxWalletCapacity) {
    return 'Wallet is full. Max capacity is ₹${maxWalletCapacity.toInt()}';
  }

  final double remainingCapacity = maxWalletCapacity - balance;

  if (amount > remainingCapacity) {
    return 'Only ₹${remainingCapacity.toInt()} can be added to reach max wallet capacity';
  }

  return null;
}



  static String? validatePasswordMatch(String? password, String? confirmPassword) {
   if (password == null  || password.isEmpty) {
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

  static String? validateAge(String? age) {
    if (age == null || age.isEmpty) {
      return 'Enter your Answer';
    }
    if (!RegExp(r'^\d+$').hasMatch(age)) {
      return 'Age must contain only numbers.';
    }

    int ageValue = int.parse(age);

    if (ageValue < 18) {
      return 'Age must be at least 18.';
    }
    if (ageValue > 149) {
      return 'Age must not exceed 149.';
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

  static String? serching(String? text){
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

  static String? loginValidation(String? password){
    if(password == null || password.isEmpty){
      return 'please enter your password';
    }else if (password.length > 15){
        return 'Oops! That password doesn’t look right.';
    }
    return null;
  }
}
