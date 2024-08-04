import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void getPermission() async{
    // ignore: unused_local_variable
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  @override
  void initState() {
    super.initState();
    init();
    getPermission();
  }
  var currentUser = FirebaseAuth.instance.currentUser;

  void init() async {
    await Future.delayed(const Duration(seconds: 2), () {

      if (currentUser != null) {
        const Home().launch(context);
      } else {
        const OnBoard().launch(context);
      }
    });
    defaultBlurRadius = 10.0;
    defaultSpreadRadius = 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: context.height()/3,),
            const Image(
              image: AssetImage('images/logoPos.png'),
             
            ),
            const Spacer(),
            Column(
              children: [
                Center(
                  child: Text(
                    '',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 20.0),
                  ),
                ),
                Center(
                  child: Text(
                    'V 2.0.0',
                    style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 15.0),
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
