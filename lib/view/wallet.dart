import 'package:flutter/material.dart';
import 'package:sqlite_test/helper/databasehelper.dart';
import 'package:sqlite_test/model/walletItem.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final textController = TextEditingController();
  var listData = [];
  int? selectedId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
        controller: textController,
      )),
      body: Center(
          child: FutureBuilder<List<WalletItem>>(
        future: DatabaseHelper.instance.getWalletData(),
        builder:
            (BuildContext context, AsyncSnapshot<List<WalletItem>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Loading !!! '),
            );
          }
          return snapshot.data!.isEmpty
              ? Center(
                  child: Text('No Wallet in List ${snapshot.data!.length}'),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedId == null) {
                            textController.text = snapshot.data![index].title!;
                            selectedId = snapshot.data![index].id;
                          } else {
                            textController.text = "";
                            selectedId = null;
                          }
                        });
                      },
                      onLongPress: () {
                        setState(() {
                          DatabaseHelper.instance
                              .removeWallet(snapshot.data![index].id!);
                        });
                        print("Delete ${index} ");
                      },
                      child: Card(
                        color: selectedId == snapshot.data![index].id!
                            ? Colors.white70
                            : Colors.white,
                        margin: EdgeInsets.all(10.0),
                        child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Text('${snapshot.data![index].title}')),
                      ),
                    );
                  });
        },
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () async {
            selectedId != null
                ? await DatabaseHelper.instance.updateWallet(WalletItem(
                    id: selectedId,
                    title: '${textController.text}',
                    description: '300',
                    date: 'Date',
                    amount: 3))
                : await DatabaseHelper.instance.addWallet(WalletItem(
                    title: '${textController.text}',
                    description: '300',
                    date: 'Date',
                    amount: 3));
            setState(() {
              textController.clear();
              selectedId = null;
            });
            print("Saved Wallet ${textController.text} ");
          }),
    );
  }
}
