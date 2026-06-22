import 'package:flutter/material.dart';

class Clients extends StatefulWidget {
  final void Function(int)? onTabChange;

  const Clients({super.key, this.onTabChange});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: screenHeight * 0.10,
          width: screenWidth * 0.7,
          child: ElevatedButton(
            onPressed: () {
              widget.onTabChange?.call(1); // Profile tab index
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 102, 255, 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text("Clients", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
