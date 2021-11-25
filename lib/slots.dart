import 'package:flutter/material.dart';
import './constant.dart';

class Slot extends StatefulWidget {
  final List slots;

  Slot(this.slots);
  @override
  _SlotState createState() => _SlotState();
}

class _SlotState extends State<Slot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Slots'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: widget.slots.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              // color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: kTitleTextColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              height: 310,
              child: Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Centre ID - ' +
                            widget.slots[index]['center_id'].toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Centre Name - ' +
                            widget.slots[index]['name'].toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Centre Address - ' +
                            widget.slots[index]['address'].toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      Divider(),
                      Text(
                        'Vaccine Name - ' +
                            widget.slots[index]['vaccine'].toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      Divider(),
                      Text(
                        'Slots - ' + widget.slots[index]['slots'].toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      Divider(),
                      Text(
                        'Fee - ' + widget.slots[index]['fee'].toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                    ]),
              ),
            );
          },
        ),
      ),
    );
  }
}
