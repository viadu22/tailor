import 'package:tailor/screens/profile.dart';
import '../screens/new.dart';
import '../screens/signin.dart';
import 'manage.dart';
import 'payment.dart';
import 'package:flutter/material.dart';
import 'package:tailor/services/database_services.dart';

class MenuScreen extends StatefulWidget {
  final Function(int) onTabChange;
  final Map<String, dynamic> user;

  const MenuScreen({super.key, required this.onTabChange, required this.user});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService.instance;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Future<void> loadNames() async {
    //   final fetchedClients = await databaseService.getAllClientIds();

    //   print(fetchedClients);

    //   if (!mounted) return;

    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => Update(
    //         user: widget.user,
    //         onTabChange: widget.onTabChange,
    //         clients: fetchedClients,
    //         selectt: 0,
    //       ),
    //     ),
    //   );
    // }

    Future<void> fetchNames() async {
      final fetchedClients = await databaseService.getAllClientIds();
      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Payment(
            user: widget.user,
            onTabChange: widget.onTabChange,
            clients: fetchedClients,
            selectt: 0,
            select: 0,
          ),
        ),
      );
    }

    Future<void> manage() async {
      final fetchedClients = await databaseService.getAllClientIds();

      print(fetchedClients);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Manage(
            user: widget.user,
            onTabChange: widget.onTabChange,
            clients: fetchedClients,
            selectt: 0,
            select: 0,
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: screenWidth,
            height: screenHeight,
            child: Image.asset('assets/images/fa26.jpg', fit: BoxFit.cover),
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Menu',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -3,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),

                SizedBox(height: screenHeight * 0.005),

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

                SizedBox(height: screenHeight * 0.04),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              user: widget.user,
                              onTabChange: widget.onTabChange,
                            ),
                          ),
                        ),

                        child: _menuItem(
                          screenWidth,
                          'My Profile',
                          'assets/images/2148212642.jpg',
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.015),

                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => New(
                              user: widget.user,
                              onTabChange: widget.onTabChange,
                              clientinfo: {},
                            ),
                          ),
                        ),
                        child: _menuItem(
                          screenWidth,
                          'New Order',
                          'assets/images/fa16.jpg',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.015),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => manage(),
                        child: _menuItem(
                          screenWidth,
                          'Manage Orders',
                          'assets/images/2148212652.jpg',
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.015),

                      GestureDetector(
                        onTap: () => fetchNames(),
                        child: _menuItem(
                          screenWidth,
                          'Payments',
                          'assets/images/fa20.jpg',
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: screenHeight * 0.015),

                SizedBox(height: screenHeight * 0.045),
                SizedBox(
                  height: screenWidth * 0.13,
                  width: screenWidth * 0.3,
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
                      backgroundColor: const Color.fromARGB(231, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "<",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 12, 90, 3),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.010),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(double screenWidth, String title, String imagePath) {
    return Container(
      padding: const EdgeInsets.only(left: 15, top: 18),
      height: screenWidth * 0.20,
      width: screenWidth * 0.70,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2.5,
          color: const Color.fromARGB(51, 112, 255, 2),
        ),
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    );
  }
}
