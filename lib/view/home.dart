import 'package:flutter/material.dart';
import 'package:sqlite_test/view/event.dart';
import 'package:sqlite_test/view/wallet.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EventPage()),
                  );
                },
                child: Text("Event")),
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WalletPage()),
                  );
                },
                child: Text("Wallet"))
          ],
        ),
      ),
    );
  }
}
