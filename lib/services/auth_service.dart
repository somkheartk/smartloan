class AuthService {
  static Future<bool> isLoggedIn() async {
    // Simulate a delay for checking login status
    await Future.delayed(Duration(seconds: 2));
    // Replace the following line with actual login status logic
    return false; // Return true if logged in, false otherwise
  }

  static Future<void> login(String username, String password) async {
    // Simulate a delay for login process
    await Future.delayed(Duration(seconds: 2));
    // Replace the following line with actual login logic
    if (username == 'user' && password == 'password') {
      // Simulate successful login
      return;
    } else {
      throw Exception('Invalid username or password');
    }
  }

  static Future<void> logout() async {
    // Simulate a delay for logout process
    await Future.delayed(Duration(seconds: 2));
    // Replace the following line with actual logout logic
    return;
  }
}
