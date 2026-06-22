import 'package:flutter/material.dart';
import '../screens/menu.dart';
import '../screens/updatebio.dart';
import 'package:tailor/services/database_services.dart';

class Update extends StatefulWidget {
  final List<Map<String, dynamic>> clients;
  final Map<String, dynamic> user;
  final int selectt;

  final ValueChanged<int> onTabChange;

  const Update({
    super.key,
    required this.user,
    required this.clients,
    required this.selectt,
    required this.onTabChange,
  });

  @override
  State<Update> createState() => _UpdateState();
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class _UpdateState extends State<Update> {
  final DatabaseService _databaseService = DatabaseService.instance;
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
  final TextEditingController controller = TextEditingController();

  List<String> items = [];
  List<String> filteredItems = [];

  String? Unit;

  int selectedIndex = 0;

  Future<void> delClient() async {
    final selectedClient = widget.clients[selectedIndex];
    final int id = int.tryParse(selectedClient['id'].toString()) ?? 0;

    await _databaseService.deleteClient(id);

    final updatedClients = await _databaseService.getAllClientIds();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => Update(
          user: widget.user,
          onTabChange: widget.onTabChange,
          clients: updatedClients,
          selectt: selectedIndex,
        ),
      ),
    );

    showMessage(context, "Client deleted");
  }

  Future<void> completeData() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            MenuScreen(user: widget.user, onTabChange: widget.onTabChange),
      ),
    );
  }

  Future<void> pushInfo() async {
    final selectedClient = widget.clients[selectedIndex];

    final int id = int.tryParse(selectedClient['id'].toString()) ?? 0;

    print('Selected ID: $id');

    final client = await _databaseService.selectUser(id);
    print(client);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Updatebio(
          user: widget.user,
          onTabChange: widget.onTabChange,
          clients: client ?? {},
          selectt: client?['id'],
          original: client?['name'],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadClients();
  }

  Future<void> loadClients() async {
    final data = await _databaseService.getAllIdentity();

    setState(() {
      items = data;
      filteredItems = data;
    });
  }

  void filterSearch(String query) {
    setState(() {
      filteredItems = items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
            child: Image.asset('assets/images/fa16.jpg', fit: BoxFit.cover),
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
                      image: AssetImage('assets/images/fa16.jpg'),
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
                              'Changes',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w300,
                                letterSpacing: -5,
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      SizedBox(
                        child: Column(
                          children: [
                            Container(
                              height: screenHeight * 0.4,
                              width: screenWidth * 0.72,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(136, 151, 151, 151),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: TextField(
                                      controller: controller,
                                      onChanged: filterSearch,
                                      decoration: InputDecoration(
                                        
                                        hintText: "Search...",
                                        prefixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            7,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.01),

                                  const Text(
                                    'ALL ORDERS',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(206, 0, 0, 0),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.01),

                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: widget.clients.length,
                                      itemBuilder: (context, index) {
                                        final client = widget.clients[index];

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 5,
                                          ),
                                          child: Container(
                                            height: screenHeight * 0.1,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                162,
                                                132,
                                                132,
                                                132,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ListTile(
                                              selected: index == selectedIndex,
                                              selectedTileColor:
                                                  const Color.fromARGB(
                                                    255,
                                                    243,
                                                    215,
                                                    33,
                                                  ),
                                              selectedColor: Colors.amber,
                                              textColor: Colors.white,
                                              leading: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),

                                              title: Text(
                                                maxLines: 1,
                                                client['identity']
                                                    .toString()
                                                    .split(RegExp(r'\s+'))
                                                    .take(2)
                                                    .join(' '),
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              subtitle: Text(
                                                '${client['name'].toString().split(RegExp(r'\s+')).take(2).join(' ')}, '
                                                '${client['deadline'].toString().split(RegExp(r'\s+')).take(3).join(' ')}',

                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),

                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = index;
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            SizedBox(
                              height: screenWidth * 0.13,
                              width: screenWidth * 0.72,
                              child: ElevatedButton(
                                onPressed: pushInfo,
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
                                  "Update Client",
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
                                  "Delete Client",
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
                                    side: const BorderSide(
                                      color: Color.fromARGB(
                                        75,
                                        0,
                                        0,
                                        0,
                                      ), // border color
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
    text = '',
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 7, left: 10, right: 10, top: 5),
      height: width * 0.10,
      width: width * 0.47,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: const Color.fromARGB(105, 28, 28, 28),
        ),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withValues(alpha: 0.85),
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

  Widget circle({
    required TextEditingController controller,
    required double width,
    bool obscure = false,
  }) {
    return Container(
      padding: const EdgeInsets.only(bottom: 7, left: 10, right: 10),
      height: width * 0.10,
      width: width * 0.10,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: const Color.fromARGB(105, 28, 28, 28),
        ),
        borderRadius: BorderRadius.circular(50),
        color: Colors.white.withValues(alpha: 0.85),
      ),
    );
  }
}
