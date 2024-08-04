
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Screens/Marketing/edit_social_media.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant.dart';

class MarketingScreen extends StatefulWidget {
  const MarketingScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MarketingScreenState createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Marketing',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 20.0,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: (){
                const  EditSocialmedia().launch(context);
              },
              child: Row(
                children: [
                  const Icon(Icons.edit,color: kMainColor,),
                  const SizedBox(width: 5.0,),
                  Text('Edit',style: GoogleFonts.poppins(
                    color: kMainColor,
                  ),),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const  SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0,left: 10.0),
            child: SocialMediaCard(
              iconWidget: const Image(image: AssetImage('images/fb.png'),),
              socialMediaName: 'Facebook',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0,left: 10.0),
            child: SocialMediaCard(
              iconWidget: const Image(image: AssetImage('images/twitter.png'),),
              socialMediaName: 'Twitter',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0,left: 10.0),
            child: SocialMediaCard(
              iconWidget: const Image(image: AssetImage('images/insta.png'),),
              socialMediaName: 'Instagram',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0,left: 10.0),
            child: SocialMediaCard(
              iconWidget: const Image(image: AssetImage('images/linkedin.png'),),
              socialMediaName: 'LinkedIN',
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SocialMediaCard extends StatelessWidget {
  SocialMediaCard({
    Key? key,
    required this.iconWidget,
    required this.socialMediaName,
  }) : super(key: key);

  Widget iconWidget;
  final String socialMediaName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        iconWidget,
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            socialMediaName,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
        const Spacer(),
        Container(
          width: 95,
          height: 40,
          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          decoration: kButtonDecoration.copyWith(color: kMainColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Share',
                style: GoogleFonts.poppins(
                    fontSize: 15.0, color: Colors.white),
              ),
              const Icon(
                Icons.share,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 30.0,
        ),
      ],
    );
  }
}
