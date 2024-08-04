// ignore: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/GlobalComponents/button_global.dart';
import 'package:mobile_pos/constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'Contact Details',
          style: GoogleFonts.poppins(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 4.0,
        actions: const [
          Icon(
            Icons.mode_edit_outline,
            color: kGreyTextColor,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.delete_outline,
              color: kGreyTextColor,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Container(
              height: 100.0,
              width: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: const Image(
                image: AssetImage('images/profileimage.png'),
                height: 100.0,
                width: 100.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Clarence',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.black,
              ),
            ),
            Text(
              '+91-9554848868',
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              children: const [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: IconWithText(
                      bgColor: Color(0xFFF1F7F7),
                      title: 'Call',
                      iconData: Icons.call_outlined,
                      iconColor: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: IconWithText(
                      bgColor: kMainColor,
                      title: 'Message',
                      iconData: Icons.message,
                      iconColor: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: IconWithText(
                      bgColor: Color(0xFFF1F7F7),
                      title: 'Email',
                      iconData: Icons.email_outlined,
                      iconColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Transaction',
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Transactions(
                        title: 'Issue',
                        amount: '\₹.1509.09',
                        tranColor: Colors.black,
                        pressed: () {},
                      ),
                      Transactions(
                        title: 'Due',
                        amount: '\₹.509.09',
                        tranColor: kGreyTextColor,
                        pressed: null,
                      ),
                      Transactions(
                        title: 'Promo',
                        amount: '\₹.109.09',
                        tranColor: kGreyTextColor,
                        pressed: null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ButtonGlobalWithoutIcon(buttontext: 'Send', buttonDecoration: kButtonDecoration.copyWith(color: kMainColor), onPressed: null, buttonTextColor: Colors.white),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Transactions extends StatelessWidget {
  Transactions({
    Key? key,
    required this.title,
    required this.amount,
    required this.tranColor,
    required this.pressed,
  }) : super(key: key);
  final String title;
  final String amount;
  final Color tranColor;
  // ignore: prefer_typing_uninitialized_variables
  var pressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pressed,
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20.0,
              color: tranColor,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: GoogleFonts.poppins(
              fontSize: 20.0,
              color: tranColor,
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 15.0,
            color: tranColor,
          ),
        ],
      ),
    );
  }
}

class IconWithText extends StatelessWidget {
  const IconWithText({
    Key? key,
    required this.iconData,
    required this.title,
    required this.bgColor,
    required this.iconColor,
  }) : super(key: key);
  final String title;
  final IconData iconData;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.0,
      width: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: bgColor,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 32,
              color: iconColor,
            ),
            Text(
              title,
              maxLines: 1,
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
