import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/Screens/Authentication/login_form.dart';
import 'package:mobile_pos/Screens/Authentication/register_form.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Image(
              image: AssetImage('images/logoandname.png'),
               height:300
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'Create a Free Account',
                  style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.normal, fontSize: 20.0),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: ButtonGlobalWithoutIcon(
                  buttontext: 'Login',
                  buttonTextColor: Colors.white,
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kMainColor,
                  ),
                  onPressed: () {
                    const LoginForm().launch(context);
                    // Navigator.pushNamed(context, '/loginForm');
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Center(
                child: ButtonGlobalWithoutIcon(
                  buttontext: 'Register',
                  buttonTextColor: Colors.white,
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: const Color(0xFF19AAF8),
                  ),
                  onPressed: () {
                    const RegisterScreen().launch(context);
                    // Navigator.pushNamed(context, '/signup');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
