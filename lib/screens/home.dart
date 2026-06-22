import 'package:flutter/material.dart';
import '../screens/signin.dart';
import '../screens/signup.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> user;
  final ValueChanged<int> onTabChange;

  const Home({super.key, required this.user,required this.onTabChange});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
            child: Image.asset(
              'assets/images/fa17.jpg',
              fit: BoxFit.fill,
            ),
          ),

          Container(
            width: screenWidth,
            height: screenHeight,
            color: const Color.fromARGB(112, 0, 0, 0),
          ),

          Center(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.2),

                const Text(
                  'Mesha',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -2,
                    color: Color.fromARGB(255, 255, 207, 36),
                  ),
                ),

                const SizedBox(height: 10),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('TAILOR', style: TextStyle(color: Color.fromARGB(206, 245, 45, 0))),
                    Text(' + ', style: TextStyle(color: Colors.white)),
                    Text('CLIENTS', style: TextStyle(color: Color.fromARGB(184, 255, 115, 0))),
                    Text(' INFO', style: TextStyle(color: Colors.white)),
                  ],
                ),

                SizedBox(height: screenHeight * 0.25),

                Container(
                  height: screenHeight * 0.3,
                  width: screenWidth * 0.8,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Already Have an Account?',
                        style: TextStyle(color: Colors.white),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.65,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Signin(user: widget.user,
                                  onTabChange: widget.onTabChange,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(170, 245, 45, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Sign In",style: TextStyle(
                            color: Colors.white
                          ),),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      const Text(
                        "Don't Have an Account?",
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.65,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Signup(user: widget.user,
                                  onTabChange: widget.onTabChange,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(170, 255, 115, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text("Sign Up",style: TextStyle(
                            color: Colors.white
                          ),),
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
}