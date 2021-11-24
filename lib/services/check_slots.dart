import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

const myTask = "syncWithTheBackEnd";
Workmanager wm = new Workmanager();

void checkSlots() {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize Workmanager with the function which you want to invoke after any periodic time
  wm.initialize(callbackDispatcher);

  // Periodic task registration
  wm.registerPeriodicTask(
    "2",
    myTask,
    frequency: Duration(minutes: 15), // change duration according to your needs
  );
}

void callbackDispatcher() {
  wm.executeTask((task, inputdata) async {
    switch (task) {
      case myTask:
        print("this method was called from native!");
        // Fluttertoast.showToast(msg: "this method was called from native!");
        break;

      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        break;
    }
    return Future.value(true);
  });
}

// fetchslots() async {
//     await http
//         .get(Uri.parse(
//             'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
//                 pincodeController.text +
//                 '&date=' +
//                 dayController.text +
//                 '%2F' +
//                 dropDownValue! +
//                 '%2F2021'))
//         .then((value) {
//       Map result = jsonDecode(value.body);
//   }