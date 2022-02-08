import 'package:flutter/material.dart';
import 'package:sqlite_test/helper/databasehelper.dart';
import 'package:sqlite_test/model/item.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
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
          child: FutureBuilder<List<Item>>(
        future: DatabaseHelper.instance.getItemData(),
        builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text('Loading !!! '),
            );
          }
          return snapshot.data!.isEmpty
              ? Center(
                  child: Text('No Groceries in List ${snapshot.data!.length}'),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          if (selectedId == null) {
                            textController.text = snapshot.data![index].name;
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
                              .remove(snapshot.data![index].id!);
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
                            child: Text('${snapshot.data![index].name}')),
                      ),
                    );
                  });
        },
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.save),
          onPressed: () async {
            selectedId != null
                ? await DatabaseHelper.instance.update(Item(
                    id: selectedId,
                    name: '${textController.text}',
                    price: '300',
                    quantity: 3))
                : await DatabaseHelper.instance.add(Item(
                    name: '${textController.text}', price: '300', quantity: 3));
            setState(() {
              textController.clear();
              selectedId = null;
            });
            print("Saved ${textController.text} ");
          }),
    );
  }
}
