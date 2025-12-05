class AppConstants{
  static const String bearerToken = "bearerToken";
  static const String email = "email";
  static const String phone = "phone";
  static const String address = "address";
  static const String name = "name";
  static const String isEmailVerified = "isEmailVerified";
  static const String image = "image";
  static const String role = "role";
  static const String userId = "userId";
  static const String isLogged = "isLogged";
  static const String fcmToken = "fcmToken";
  static const String mechanicType = "mechanicType";
  static const String emailValidator = "emailValidator";



  static RegExp emailValidate = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool validatePassword(String value) {
    // Currently not used - password validation is now just length check
    // Keeping for potential future use
    return value.length >= 8;
  }
}