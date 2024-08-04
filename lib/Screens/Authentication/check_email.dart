
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/constant.dart';

class CheckEMail extends StatefulWidget {
  const CheckEMail({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CheckEMailState createState() => _CheckEMailState();
}

class _CheckEMailState extends State<CheckEMail> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: Image(
                      image: AssetImage('images/mailbox.png'),
                    ),
                  ),
                  Text(
                    'You Have Got An Email',
                    style: GoogleFonts.poppins(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'We Have Send An Email with instructions on how to reset password to:',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 20.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'example@johndoe.com',
                    style: GoogleFonts.poppins(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),),
              Expanded(
                flex: 1,
                  child: Column(
                children: [
                  ButtonGlobalWithoutIcon(
                    buttontext: 'Check Email',
                    buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                    onPressed: null,
                    buttonTextColor: Colors.white,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/otp');
                    },
                    child: Text(
                      'Close',
                      style: GoogleFonts.poppins(
                        color: kMainColor,
                      ),
                    ),
                  ),
                ],
              ))

            ],
          ),
        ),
      ),
    );
  }
}
