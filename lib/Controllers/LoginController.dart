import 'package:gaavkarikatta/Views/Auth/Login.dart';
import 'package:gaavkarikatta/Views/Bottombar.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _checkIfLoggedIn();
  }

  // Check if the user is already logged in
  Future<void> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');
    String? role = prefs.getString('role');
    if (userEmail != null) {
      // If email exists in preferences, navigate to HomeScreen
      Get.offAll(() => HomeScreen()); // 'offAll' will remove all previous screens
    }
  }

  // Login function
  Future<void> login() async {
    final url = Uri.parse('https://res-zpd2.onrender.com/api/auth/login');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': username.value,
        'password': password.value,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['msg'] == 'Login successful') {
        // Save user email and role in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userEmail', data['user']['email']);
        prefs.setString('role', data['user']['role']); // Save role as well

        Get.snackbar('Success', 'Login Successful!');
        Get.offAll(() => HomeScreen());
      } else {
        Get.snackbar('Error', 'Invalid credentials');
      }
    } else {
      Get.snackbar('Error', 'Failed to login');
    }
  }

  // Logout function
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userEmail'); // Clear saved user data
    prefs.remove('role'); // Clear saved role
    Get.snackbar('Success', 'Logged out successfully');
    Get.offAll(() => Login()); // Navigate to the login screen
  }
}
