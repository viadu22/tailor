import 'package:flutter/material.dart';

import '../screens/clients.dart';
import '../screens/home.dart';
import '../screens/menu.dart';
import '../screens/new.dart';
import '../screens/payment.dart';
import '../screens/print.dart';
import '../screens/manage.dart';
import '../screens/measure.dart';
import '../screens/progress.dart';
import '../screens/updateprogress.dart';
import '../screens/updatebio.dart';
import '../screens/updatemeasure.dart';
import '../screens/updateclient.dart';
import '../screens/profile.dart';

class Nav extends StatefulWidget {
  final Map<String, dynamic> user;

  const Nav({super.key, required this.user});

  @override
  State<Nav> createState() => _NavState();
}

class _NavState extends State<Nav> {
  int _currentIndex = 1;

  late final List<Widget> _pages = [
    Clients(onTabChange: _onTabChange),
    Home(user: widget.user, onTabChange: _onTabChange),
    ProfileScreen(user: widget.user, onTabChange: _onTabChange),
    MenuScreen(user: widget.user, onTabChange: _onTabChange),
    New(user: widget.user, onTabChange: _onTabChange, clientinfo: {}),
    Updatebio(
      user: widget.user,
      onTabChange: _onTabChange,
      clients: {},
      selectt: 0,
      original: '',
    ),

    Measure(
      name: '',
      user: widget.user,
      onTabChange: _onTabChange,
      dead: '',
    ),
    Updatemeasure(
      name: '',
      user: widget.user,
      onTabChange: _onTabChange,
      clients: {},
      identity: 0,
    ),

    Update(
      clients: [],
      user: widget.user,
      onTabChange: _onTabChange,
      selectt: 0,
    ),

    Payment(
      clients: [],
      user: widget.user,
      onTabChange: _onTabChange,
      selectt: 0,
      select: 0,
    ),

    Print(
      // clients: [],
      user: widget.user,
      onTabChange: _onTabChange,
      selectt: 0,
      original: '',
    ),

    Manage(
      clients: [],
      user: widget.user,
      onTabChange: _onTabChange,
      selectt: 0,
      select: 0,
    ),

    Progress(
      user: widget.user,
      onTabChange: _onTabChange,
      clint: '',
      proname: '',
      iden: '',
      dead: '',
    ),

    UpdateProgress(
      user: widget.user,
      onTabChange: _onTabChange,
      proidentity: '',
      proname: '',
      perc: '',
      clicked: '',
      dead: '',
    ),
  ];

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),

      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: _onTabChange,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.search), label: "Clients"),
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),

      //   ],
      // ),
    );
  }
}
