import 'dart:convert';
import 'package:vaccine_helper/services/user_simple_preferences.dart';
import './slots.dart';
import 'package:vaccine_helper/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'services/check_slots.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserSimplePreferences.init();
  runApp(MyApp());
}

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

  String pinCodeText = "";
  String formattedDate = "";
  TextEditingController dateinput = TextEditingController();
  String currYear = DateFormat("yyyy").format(DateTime.now());
  String? dropDownValue = DateFormat("MM").format(DateTime.now());
  List slots = [];

  //-----------------------------------------------------------

  fetchslots() async {
    await http
        .get(Uri.parse(
            'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
                pinCodeText +
                '&date=' +
                dateinput.text +
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
  void initState() {
    super.initState();
    pinCodeText = UserSimplePreferences.getPincode() ?? "";
    dateinput.text = UserSimplePreferences.getDate() ?? "";
  }

  //---------------------------------------------------------------
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
              child: TextFormField(
                onChanged: (text) {
                  pinCodeText = text;
                },
                initialValue: pinCodeText,
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
              child: TextField(
                controller: dateinput,
                decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today_rounded),
                    hintText: 'Select Date'),
                readOnly: true,
                onTap: () async {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2022),
                  ).then((pickedDate) {
                    if (pickedDate == null) return;
                    formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                    setState(() {
                      dateinput.text = formattedDate;
                    });
                  });
                },
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
                onPressed: () async {
                  fetchslots();
                  await UserSimplePreferences.setPincode(pinCodeText);
                  await UserSimplePreferences.setDate(dateinput.text);
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
