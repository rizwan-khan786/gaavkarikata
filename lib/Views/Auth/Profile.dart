import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String?>>(
      future: _getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No user data'));
        } else {
          String email = snapshot.data!['email'] ?? 'No Email';
          String role = snapshot.data!['role'] ?? 'No Role';
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile',style: TextStyle(color: Colors.white),),
              centerTitle: true,
              backgroundColor: Colors.deepPurple,
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // User Profile Picture
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade100,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.teal.shade800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // User Welcome Text
                    Text(
                      '$email',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$role',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You are now logged in.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.teal.shade600,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Logout Button
                    ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Button color
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<Map<String, String?>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userEmail');
    String? role =
        prefs.getString('role'); // Fetch role from shared preferences
    return {'email': email, 'role': role};
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail'); // Remove user data
    await prefs.remove('role'); // Remove role data
    Get.offAll(() => const Login()); // Navigate back to login page
  }
}
