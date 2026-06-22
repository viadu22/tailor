import 'package:flutter/material.dart';
import 'package:tailor/screens/menu.dart';
import 'package:tailor/services/database_services.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final ValueChanged<int> onTabChange;

  const ProfileScreen({
    super.key,
    required this.user,
    required this.onTabChange,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;

  void showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController newController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  void modal() {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Edit Profile",
            style: TextStyle(color: Color.fromARGB(255, 59, 8, 85)),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField(
                icon: Icons.person,
                title: widget.user['name'] ?? '',
                controller: nameController,
              ),
              buildTextField(
                icon: Icons.email,
                title: widget.user['email'] ?? '',
                controller: emailController,
              ),
              buildTextField(
                icon: Icons.phone,
                title: '0${widget.user["phone"]}'.toString(),
                controller: phoneController,
              ),
              const SizedBox(height: 5),
              SizedBox(
                height: screenWidth * 0.13,
                width: screenWidth * 0.7,
                child: ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    final email = emailController.text.trim();
                    final phone = phoneController.text.trim();

                    if (name.isEmpty || email.isEmpty || phone.isEmpty) {
                      showMessage("Please fill all fields");
                      return;
                    }

                    await _databaseService.upDate(
                      id: widget.user['id'].toString(),
                      name: name,
                      email: email,
                      phone: phone,
                    );

                    if (!mounted) return;
                    showMessage("Profile updated!");
                    nameController.clear();
                    emailController.clear();
                    phoneController.clear();
                    setState(() {
                      widget.user['name'] = name;
                      widget.user['email'] = email;
                      widget.user['phone'] = phone;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 59, 8, 85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    "Update Profile",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          
        );
      },
    );
  }

  void modal2() {
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Change Password",
            style: TextStyle(color: Color.fromARGB(255, 59, 8, 85)),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTextField2(
                icon: Icons.lock,
                hintText: 'New Password',
                controller: newController,
              ),
              buildTextField2(
                icon: Icons.lock,
                hintText: 'Confirm Password',
                controller: confirmController,
              ),

              const SizedBox(height: 5),
              SizedBox(
                height: screenWidth * 0.13,
                width: screenWidth * 0.7,
                child: ElevatedButton(
                  onPressed: () async {
                    final password = newController.text.trim();
                    final confirmPassword = confirmController.text.trim();

                    if (password.isEmpty || confirmPassword.isEmpty) {
                      showMessage("Please fill all fields");
                      return;
                    }
                    if (password != confirmPassword) {
                      showMessage("Passwords do not Match");
                      return;
                    }

                    await _databaseService.upDatePass(
                      id: widget.user['id'].toString(),

                      password: password,
                    );

                    if (!mounted) return;
                    showMessage("Password updated!");
                    newController.clear();
                    confirmController.clear();

                    setState(() {
                      widget.user['password'] = password;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 59, 8, 85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    "Change Password",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              height: screenWidth * 0.12,
              width: screenWidth * 0.3,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  "<",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ],
        );
      },
    );
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
            // child: Image.asset('assets/images/fa12.jpg', fit: BoxFit.cover),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -3,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                  height: screenWidth * 1.06,
                  width: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/2147734137.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      buildInfoBox(
                        icon: Icons.person,
                        title: widget.user['name'].toString(),
                        subtitle: "ADMIN",
                      ),

                      buildInfoBox(
                        icon: Icons.email,
                        title: widget.user['email'].toString(),
                        subtitle: "EMAIL",
                      ),

                      buildInfoBox(
                        icon: Icons.phone,
                        title: '0${widget.user["phone"]}'.toString(),
                        subtitle: "PHONE",
                      ),

                      buildInfoBox(
                        icon: Icons.lock,
                        title: '*' * (widget.user['password']?.length ?? 6),
                        subtitle: "PASSWORD",
                      ),

                      const SizedBox(height: 5),

                      Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenWidth * 0.12,
                              width: screenWidth * 0.8,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    59,
                                    8,
                                    85,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: modal,
                                child: const Text(
                                  "Edit Profile",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: screenWidth * 0.12,
                              width: screenWidth * 0.8,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    98,
                                    6,
                                    145,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: modal2,
                                child: const Text(
                                  "Edit Password",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                          builder: (_) => MenuScreen(
                            user: widget.user,
                            onTabChange: widget.onTabChange,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(217, 23, 23, 23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "<",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required IconData icon,
    required String title,
    required controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),

      decoration: BoxDecoration(
        border: Border.all(
          width: 2.5,
          color: const Color.fromARGB(112, 174, 174, 174),
        ),
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 255, 223, 108).withValues(alpha: 0.7),
      ),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: title,
          icon: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 18, 91, 165),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget buildTextField2({
    required IconData icon,
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.5,
          color: const Color.fromARGB(112, 174, 174, 174),
        ),
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 255, 223, 108).withValues(alpha: 0.7),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,

          hintText: hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 48, 48, 48)),

          icon: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 18, 91, 165),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget buildInfoBox({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withValues(alpha: 0.7),
      ),
      child: Row(
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 18, 91, 165),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(subtitle, style: const TextStyle(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}
