import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';
import '../Home/home.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150.0,
            ),
            const Image(
              image: AssetImage('images/success.png'),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Text(
              'Congratulations',
              style: GoogleFonts.poppins(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: kGreyTextColor,
                  fontSize: 20.0,
                ),
              ),
            ),
            const Spacer(),
            ButtonGlobalWithoutIcon(
                buttontext: 'Continue',
                buttonDecoration: kButtonDecoration.copyWith(color: kMainColor),
                onPressed: () {
                  const Home().launch(context);
                  // Navigator.pushNamed(context, '/home');
                },
                buttonTextColor: Colors.white),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
