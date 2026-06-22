import 'package:flutter/material.dart';
import '../screens/menu.dart';
import 'package:tailor/services/database_services.dart';

class Print extends StatefulWidget {
  final Map<String, dynamic> user;
  final int selectt;
  final String original;

  final ValueChanged<int> onTabChange;

  const Print({
    super.key,
    required this.user,
    required this.selectt,
    required this.original,
    required this.onTabChange,
  });

  @override
  State<Print> createState() => _PrintState();
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

Future<void> pushInfo() async {}

class _PrintState extends State<Print> {
  final DatabaseService _databaseService = DatabaseService.instance;
  TextEditingController controller = TextEditingController();
  TextEditingController nameController = TextEditingController();

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
            child: Image.asset('assets/images/fa11.jpg', fit: BoxFit.cover),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.original
                            .toString()
                            .split(RegExp(r'\s+'))
                            .take(1)
                            .join(' '),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      Text(
                        "'s Data",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -1,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.04),

                Container(
                  height: screenHeight * 0.4,
                  width: screenWidth * 0.72,
                  padding: const EdgeInsets.only(top: 10, left: 5, right: 5,bottom: 10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(233, 101, 205, 158),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'BIO DATA',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(206, 245, 45, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildInputField(
                                controller: nameController,
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.65,
                                text: 'name',
                                prefixIcon: Icons.person_sharp,
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.005),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildInputField(
                                controller: nameController,
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.32,
                                text: 'Age',
                                prefixIcon: Icons.person_sharp,
                              ),
                              SizedBox(width: screenHeight * 0.005),
                              buildInputField(
                                controller: nameController,
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.32,
                                text: 'Gender',
                                prefixIcon: Icons.person_sharp,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildInputField(
                                controller: nameController,
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.32,
                                text: 'Unit',
                                prefixIcon: Icons.person_sharp,
                              ),
                              SizedBox(width: screenHeight * 0.005),
                              buildInputField(
                                controller: nameController,
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.32,
                                text: 'height',
                                prefixIcon: Icons.person_sharp,
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              
                            ],
                          ),
                        ),
                       SizedBox(height: screenHeight * 0.005),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buildInputField(
                                controller: nameController,
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.65,
                                text: 'email',
                                prefixIcon: Icons.person_sharp,
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              buildInputField(
                                controller: nameController,
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.65,
                                text: 'phone',
                                prefixIcon: Icons.person_sharp,
                              ),
                              SizedBox(height: screenHeight * 0.005),
                              buildInputField(
                                controller: nameController,
                                height: screenHeight * 0.06,
                                width: screenWidth * 0.65,
                                text: 'location',
                                prefixIcon: Icons.person_sharp,
                              ),

                              Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'BIO DATA',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromARGB(206, 245, 45, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                              
                            ],
                          ),
                        ),
                        const SizedBox(height: 3),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),

                SizedBox(
                  height: screenWidth * 0.13,
                  width: screenWidth * 0.72,
                  child: ElevatedButton(
                    onPressed: pushInfo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(217, 245, 45, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "View Client",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                SizedBox(height: screenHeight * 0.05),
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
                      backgroundColor: const Color.fromARGB(217, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(
                          color: Color.fromARGB(75, 0, 0, 0), // border color
                          width: 2.5, // border width
                        ),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField({
    required String text,
    required double width,
    required double height,
    required IconData prefixIcon,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: const Color.fromARGB(105, 28, 28, 28),
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withValues(alpha: 0.85),
      ),
      child: Row(
        children: [
          Icon(prefixIcon, color: Colors.grey[700]),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
