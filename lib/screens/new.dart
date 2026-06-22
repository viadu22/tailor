import 'package:flutter/material.dart';
import '../screens/menu.dart';
import '../screens/measure.dart';
import 'package:intl/intl.dart';
import 'package:tailor/services/database_services.dart';

class New extends StatefulWidget {
  final Map<String, dynamic> user;
  final ValueChanged<int> onTabChange;
  final Map<String, dynamic> clientinfo;

  const New({
    super.key,
    required this.user,
    required this.clientinfo,
    required this.onTabChange,
  });

  @override
  State<New> createState() => _NewState();
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class _NewState extends State<New> {
  final DatabaseService _databaseService = DatabaseService.instance;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locController = TextEditingController();
  TextEditingController otherController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();

  DateTime? selectedDate;

  // late var selectedDate;

  String? gender;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    ageController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    locController = TextEditingController();
    otherController = TextEditingController();
    deadlineController = TextEditingController();
  }

  // void loadClientInfo(Map<String, dynamic> clientinfo) {
  //   nameController.text = clientinfo['name']?.toString() ?? '';
  //   ageController.text = clientinfo['age']?.toString() ?? '';
  //   emailController.text = clientinfo['email']?.toString() ?? '';
  //   phoneController.text = clientinfo['phone']?.toString() ?? '';
  //   locController.text = clientinfo['location']?.toString() ?? '';
  //   Gender = clientinfo['gender']?.toString() ?? '';
  //   otherController.text = clientinfo['otherinfo']?.toString() ?? '';
  // }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        deadlineController.text = DateFormat('dd MMM, yyyy').format(picked);
      });
    }
  }

  Future<void> Continue() async {
    final cunit = 'unit';
    final cname = nameController.text.trim();
    final cemail = emailController.text.trim();
    final cphone = phoneController.text.trim();
    final clocation = locController.text.trim();
    final cage = ageController.text.trim();
    final cgender = gender ?? '';
    final DateTime now = DateTime.now();
    String date = DateFormat('dd MMM yyyy').format(now);
    String time = DateFormat('HH:mm').format(now);

    final cdatetime = "$date - $time";
    final cdeadline = deadlineController.text;
    print(cdeadline);

    await _databaseService.newClient(
      cunit,
      cname,
      cemail,
      cphone,
      clocation,
      cage,
      cgender,
      cdatetime,
      cdeadline,
    );

    print("✅ Data saved");

    if (!context.mounted) return;

    showMessage(context, "Add Measurements");

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Measure(
          user: widget.user,
          onTabChange: widget.onTabChange,
          name: cname,
          dead: cdeadline,
        ),
      ),
    );

    // if (result != null) {
    //   setState(() {
    //     loadClientInfo(result);
    //   });
    // }
  }

  Future<void> insertBio() async {
    final cunit = 'unit';
    final cname = nameController.text.trim();
    final cemail = emailController.text.trim();
    final cphone = phoneController.text.trim();
    final clocation = locController.text.trim();
    final cage = ageController.text.trim();
    final cgender = gender ?? '';
    final DateTime now = DateTime.now();
    String date = DateFormat('dd MMM yyyy').format(now);
    String time = DateFormat('HH:mm').format(now);

    final cdatetime = "$date - $time";
    final cdeadline = deadlineController.text;
    print(cdeadline);

    if ([
      cunit,
      cname,
      cemail,
      cphone,
      clocation,
      cage,
      cgender,
      cdatetime,
      cdeadline,
    ].any((e) => e.isEmpty)) {
      showMessage(context, "Please fill all fields");
      return;
    }

    final allnames = await _databaseService.getAllNames();

    final enteredFirstName = cname.trim().toLowerCase();

    bool exists = allnames.any((name) {
      final dbFirstName = name.trim().toLowerCase();

      return enteredFirstName == dbFirstName;
    });

    if (exists) {
      final screenWidth = MediaQuery.of(context).size.width;

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(
              "Name Already Exists, Do you want to continue",
              style: TextStyle(color: Color.fromARGB(255, 59, 8, 85)),
            ),
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 5),
                SizedBox(
                  height: screenWidth * 0.13,
                  width: screenWidth * 0.3,
                  child: ElevatedButton(
                    onPressed: Continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 59, 8, 85),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                    child: const Text(
                      "Yes",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(width: screenWidth * 0.02),

                SizedBox(
                  height: screenWidth * 0.13,
                  width: screenWidth * 0.3,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 59, 8, 85),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );

      return;
    }

    try {
      await _databaseService.newClient(
        cunit,
        cname,
        cemail,
        cphone,
        clocation,
        cage,
        cgender,
        cdatetime,
        cdeadline,
      );

      print("✅ Data saved");
    } catch (e, stack) {
      print("❌ ERROR: $e");
      print("STACK: $stack");
      showMessage(context, e.toString());
      return;
    }

    if (!context.mounted) return;

    showMessage(context, "Add Measurements");

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Measure(
          user: widget.user,
          onTabChange: widget.onTabChange,
          name: cname,
          dead: cdeadline,
        ),
      ),
    );

    // if (result != null) {
    //   setState(() {
    //     loadClientInfo(result);
    //   });
    // }
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    locController.dispose();
    emailController.dispose();
    phoneController.dispose();
    otherController.dispose();
    deadlineController.dispose();
    super.dispose();
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
                      image: AssetImage('assets/images/person.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Client Bio',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -5,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // EMAIL
                      buildInputField(
                        controller: nameController,
                        hint: "Name (eg.1st, 2nd, other)",
                        icon: Icons.person_sharp,
                        width: screenWidth,
                      ),

                      const SizedBox(height: 5),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              height: screenWidth * 0.12,
                              width: screenWidth * 0.44,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2.0,
                                  color: const Color.fromARGB(
                                    105,
                                    255,
                                    255,
                                    255,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ).withValues(alpha: 0.85),
                              ),
                              child: SizedBox(
                                width: double.infinity,

                                child: DropdownButtonFormField<String>(
                                  dropdownColor: Colors.black,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  initialValue: gender,
                                  hint: const Text(
                                    "Gender",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),

                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color.fromARGB(177, 0, 0, 0),
                                    prefixIcon: Icon(
                                      Icons.female_sharp,
                                      color: Colors.white,
                                    ),
                                    border: InputBorder.none,
                                  ),

                                  items: ["Male", "Female"]
                                      .map(
                                        (age) => DropdownMenuItem(
                                          value: age,
                                          child: Text(age),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      gender = value;
                                    });
                                  },
                                ),
                              ),
                            ),

                            SizedBox(width: screenHeight * 0.01),
                            buildInputField2(
                              controller: ageController,
                              hint: "Age",
                              icon: Icons.badge,
                              width: screenWidth,
                            ),
                          ],
                        ),
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
                        controller: locController,
                        hint: "Location",
                        icon: Icons.location_city_sharp,
                        width: screenWidth,
                      ),

                      const SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.75,

                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2.0,
                            color: const Color.fromARGB(104, 255, 255, 255),
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(
                            255,
                            0,
                            0,
                            0,
                          ).withValues(alpha: 0.85),
                        ),
                        child: TextField(
                          controller: deadlineController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.date_range_sharp,
                              color: Colors.white,
                            ),
                            hintText: 'Deadline',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                          readOnly: true,
                          style: TextStyle(color: Colors.white),
                          onTap: _pickDate,
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.75,
                        child: ElevatedButton(
                          onPressed: insertBio,
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
                            "Next >>>",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

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
        border: Border.all(
          width: 1.5,
          color: const Color.fromARGB(105, 28, 28, 28),
        ),
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

  // 🔹 Reusable input field
  Widget buildInputField2({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required double width,
    bool obscure = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: width * 0.12,
      width: width * 0.29,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: const Color.fromARGB(105, 28, 28, 28),
        ),
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
