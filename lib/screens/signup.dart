import 'package:flutter/material.dart';
import '../screens/home.dart';
import '../screens/signin.dart';
import 'package:tailor/services/database_services.dart';

class Signup extends StatefulWidget {
  final Map<String, dynamic> user;
  final ValueChanged<int> onTabChange;

  const Signup({super.key, required this.user, required this.onTabChange});

  @override
  State<Signup> createState() => _SignupState();
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class _SignupState extends State<Signup> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController conController = TextEditingController();

  // String? name ;
  // String? email;
  // String? phone;
  // String? password;
  // String? confirmPassword;

  Future<void> handleSignin() async {
    bool isEmpty =
        nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passController.text.trim().isEmpty ||
        conController.text.trim().isEmpty;

    if (isEmpty) {
      showMessage(context, "Please fill all fields");
      return;
    }

    if (passController.text != conController.text) {
      showMessage(context, "Passwords do not match");
      return;
    }

    if (passController.text.length < 8) {
      showMessage(context, "Passwords must include 8 or more Characters");
      return;
    }
    // await DatabaseService.instance.printDbPath();

    await _databaseService.addTask(
      nameController.text.trim(),
      emailController.text.trim(),
      phoneController.text.trim(),
      passController.text.trim(),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            Home(user: widget.user, onTabChange: widget.onTabChange),
      ),
    );

    showMessage(context, "User registered!");
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    passController.clear();
    conController.clear();
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
                      image: AssetImage('assets/images/fa19.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sign Up',
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

                      SizedBox(height: screenHeight * 0.05),

                      // EMAIL
                      buildInputField(
                        controller: nameController,
                        hint: "Name",
                        icon: Icons.person_sharp,
                        width: screenWidth,
                      ),

                      const SizedBox(height: 5),

                      // PASSWORD
                      buildInputField(
                        controller: emailController,
                        hint: "Email",
                        icon: Icons.mail_sharp,
                        width: screenWidth,
                      ),
                      const SizedBox(height: 5),
                      // EMAIL
                      buildInputField(
                        controller: phoneController,
                        hint: "Phone",
                        icon: Icons.phone_sharp,
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
                      const SizedBox(height: 5),
                      buildInputField(
                        controller: conController,
                        hint: "Confirm Password",
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
                          onPressed: handleSignin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              217,
                              245,
                              45,
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
                      SizedBox(height: screenHeight * 0.02),
                      Text(
                        "Already Have an Account?",
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
                                builder: (_) => Signin(
                                  user: widget.user,
                                  onTabChange: widget.onTabChange,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              217,
                              255,
                              115,
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
                      SizedBox(height: screenHeight * 0.05),
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
                              217,
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
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
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
        color: Colors.white.withValues(alpha: 0.85),
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
