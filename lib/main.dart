import 'dart:convert';
import './slots.dart';
import 'package:vaccine_helper/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        fontFamily: "Poppins",
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ---------------------------------------------------------

  TextEditingController pincodeController = TextEditingController();
  TextEditingController dayController = TextEditingController();
  String currYear = DateFormat("yyyy").format(DateTime.now());
  String? dropDownValue = DateFormat("MM").format(DateTime.now());
  List slots = [];

  //-----------------------------------------------------------

  fetchslots() async {
    await http
        .get(Uri.parse(
            'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
                pincodeController.text +
                '&date=' +
                dayController.text +
                '%2F' +
                dropDownValue! +
                '%2F2021'))
        .then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        slots = result['sessions'];
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Slot(slots)));
      // print(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                height: 350,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color(0xFF3383CD),
                      Color(0xFF11249F),
                    ],
                  ),
                  image: DecorationImage(
                    image: AssetImage("assets/images/virus.png"),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 60,
                        ),
                        Expanded(
                          child: Stack(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/Drcorona.svg",
                                width: 230,
                                fit: BoxFit.fitWidth,
                                alignment: Alignment.topCenter,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              child: TextField(
                controller: pincodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: TextStyle(
                  color: kBodyTextColor,
                ),
                decoration: InputDecoration(
                  hintText: "Enter PIN Code",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(40, 0, 40, 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: dayController,
                        style: TextStyle(
                          color: kBodyTextColor,
                        ),
                        decoration: InputDecoration(hintText: 'Enter Date'),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    height: 52,
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: dropDownValue,
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      underline: Container(
                        color: Colors.grey.shade400,
                        height: 2,
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          dropDownValue = newValue;
                        });
                      },
                      items: <String>[
                        '01',
                        '02',
                        '03',
                        '04',
                        '05',
                        '06',
                        '07',
                        '08',
                        '09',
                        '10',
                        '11',
                        '12'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ))
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 250,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 6,
                  primary: Colors.blue[900],
                ),
                onPressed: () {
                  fetchslots();
                },
                child: Text('Find Slots'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
