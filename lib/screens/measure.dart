import 'package:flutter/material.dart';
import '../screens/new.dart';
import '../screens/menu.dart';
import 'package:intl/intl.dart';
import 'package:tailor/services/database_services.dart';

class Measure extends StatefulWidget {
  final String name;
  final String dead;
  final Map<String, dynamic> user;
  final ValueChanged<int> onTabChange;

  const Measure({
    super.key,
    required this.user,
    required this.onTabChange,
    required this.name,
    required this.dead,
  });

  @override
  State<Measure> createState() => _MeasureState();
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class _MeasureState extends State<Measure> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final TextEditingController identityController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController neckController = TextEditingController();
  final TextEditingController shoulderController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController ubustController = TextEditingController();
  final TextEditingController waistController = TextEditingController();
  final TextEditingController bwidthController = TextEditingController();
  final TextEditingController blengthController = TextEditingController();
  final TextEditingController flengthController = TextEditingController();
  final TextEditingController sleeveController = TextEditingController();
  final TextEditingController bicepController = TextEditingController();
  final TextEditingController wristController = TextEditingController();
  final TextEditingController armholeController = TextEditingController();
  final TextEditingController waistdController = TextEditingController();
  final TextEditingController hipController = TextEditingController();
  final TextEditingController seatController = TextEditingController();
  final TextEditingController friseController = TextEditingController();
  final TextEditingController briseController = TextEditingController();
  final TextEditingController outseamController = TextEditingController();
  final TextEditingController inseamController = TextEditingController();
  final TextEditingController kneeController = TextEditingController();
  final TextEditingController thighController = TextEditingController();
  final TextEditingController calfController = TextEditingController();
  final TextEditingController ankleController = TextEditingController();
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController otherController2 = TextEditingController();

  String? attire;
  String? unit;
  int selectedIndex = 0;

  Future<void> pushbackInfo() async {
    final client = await _databaseService.getByName('clients', widget.name);

    print(client);

    if (!mounted) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => New(
          user: widget.user,
          onTabChange: widget.onTabChange,
          clientinfo: client ?? {},
        ),
      ),
    );

    if (!mounted) return;

    await _databaseService.deleteLastByName('clients', widget.name);

    if (!mounted) return;

    Navigator.pop(context, result);
  }

  Future<void> delClient() async {
    await _databaseService.delClient(widget.name);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MenuScreen(user: widget.user, onTabChange: widget.onTabChange),
      ),
    );
  }

  Future<void> completeData() async {
    final cname = widget.name;
    // final cunit = Unit;
    final cidentity = identityController.text.trim();
    final cheight = heightController.text.trim();
    final clength = lengthController.text.trim();
    final cneck = neckController.text.trim();
    final cshoulder = shoulderController.text.trim();
    final cchest = chestController.text.trim();
    final cubust = ubustController.text.trim();
    final cwaist = waistController.text.trim();
    final cbwidth = bwidthController.text.trim();
    final cblength = blengthController.text.trim();
    final cflength = flengthController.text.trim();
    final csleeve = sleeveController.text.trim();
    final cbicep = bicepController.text.trim();
    final cwrist = wristController.text.trim();
    final carmhole = armholeController.text.trim();
    final cwaistd = waistdController.text.trim();
    final chip = hipController.text.trim();
    final cseat = seatController.text.trim();
    final cfrise = friseController.text.trim();
    final cbrise = briseController.text.trim();
    final coutseam = outseamController.text.trim();
    final cinseam = inseamController.text.trim();
    final cthigh = thighController.text.trim();
    final ccalf = calfController.text.trim();
    final cknee = kneeController.text.trim();
    final cankle = ankleController.text.trim();
    final cother = otherController2.text.trim();

    bool isEmpty =
        cheight.isEmpty ||
        unit.toString().isEmpty ||
        cidentity.isEmpty ||
        attire.toString().isEmpty;

    if (isEmpty) {
      showMessage(context, "Please fill height or Unit or Identity or Attire");
      return;
    }

    final allIdentity = await _databaseService.getAllIdentity();
    print(allIdentity);

    final enteredIdentity = cidentity.toString().trim().toLowerCase();

    bool exists = allIdentity.any((name) {
      final dbIdentity = name.toLowerCase();

      return enteredIdentity == dbIdentity;
    });

    if (exists) {
      showMessage(context, "Identity Already Exists");
      return;
    }

    try {
      await _databaseService.comPlete(
        cname: widget.name,
        cattire: attire.toString(),
        cidentity: cidentity,
        cunit: unit.toString(),
        cheight: cheight,
        cneck: cneck,
        cshoulder: cshoulder,
        cchest: cchest,
        cubust: cubust,
        cwaist: cwaist,
        cbwidth: cbwidth,
        cblength: cblength,
        cflength: cflength,
        csleeve: csleeve,
        cbicep: cbicep,
        cwrist: cwrist,
        carmhole: carmhole,
        cwaistd: cwaistd,
        chip: chip,
        cseat: cseat,
        cfrise: cfrise,
        cbrise: cbrise,
        coutseam: coutseam,
        cinseam: cinseam,
        cthigh: cthigh,
        ccalf: ccalf,
        cknee: cknee,
        cankle: cankle,
        clength: clength,
        cother: cother,
      );

      print("✅ Data saved");
    } catch (e, stack) {
      print("❌ ERROR: $e");
      print("STACK: $stack");
      showMessage(context, e.toString());
      return;
    }

    if (!context.mounted) return;

    showMessage(context, "Client data completed");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MenuScreen(user: widget.user, onTabChange: widget.onTabChange),
      ),
    );

    final DateTime now = DateTime.now();

    final cdatetime = DateFormat('EEEE, d MMMM yyyy HH:mm:ss').format(now);
    print(cdatetime);

    await _databaseService.cashin(
      cname,
      cidentity,
      widget.dead,
      0.0,
      cdatetime.toString(),
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
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.name.toString().split(' ').first,

                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -5,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            Text(
                              "'s Data",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -5,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.035),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 3, right: 2),
                              height: screenWidth * 0.12,
                              width: screenWidth * 0.35,
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
                                height: 30,

                                child: DropdownButtonFormField<String>(
                                  initialValue: unit,
                                  dropdownColor: Colors.black,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  hint: const Text(
                                    "Unit",
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
                                      Icons.scale_sharp,
                                      color: Colors.white,
                                    ),
                                    border: InputBorder.none,
                                  ),

                                  items: ["Yard", "Cent"]
                                      .map(
                                        (age) => DropdownMenuItem(
                                          value: age,
                                          child: Text(age),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      unit = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: screenHeight * 0.01),

                            Container(
                              padding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                bottom: 10,
                              ),
                              height: screenWidth * 0.12,
                              width: screenWidth * 0.2,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.5,
                                  color: const Color.fromARGB(105, 28, 28, 28),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                              child: SizedBox(
                                width: double.infinity,

                                child: TextField(
                                  controller: heightController,
                                  decoration: InputDecoration(
                                    hintText: "Height",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: screenHeight * 0.01),
                            unitBlock(
                              width: 50,
                              height: 42,
                              text: unit ?? 'Unit',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.010),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 6),
                              padding: EdgeInsets.only(left: 3, right: 2),
                              height: screenWidth * 0.12,
                              width: screenWidth * 0.35,
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
                                height: 30,
                                child: DropdownButtonFormField<String>(
                                  initialValue: attire,
                                  dropdownColor: Colors.black,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  hint: const Text(
                                    "Attire",
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
                                      Icons.shopping_cart_sharp,
                                      color: Colors.white,
                                    ),
                                    border: InputBorder.none,
                                  ),

                                  items: ["Shirt", "Skirt", "Trouser", "Other"]
                                      .map(
                                        (age) => DropdownMenuItem(
                                          value: age,
                                          child: Text(age),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      attire = value;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: screenHeight * 0.01),

                            Container(
                              padding: EdgeInsets.only(
                                left: 5,
                                right: 5,
                                bottom: 10,
                              ),
                              height: screenWidth * 0.12,
                              width: screenWidth * 0.36,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1.5,
                                  color: const Color.fromARGB(105, 28, 28, 28),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withValues(alpha: 0.85),
                              ),
                              child: SizedBox(
                                width: double.infinity,

                                child: TextField(
                                  controller: identityController,
                                  decoration: InputDecoration(
                                    hintText: "ID",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: screenHeight * 0.01),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      SizedBox(
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
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
                                        'UPPER BODY',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                            206,
                                            245,
                                            45,
                                            0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: neckController,
                                        hint: "Neck",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: shoulderController,
                                        hint: "Shoulder",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: chestController,
                                        hint: "Chest",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: ubustController,
                                        hint: "U-Bust",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: waistController,
                                        hint: "Waist",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: bwidthController,
                                        hint: "B Width",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: blengthController,
                                        hint: "B Length",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: flengthController,
                                        hint: "F Length",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: sleeveController,
                                        hint: "Sleeve",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: bicepController,
                                        hint: "Bicep",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: wristController,
                                        hint: "Wrist",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: armholeController,
                                        hint: "Armhole",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'LOWER BODY',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromARGB(
                                            206,
                                            245,
                                            45,
                                            0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: waistdController,
                                        hint: "Waist",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: hipController,
                                        hint: "Hip",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: seatController,
                                        hint: "Seat",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: friseController,
                                        hint: "F Rise",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: briseController,
                                        hint: "B Rise",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: outseamController,
                                        hint: "Outseam",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: inseamController,
                                        hint: "Inseam",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: thighController,
                                        hint: "Thigh",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: kneeController,
                                        hint: "Knee",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: calfController,
                                        hint: "Calf",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 1),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildInputField2(
                                        controller: ankleController,
                                        hint: "Ankle",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      buildInputField2(
                                        controller: lengthController,
                                        hint: "Length",
                                        width: screenWidth,
                                      ),
                                      SizedBox(width: screenHeight * 0.01),
                                      unitBlock(
                                        width: 50,
                                        height: 37,
                                        text: unit ?? 'Unit',
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          bottom: 10,
                                          top: 5,
                                        ),
                                        height: screenWidth * 0.18,
                                        width: screenWidth * 0.72,

                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 2.0,
                                            color: const Color.fromARGB(
                                              104,
                                              28,
                                              28,
                                              28,
                                            ),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: const Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ).withValues(alpha: 0.85),
                                        ),
                                        child: TextField(
                                          controller: otherController2,
                                          maxLines: null,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.all(0),
                                            hintText: 'Other Info',
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 10),

                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.72,
                        child: ElevatedButton(
                          onPressed: completeData,
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
                            "Complete Info ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.72,
                        child: ElevatedButton(
                          onPressed: delClient,
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
                            "Cancel Process",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      // SizedBox(
                      //   height: screenHeight * 0.065,
                      //   width: screenWidth * 0.3,
                      //   child: ElevatedButton(
                      //     onPressed: pushbackInfo,
                      //     style: ElevatedButton.styleFrom(
                      //       backgroundColor: const Color.fromARGB(
                      //         217,
                      //         255,
                      //         255,
                      //         255,
                      //       ),
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(30),
                      //       ),
                      //     ),
                      //     child: const Text(
                      //       "<",
                      //       style: TextStyle(
                      //         color: Color.fromARGB(255, 0, 0, 0),
                      //         fontSize: 24,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: screenHeight * 0.02),
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

  Widget unitBlock({
    required double width,
    required double height,
    String text = "",
  }) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 7, top: 5),
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2.0,
          color: const Color.fromARGB(105, 255, 255, 255),
        ),
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.85),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 14,
        ),
      ),
    );
  }

  Widget buildInputField2({
    required TextEditingController controller,
    required String hint,
    required double width,
    bool obscure = false,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 7, left: 10, right: 10),
      height: width * 0.10,
      width: width * 0.27,
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
        decoration: InputDecoration(hintText: hint, border: InputBorder.none),
      ),
    );
  }
}
