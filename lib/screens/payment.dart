import 'package:flutter/material.dart';
import '../screens/menu.dart';
import '../screens/print.dart';
import 'package:intl/intl.dart';
import 'package:tailor/services/database_services.dart';

class Payment extends StatefulWidget {
  final List<Map<String, dynamic>> clients;
  final Map<String, dynamic> user;
  final int selectt;
  final int select;

  final ValueChanged<int> onTabChange;

  const Payment({
    super.key,
    required this.user,
    required this.clients,
    required this.selectt,
    required this.select,
    required this.onTabChange,
  });

  @override
  State<Payment> createState() => _PaymentState();
}

void showMessage(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
}

class _PaymentState extends State<Payment> {
  final DatabaseService _databaseService = DatabaseService.instance;
  TextEditingController controller = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController amountcontroller = TextEditingController();

  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  List<Map<String, dynamic>> historyitems = [];
  List<Map<String, dynamic>> historyfilteredItems = [];

  int selectedIndex = 0;
  int historyIndex = 0;

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
        builder: (_) => Print(
          user: widget.user,
          onTabChange: widget.onTabChange,
          // clients: client ?? {},
          selectt: client?['id'],
          original: client?['name'],
        ),
      ),
    );
  }

  Future<void> addcash() async {
    final DateTime now = DateTime.now();

    final cdate = DateFormat('EEEE, d MMMM yyyy').format(now);
    final ctime = DateFormat('HH:mm:ss').format(now);
    final cdatetime = DateFormat('EEEE, d MMMM yyyy HH:mm:ss').format(now);
   
    final selectedClient = widget.clients[selectedIndex];

    final int id = int.tryParse(selectedClient['id'].toString()) ?? 0;

    final client = await _databaseService.selectUser(id);
    final amt = await _databaseService.selectAmount('payments', id);
    final fetchedClients = await _databaseService.getAllClientIds();

    final existingPayment = (amt?['payment'] as num).toDouble();
    final enteredAmount = double.tryParse(amountcontroller.text) ?? 0.0;

    final amount = existingPayment + enteredAmount;

    await _databaseService.updateCash(
      cidentity: client?['identity'],
      cpayment: amount,
      ccurrentupdate: cdatetime,
    );

    await _databaseService.historyin(
      client?['name'],
      client?['identity'],
      amountcontroller.text.toString(),
      cdate,
      ctime,
    );

    showMessage(context, 'Payment Updated');
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

  Future<void> payment() async {
    final selectedClient = widget.clients[selectedIndex];

    final int id = int.tryParse(selectedClient['id'].toString()) ?? 0;

    final amt = await _databaseService.selectAmount('payments', id);
    final client = await _databaseService.selectUser(id);

    if (!mounted) return;

    final screenWidth = MediaQuery.of(context).size.width;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "${client?['name'].split(' ')[0] ?? 'Client'} 's Payments",
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
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2.0,
                      color: const Color.fromARGB(105, 7, 7, 7),
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                  child: TextField(
                    controller: amountcontroller,
                    style: TextStyle(fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: 'Cash in - ${amt?['payment']}'.toString(),
                      border: InputBorder.none,
                      icon: Icon(Icons.money),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),
              SizedBox(
                height: screenWidth * 0.13,
                width: screenWidth * 0.7,
                child: ElevatedButton(
                  onPressed: addcash,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 98, 6, 145),
                    disabledBackgroundColor: Colors.grey, // optional
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Make Payment",
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

  @override
  void initState() {
    super.initState();
    loadClients();
    loadHistory();
  }

  Future<void> loadClients() async {
    final data = await _databaseService.getAllData('payments');

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

  Future<void> loadHistory() async {
    final data2 = await _databaseService.getAllData('moneyhistory');

    setState(() {
      historyitems = data2;
      historyfilteredItems = data2;
    });
  }

  void historyfilterSearch(String query) {
    setState(() {
      historyfilteredItems = historyitems
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
      length: 2,
      initialIndex: widget.select.clamp(0, 2),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Payments',
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
                  Tab(text: "Payments"),
                  Tab(text: "History"),
                ],
              ),
            ),
          ),
        ),

        body: TabBarView(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: Image.asset(
                    'assets/images/fa11.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: screenHeight * 0.4,
                        width: screenWidth * 0.72,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(233, 255, 255, 255),
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
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),

                            Expanded(
                              child: ListView.builder(
                                itemCount: filteredItems.length,
                                itemBuilder: (context, index) {
                                  final client2 = filteredItems[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Container(
                                      height: screenHeight * 0.12,
                                      decoration: BoxDecoration(
                                        color: index == selectedIndex
                                            ? const Color.fromARGB(
                                                255,
                                                98,
                                                6,
                                                145,
                                              )
                                            : const Color.fromARGB(
                                                255,
                                                59,
                                                8,
                                                85,
                                              ),

                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.all(8.0),
                                            dense: true,
                                            visualDensity:
                                                VisualDensity.compact,
                                            minVerticalPadding: 0,
                                            selected: index == selectedIndex,
                                            selectedColor: Colors.amber,
                                            selectedTileColor: Colors.yellow,
                                            textColor: Colors.white,

                                            title: Container(
                                              margin: EdgeInsets.only(
                                                bottom: 2,
                                              ),
                                              height: screenHeight * 0.052,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      top: 2.5,
                                                      bottom: 2.5,
                                                      left: 4,
                                                      right: 4,
                                                    ),
                                                    width: screenHeight * 0.14,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                            200,
                                                            255,
                                                            115,
                                                            0,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '₵${client2['payment'] ?? 0}'
                                                          .toString(),
                                                      selectionColor:
                                                          Colors.amber,
                                                      style: TextStyle(
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255,
                                                            ),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: screenHeight * 0.005,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      top: 2,
                                                      bottom: 2,
                                                      left: 5,
                                                      right: 4,
                                                    ),
                                                    width: screenHeight * 0.17,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      client2['name']
                                                          .toString(),
                                                      selectionColor:
                                                          Colors.amber,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            subtitle: Container(
                                              padding: EdgeInsets.only(
                                                left: 5,
                                                top: 2,
                                              ),
                                              height: screenHeight * 0.04,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                  255,
                                                  255,
                                                  255,
                                                  255,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                selectionColor: Colors.amber,
                                                '${client2['identity'].toString().split(RegExp(r'\s+')).take(2).join(' ')}, '
                                                '${client2['deadline'].toString().split(RegExp(r'\s+')).take(3).join(' ')}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),

                                            onTap: () {
                                              setState(() {
                                                selectedIndex = index;
                                              });
                                            },
                                          ),
                                        ],
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
                          onPressed: payment,
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
                            "Update Payment",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.72,
                        child: ElevatedButton(
                          onPressed: () {},
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

            // ------------------------------History Starts from here ------------------
            Stack(
              children: [
                SizedBox(
                  width: screenWidth,
                  height: screenHeight,
                  child: Image.asset(
                    'assets/images/fa11.jpg',
                    fit: BoxFit.cover,
                  ),
                ),

                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: screenHeight * 0.4,
                        width: screenWidth * 0.72,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(233, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: TextField(
                                controller: controller2,
                                onChanged: historyfilterSearch,

                                decoration: InputDecoration(
                                  hintText: "Search...",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.01),

                            Expanded(
                              child: ListView.builder(
                                itemCount: historyfilteredItems.length,
                                itemBuilder: (context, index) {
                                  final clientt = historyfilteredItems[index];

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Container(
                                      height: screenHeight * 0.12,
                                      decoration: BoxDecoration(
                                        color: index == historyIndex
                                            ? const Color.fromARGB(
                                                255,
                                                98,
                                                6,
                                                145,
                                              )
                                            : const Color.fromARGB(
                                                255,
                                                59,
                                                8,
                                                85,
                                              ),

                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        children: [
                                          ListTile(
                                            contentPadding: EdgeInsets.all(8.0),
                                            dense: true,
                                            visualDensity:
                                                VisualDensity.compact,
                                            minVerticalPadding: 0,
                                            selected: index == historyIndex,
                                            selectedColor: Colors.amber,
                                            selectedTileColor: Colors.yellow,
                                            textColor: Colors.white,

                                            title: Container(
                                              margin: EdgeInsets.only(
                                                bottom: 2,
                                              ),
                                              height: screenHeight * 0.052,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      top: 2.5,
                                                      bottom: 2.5,
                                                      left: 4,
                                                      right: 4,
                                                    ),
                                                    width: screenHeight * 0.14,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                            200,
                                                            255,
                                                            115,
                                                            0,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      '₵${clientt['payment'] ?? 0}'
                                                          .toString(),
                                                      selectionColor:
                                                          Colors.amber,
                                                      style: TextStyle(
                                                        color:
                                                            const Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255,
                                                            ),
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: screenHeight * 0.005,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      top: 2,
                                                      bottom: 2,
                                                      left: 5,
                                                      right: 4,
                                                    ),
                                                    width: screenHeight * 0.17,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          const Color.fromARGB(
                                                            255,
                                                            255,
                                                            255,
                                                            255,
                                                          ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    child: Text(
                                                      clientt['name']
                                                          .toString(),
                                                      selectionColor:
                                                          Colors.amber,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            subtitle: Container(
                                              padding: EdgeInsets.only(
                                                left: 5,
                                                top: 2,
                                              ),
                                              height: screenHeight * 0.04,
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                  255,
                                                  255,
                                                  255,
                                                  255,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                selectionColor: Colors.amber,
                                                '${clientt['identity'].toString().split(RegExp(r'\s+')).take(2).join(' ')}, '
                                                '${clientt['date'].toString().split(',')[1]}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),

                                            onTap: () {
                                              setState(() {
                                                historyIndex = index;
                                              });
                                            },
                                          ),
                                        ],
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
                          onPressed: payment,
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
                            "Update Payment",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),

                      SizedBox(
                        height: screenWidth * 0.13,
                        width: screenWidth * 0.72,
                        child: ElevatedButton(
                          onPressed: () {},
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
          ],
        ),
      ),
    );
  }
}
