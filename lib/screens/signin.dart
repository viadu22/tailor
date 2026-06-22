import 'package:flutter/material.dart';
import '../screens/signup.dart';
import '../screens/home.dart';
import '../screens/menu.dart';

import 'package:tailor/services/database_services.dart';

class Signin extends StatefulWidget {
  final Map<String, dynamic> user;
  final ValueChanged<int> onTabChange;

  const Signin({super.key, required this.user, required this.onTabChange});

  void showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  State<Signin> createState() => _SigninState();
}

final DatabaseService _databaseService = DatabaseService.instance;
final TextEditingController emailController = TextEditingController();
final TextEditingController passController = TextEditingController();

class _SigninState extends State<Signin> {
  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showMessage(context, "Please fill all fields");
      return;
    }

    try {
      final isValid = await _databaseService.loginUser(email, password);

      if (!mounted) return;

      if (!isValid) {
        showMessage(context, "Invalid email or password");
        return;
      }

      final db = await _databaseService.database;

      final result = await db.query(
        'persons',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (!mounted) return;

      if (result.isEmpty) {
        showMessage(context, "User not found");
        return;
      }

      final user = result.first;

      showMessage(context, "Login successful!");

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MenuScreen(user: user, onTabChange: widget.onTabChange),
        ),
      );
    } catch (e, stack) {
      debugPrint("LOGIN FAILED ERROR: $e");
      debugPrint("STACK TRACE: $stack");

      if (!mounted) return;
      showMessage(context, "Login failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Image.asset('assets/images/130756.jpg', fit: BoxFit.cover),
          ),
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(175, 0, 0, 0),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  height: screenHeight,
                  width: screenWidth,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage('assets/images/fa13.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Log In',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -5,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'TAILOR',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(206, 245, 45, 0),
                              ),
                            ),
                            Text(
                              ' + ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(206, 255, 255, 255),
                              ),
                            ),
                            Text(
                              'CLIENTS',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(184, 255, 115, 0),
                              ),
                            ),
                            Text(
                              ' INFO',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(184, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.15),

                      // EMAIL
                      buildInputField(
                        controller: emailController,
                        hint: "Email",
                        icon: Icons.email_sharp,
                        width: screenWidth,
                      ),

                      const SizedBox(height: 5),

                      // PASSWORD
                      buildInputField(
                        controller: passController,
                        hint: "Password",
                        icon: Icons.lock_sharp,
                        width: screenWidth,
                        obscure: true,
                      ),

                      const SizedBox(height: 10),

                      // SIGN IN BUTTON
                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.75,
                        child: ElevatedButton(
                          onPressed: handleLogin,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              200,
                              245,
                              45,
                              0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "Don't Have an Account?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.75,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Signup(
                                  user: widget.user,
                                  onTabChange: widget.onTabChange,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              200,
                              255,
                              115,
                              0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.07),
                      SizedBox(
                        height: screenHeight * 0.065,
                        width: screenWidth * 0.3,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Home(
                                  user: widget.user,
                                  onTabChange: widget.onTabChange,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              200,
                              255,
                              255,
                              255,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "<",
                            style: TextStyle(
                              color: Color.fromARGB(200, 0, 0, 0),
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Reusable input field
  Widget buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required double width,
    bool obscure = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: width * 0.12,
      width: width * 0.75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(206, 255, 255, 255).withValues(alpha: 0.85),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          icon: Icon(icon),
        ),
      ),
    );
  }
}
