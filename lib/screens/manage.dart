import 'package:flutter/material.dart';
import '../screens/menu.dart';
import '../screens/progress.dart';
import '../screens/updateprogress.dart';
import '../screens/updatebio.dart';
import 'package:tailor/services/database_services.dart';

class Manage extends StatefulWidget {
  final List<Map<String, dynamic>> clients;
  final Map<String, dynamic> user;
  final int selectt;
  final int select;

  final ValueChanged<int> onTabChange;

  const Manage({
    super.key,
    required this.user,
    required this.clients,
    required this.selectt,
    required this.select,
    required this.onTabChange,
  });

  @override
  State<Manage> createState() => _ManageState();
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class _ManageState extends State<Manage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();

  final List<String> options = ["Cotton", "Silk", "Linen", "Wool", "Polyester"];

  final List<String> selectedItems = [];

  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  List<Map<String, dynamic>> pendingitems = [];
  List<Map<String, dynamic>> pendingfilteredItems = [];
  List<Map<String, dynamic>> completeitems = [];
  List<Map<String, dynamic>> completefilteredItems = [];

  int selectedIndex = 0;
  int pendingIndex = 0;
  int completeIndex = 0;

  Future<void> delClient() async {
    final selectedClient = widget.clients[selectedIndex];
    final int id = int.tryParse(selectedClient['id'].toString()) ?? 0;

    await _databaseService.deleteClient(id);

    await loadClients(); // reload data

    if (!mounted) return;

    setState(() {});

    showMessage(context, "Client deleted");
  }

  // Future<void> completeData() async {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) =>
  //           MenuScreen(user: widget.user, onTabChange: widget.onTabChange),
  //     ),
  //   );
  // }

  Future<void> gotoProgress() async {
    final selectedClient = widget.clients[selectedIndex];

    final int id = int.tryParse(selectedClient['id'].toString()) ?? 0;
    print('Selected ID: $id');

    final client = await _databaseService.selectUser(id);
    print(client);

    if (!mounted) return;

    final pendId = await _databaseService.pendIdentity();
    print(pendId);

    final iden = client?['identity'].toString().trim().toLowerCase();

    bool exists = pendId.any((identity) {
      final dbIdentity = identity.trim().toLowerCase();

      return iden == dbIdentity;
    });

    if (exists) {
      showMessage(context, 'Go to Pending Tab to Update');

      return;
    }

    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Progress(
            user: widget.user,
            onTabChange: widget.onTabChange,
            clint: client?['name'],
            proname: 'none',
            iden: client?['identity'],
            dead: client?['deadline'],
          ),
        ),
      );
    } catch (e, stack) {
      debugPrint("❌ ERROR: $e");
      debugPrint("STACK: $stack");
      if (context.mounted) {
        showMessage(context, e.toString());
      }
    }
  }

  Future<void> pushInfo() async {
    final selectedClient = widget.clients[selectedIndex];

    final int id = int.tryParse(selectedClient['id'].toString()) ?? 0;
    print('Selected ID: $id');

    final client = await _databaseService.selectUser(id);
    print(client);

    if (!mounted) return;

    final screenWidth = MediaQuery.of(context).size.width;

    final pendId = await _databaseService.pendIdentity();
    print(pendId);

    final iden = client?['identity'].toString().trim().toLowerCase();

    bool exists = pendId.any((identity) {
      final dbIdentity = identity.trim().toLowerCase();

      return iden == dbIdentity;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Options",
            style: TextStyle(color: Color.fromARGB(255, 59, 8, 85)),
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 5),
              SizedBox(
                height: screenWidth * 0.13,
                width: screenWidth * 0.7,
                child: ElevatedButton(
                  onPressed: () async {
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
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 59, 8, 85),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),

                  child: const Text(
                    "Make Changes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 5),
              SizedBox(
                height: screenWidth * 0.13,
                width: screenWidth * 0.7,
                child: ElevatedButton(
                  onPressed: gotoProgress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 98, 6, 145),
                    disabledBackgroundColor: Colors.grey, // optional
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Update Progress",
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

  Future<void> updateProgress() async {
    final ids = await _databaseService.getProgressIds();
    final pendingClient = ids[pendingIndex];
    print(pendingClient);

    final int id = int.tryParse(pendingClient['id'].toString()) ?? 0;

    final progress = await _databaseService.selectPendingUser(id);
    print(progress);
    print(progress?['percent']);
    print(progress?['progress']);
    print(progress?['name']);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateProgress(
          user: widget.user,
          onTabChange: widget.onTabChange,
          proname: progress?['name'],
          proidentity: progress?['identity'],
          perc: progress?['percent'],
          dead: progress?['deadline'],
          clicked: progress?['progress'] ?? false,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadClients();
    loadPending();
    loadComplete();
  }

  Future<void> loadClients() async {
    final data = await _databaseService.getAllData('clients');

    setState(() {
      items = data;
      filteredItems = data;
    });
  }

  void filterSearch(String query) {
    setState(() {
      filteredItems = items
          .where(
            (item) => item['name'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  Future<void> loadPending() async {
    final data = await _databaseService.getAllData('progress');

    setState(() {
      pendingitems = data;
      pendingfilteredItems = data;
    });
  }

  void pendingfilterSearch(String query) {
    setState(() {
      pendingfilteredItems = pendingitems
          .where(
            (item) => item['name'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  Future<void> loadComplete() async {
    final data = await _databaseService.getAllData('complete');

    setState(() {
      completeitems = data;
      completefilteredItems = data;
    });
  }

  void completefilterSearch(String query) {
    setState(() {
      completefilteredItems = completeitems
          .where(
            (item) => item['name'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 3,
      initialIndex: widget.select.clamp(0, 2),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Orders',
            style: TextStyle(
              color: Colors.white,
              fontSize: 35,
              fontWeight: FontWeight.w300,
            ),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,

          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 0.2,
                  color: const Color.fromARGB(89, 255, 255, 255),
                ),
              ),

              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(15),
                ),

                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,

                dividerColor: const Color.fromARGB(0, 220, 7, 7),

                tabs: const [
                  Tab(text: "Update"),
                  Tab(text: "Pending"),
                  Tab(text: "Complete"),
                ],
              ),
            ),
          ),
        ),

        body: TabBarView(
          children: [
            Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            Container(
                              height: screenHeight * 0.4,
                              width: screenWidth * 0.72,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(133, 202, 202, 202),
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
                                      itemCount: filteredItems.length,
                                      itemBuilder: (context, index) {
                                        final clientt = filteredItems[index];

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 3,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              bottom: 20,
                                            ),
                                            height: screenHeight * 0.10,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                255,
                                                59,
                                                8,
                                                85,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ListTile(
                                              selected: index == selectedIndex,
                                              selectedColor: Colors.amber,
                                              textColor: Colors.white,
                                              leading: Container(
                                                padding: EdgeInsets.only(
                                                  left: 8,
                                                  top: 0.2,
                                                ),
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Text(
                                                  clientt['name'].toString()[0],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                clientt['name']
                                                    .toString()
                                                    .split(RegExp(r'\s+'))
                                                    .take(2)
                                                    .join(' '),
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                              subtitle: Text(
                                                '${clientt['identity'].toString().split(RegExp(r'\s+')).take(2).join(' ')}, '
                                                '${clientt['deadline'].toString().split(RegExp(r'\s+')).take(3).join(' ')}',
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

            // -------------------------Start of Pending Tab----------------------
            Stack(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 229, 150),
                    ),
                  ),
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            Container(
                              height: screenHeight * 0.4,
                              width: screenWidth * 0.72,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: TextField(
                                      controller: controller2,
                                      onChanged: pendingfilterSearch,

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
                                    'ALL PROGRESS',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(206, 0, 0, 0),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.01),

                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: pendingfilteredItems.length,
                                      itemBuilder: (context, index) {
                                        final pendclient =
                                            pendingfilteredItems[index];

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: 0,
                                            bottom: 3,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              bottom: 20,
                                              left: 0,
                                            ),
                                            height: screenHeight * 0.10,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                255,
                                                30,
                                                30,
                                                29,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ListTile(
                                              selected: index == pendingIndex,
                                              selectedColor: Colors.amber,
                                              textColor: Colors.white,
                                              leading: Container(
                                                padding: EdgeInsets.only(
                                                  left: 4,
                                                  top: 7,
                                                ),
                                                width: 40,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  '${(((double.tryParse(pendclient['percent']?.toString() ?? '0') ?? 0) * 100).toInt())}%',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                pendclient['name']
                                                    .toString()
                                                    .split(RegExp(r'\s+'))
                                                    .take(2)
                                                    .join(' '),
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                              subtitle: Text(
                                                '${pendclient['identity'].toString().split(RegExp(r'\s+')).take(2).join(' ')}, '
                                                '${pendclient['deadline'].toString().split(RegExp(r'\s+')).take(3).join(' ')}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  pendingIndex = index;
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
                                onPressed: updateProgress,
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
                                  "Update Progress",
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
                                  "Share Client",
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

            // --------------------------Complete Tab Starts Here ------------------
            Stack(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 171, 255, 195),
                    ),
                  ),
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            Container(
                              height: screenHeight * 0.4,
                              width: screenWidth * 0.72,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(5),
                                    child: TextField(
                                      controller: controller3,
                                      onChanged: completefilterSearch,

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
                                    'COMPLETE ORDERS',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(206, 0, 0, 0),
                                    ),
                                  ),

                                  SizedBox(height: screenHeight * 0.01),

                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: completefilteredItems.length,
                                      itemBuilder: (context, index) {
                                        final comclient =
                                            completefilteredItems[index];

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            left: 0,
                                            bottom: 3,
                                          ),
                                          child: Container(
                                            padding: EdgeInsets.only(
                                              bottom: 20,
                                              left: 0,
                                            ),
                                            height: screenHeight * 0.10,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                255,
                                                0,
                                                132,
                                                57,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: ListTile(
                                              selected: index == completeIndex,
                                              selectedColor: Colors.amber,
                                              textColor: Colors.white,
                                              leading: Container(
                                                padding: EdgeInsets.only(
                                                  left: 4,
                                                  bottom: 5,
                                                ),
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  '✔',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    color: Color.fromARGB(
                                                      255,
                                                      0,
                                                      132,
                                                      57,
                                                    ),
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              title: Text(
                                                comclient['name']
                                                    .toString()
                                                    .split(RegExp(r'\s+'))
                                                    .take(2)
                                                    .join(' '),
                                                maxLines: 1,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                ),
                                              ),
                                              subtitle: Text(
                                                '${comclient['identity'].toString().split(RegExp(r'\s+')).take(2).join(' ')}, '
                                                '${comclient['deadline'].toString().split(RegExp(r'\s+')).take(3).join(' ')}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  completeIndex = index;
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
                                  "View Client",
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
                                  "Share Client",
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
          ],
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

// void progress(BuildContext context) {
  //   Navigator.pop(context); 
  //   final screenWidth = MediaQuery.of(context).size.width;

  //   showDialog(
  //     context: context,
  //     builder: (dialogContext) {
  //       return AlertDialog(
  //         title: const Text(
  //           "Update Progress",
  //           style: TextStyle(color: Color.fromARGB(255, 59, 8, 85)),
  //         ),
  //         backgroundColor: const Color.fromARGB(255, 255, 255, 255),

  //         content: SizedBox(
  //           width: screenWidth * 0.8,
  //           height: 200, // important to constrain ListView
  //           child: ListView.builder(
  //             itemCount: options.length,
  //             itemBuilder: (context, index) {
  //               final option = options[index];
  //               final isSelected = selectedItems.contains(option);

  //               return CheckboxListTile(
  //                 key: ValueKey(option),
  //                 controlAffinity: ListTileControlAffinity.leading,
  //                 dense: true,
  //                 title: Text(
  //                   option,
  //                   style: TextStyle(
  //                     fontWeight: isSelected
  //                         ? FontWeight.w600
  //                         : FontWeight.normal,
  //                   ),
  //                 ),
  //                 value: isSelected,
  //                 onChanged: (bool? value) {
  //                   setState(() {
  //                     if (value == true) {
  //                       selectedItems.add(option);
  //                     } else {
  //                       selectedItems.remove(option);
  //                     }
  //                   });
  //                 },
  //               );
  //             },
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }