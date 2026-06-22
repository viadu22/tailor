import 'package:flutter/material.dart';
import '../screens/manage.dart';
import 'package:tailor/services/database_services.dart';

class Progress extends StatefulWidget {
  final Map<String, dynamic> user;
  final String clint;
  final String proname;
  final String iden;
  final String dead;
  final ValueChanged<int> onTabChange;

  const Progress({
    super.key,
    required this.user,
    required this.clint,
    required this.proname,
    required this.iden,
    required this.dead,
    
    required this.onTabChange,
  });

  void showMessage(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  State<Progress> createState() => _ProgressState();
}

final DatabaseService _databaseService = DatabaseService.instance;
final TextEditingController emailController = TextEditingController();
final TextEditingController passController = TextEditingController();

class _ProgressState extends State<Progress> {
  final List<String> items = [
    'Material Selection',
    'Measurements',
    'Pattern Making',
    'Cutting',
    'Stitching',
    'Fitting',
    'Finishing',
    'Quality Check',
  ];

  double value = 0.0;

  final Set<String> selectedItems = {};

  Future<void> pend() async {
    // await _databaseService.del();
    final fetchedClients = await _databaseService.getAllClientIds();
    final pendId = await _databaseService.pendIdentity();
    print(pendId);

    final iden = widget.iden.toString().trim().toLowerCase();

    bool exists = pendId.any((identity) {
      final dbIdentity = identity.trim().toLowerCase();

      return iden == dbIdentity;
    });

    if (exists) {
      showMessage(context, "Identity Already Exists");
      return;
    }
    try {
      await _databaseService.penDd(
        widget.clint,
        widget.iden,
        widget.dead,
        value.toString(),
        selectedItems.join(', '),
      );

      // print(widget.clint);
      // print(widget.iden);
      // print(widget.dead);
      // print(selectedItems.join(', '));
      // print(value.toString());
    } catch (e, stack) {
      print("❌ ERROR: $e");
      print("STACK: $stack");
      showMessage(context, e.toString());
      return;
    }

    // if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Manage(
          user: widget.user,
          onTabChange: widget.onTabChange,
          clients: fetchedClients,
          selectt: 3,
          select: 1
        ),
      ),
    );
  }

  Future<void> manage() async {
    final fetchedClients = await _databaseService.getAllClientIds();

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
          select: 1,
        ),
      ),
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
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(174, 255, 255, 255),
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
                  decoration: BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.clint
                                  .toString()
                                  .split(RegExp(r'\s+'))
                                  .take(1)
                                  .join(' '),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -2,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),

                            Text(
                              "'s  Progress",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -2,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      SizedBox(
                        width: screenHeight * 0.40,
                        height: screenHeight * 0.05,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.9,
                            child: Stack(
                              alignment: AlignmentDirectional.center,
                              children: [
                                LinearProgressIndicator(
                                  backgroundColor: Colors.grey.withValues(
                                    alpha: 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.greenAccent,
                                  minHeight: 20,
                                  value: value,
                                ),
                                Text(
                                  '${(value * 100).toInt()}%',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      SizedBox(
                        width: screenHeight * 0.40,
                        height: screenHeight * 0.40,
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 15,
                            top: 15,
                            bottom: 15,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 212, 212, 212),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: items.map((item) {
                                return FilterChip(
                                  selectedColor: const Color.fromARGB(
                                    255,
                                    59,
                                    8,
                                    85,
                                  ),

                                  label: Text(
                                    item,
                                    selectionColor: Colors.white,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  selected: selectedItems.contains(item),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedItems.add(item);
                                      } else {
                                        selectedItems.remove(item);
                                      }
                                      value =
                                          selectedItems.length / items.length;
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.72,
                        child: ElevatedButton(
                          onPressed: pend,
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
                            "Pending",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.72,
                        child: ElevatedButton(
                          onPressed: manage,
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
                            "Complete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.045),
                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.3,
                        child: ElevatedButton(
                          onPressed: manage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(
                              231,
                              28,
                              28,
                              28,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "<",
                            style: TextStyle(
                              fontSize: 24,
                              color: Color.fromARGB(255, 255, 255, 255),
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
