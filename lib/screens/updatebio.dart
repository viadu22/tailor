import 'package:flutter/material.dart';
import '../screens/updatemeasure.dart';
import '../screens/manage.dart';
import 'package:intl/intl.dart';
import 'package:tailor/services/database_services.dart';

class Updatebio extends StatefulWidget {
  final int selectt;
  final String original;
  final Map<String, dynamic> user;
  final ValueChanged<int> onTabChange;
  final Map<String, dynamic> clients;

  const Updatebio({
    super.key,
    required this.user,
    required this.selectt,
    required this.original,
    required this.clients,
    required this.onTabChange,
  });

  @override
  State<Updatebio> createState() => _UpdatebioState();
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class _UpdatebioState extends State<Updatebio> {
  final DatabaseService _databaseService = DatabaseService.instance;
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController locController;
  late TextEditingController genderController;
  TextEditingController deadlineController = TextEditingController();

  DateTime? selectedDate;

  String? Gender;
  int selectedIndex = 0;

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

  Future<void> updateBio() async {
    final pr = widget.selectt;
    print('selected = $pr');

    // final selectedClient = widget.clients[pr];

    // final int id = int.tryParse(selectedClient['id'].toString()) ?? 0;

    // print('Selected ID: $id');

    final client = await _databaseService.selectUserName(widget.original);
    print(client);

    final cname = nameController.text.trim();
    final cemail = emailController.text.trim();
    final cphone = phoneController.text.trim();
    final clocation = locController.text.trim();
    final cage = ageController.text.trim();
    final cgender = Gender ?? '';
    final cdeadline = deadlineController.text;

    final DateTime now = DateTime.now();
    String date = DateFormat('dd MMM yyyy').format(now);
    String time = DateFormat('HH:mm').format(now);

    final cdatetime = "$date - $time";
    final ccurrentupdate = cdatetime;

    if ([
      cname,
      cemail,
      cphone,
      cgender,
      cage,
      clocation,
      cdeadline,
      ccurrentupdate,
    ].any((e) => e.isEmpty)) {
      showMessage(context, "Please fill all fields");
      return;
    }

    try {
      await _databaseService.updatebio(
        cname,
        cemail,
        cphone,
        cgender,
        cage,
        clocation,
        cdeadline,
        ccurrentupdate,
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Updatemeasure(
          user: widget.user,
          onTabChange: widget.onTabChange,
          name: cname,
          clients: client ?? {},
          identity: pr,
        ),
      ),
    );
  }

  Future<void> loadNames() async {
    final fetchedClients = await _databaseService.getAllClientIds();

    print(fetchedClients);

    // await _databaseService.delClient(widget.clients['name'].toString(),);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Manage(
          user: widget.user,
          onTabChange: widget.onTabChange,
          clients: fetchedClients,
          selectt: 0,
          select: 1,
        ),
      ),
    );

    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Clicked Button');
    });
  }

  List<String> names = [];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(
      text: widget.clients['name'].toString(),
    );
    ageController = TextEditingController(
      text: widget.clients['age'].toString(),
    );
    emailController = TextEditingController(
      text: widget.clients['email'].toString(),
    );
    phoneController = TextEditingController(
      text: widget.clients['phone'].toString(),
    );
    locController = TextEditingController(
      text: widget.clients['location'].toString(),
    );
    Gender = widget.clients['gender']?.toString();

    deadlineController = TextEditingController(
      text: widget.clients['deadline']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    locController.dispose();
    emailController.dispose();
    phoneController.dispose();
    deadlineController.dispose();
    genderController.dispose();
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
                        'Update Bio',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -5,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      buildInputField(
                        controller: nameController,
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
                                  initialValue: Gender,
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
                                      Gender = value;
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

                      buildInputField(
                        controller: emailController,
                        icon: Icons.mail_sharp,
                        width: screenWidth,
                      ),

                      const SizedBox(height: 5),

                      buildInputField(
                        controller: phoneController,
                        icon: Icons.phone_sharp,
                        width: screenWidth,
                      ),

                      const SizedBox(height: 5),

                      // PASSWORD
                      buildInputField(
                        controller: locController,
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

                      // SIGN IN BUTTON
                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.75,
                        child: ElevatedButton(
                          onPressed: updateBio,
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
                          onPressed: loadNames,
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
        decoration: InputDecoration(border: InputBorder.none, icon: Icon(icon)),
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
