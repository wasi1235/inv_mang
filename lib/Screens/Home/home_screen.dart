// ignore: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_pos/Provider/customer_provider.dart';
import 'package:mobile_pos/Screens/Home/components/grid_items.dart';
import 'package:mobile_pos/Screens/Profile%20Screen/profile_details.dart';
import 'package:mobile_pos/constant.dart';
import 'package:mobile_pos/model/personal_information_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Provider/profile_provider.dart';
import '../Sales/sales_contact.dart';
import '../Shimmers/home_screen_appbar_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> color = [
    const Color(0xffEDFAFF),
    const Color(0xffFFF6ED),
    const Color(0xffEAFFEA),
    const Color(0xffEAFFEA),
    const Color(0xffEDFAFF),
    const Color(0xffFFF6ED),
    const Color(0xffFFF6ED),
  ];
  List<Map<String, dynamic>> sliderList = [
    {
      "icon": 'images/banner1.png',
    },
    {
      "icon": 'images/banner2.png',
    }
  ];
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    Consumer(builder: (context, ref, __) {
      ref.watch(customerProvider);
      return Container();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(builder: (_, ref, __) {
        AsyncValue<PersonalInformationModel> userProfileDetails = ref.watch(profileDetailsProvider);
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: userProfileDetails.when(data: (details) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              const ProfileDetails().launch(context);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                image:
                                    DecorationImage(image: NetworkImage(details.pictureUrl ?? ''), fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                details.companyName ?? '',
                                style: GoogleFonts.poppins(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                details.businessCategory ?? '',
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          // Container(
                          //   height: 40.0,
                          //   width: 86.0,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10.0),
                          //     color: Color(0xFFD9DDE3).withOpacity(0.5),
                          //   ),
                          //   child: Center(
                          //     child: Text(
                          //       '\$ 450',
                          //       style: GoogleFonts.poppins(
                          //         fontSize: 20.0,
                          //         color: Colors.black,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: 10.0,
                          // ),
                          Container(
                            height: 40.0,
                            width: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: kDarkWhite,
                            ),
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  EasyLoading.showInfo('Coming Soon');
                                },
                                child: const Icon(
                                  Icons.notifications_active,
                                  color: kMainColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }, error: (e, stack) {
                    return Text(e.toString());
                  }, loading: () {
                    return const HomeScreenAppBarShimmer();
                  }),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: List.generate(
                      freeIcons.length,
                      (index) => HomeGridCards(
                        gridItems: freeIcons[index],
                        color: color[index],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 10,),

                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         width: 10.0,
                //       ),
                //       Text(
                //         'Business',
                //         style: GoogleFonts.poppins(
                //           color: Colors.black,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 20.0,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   padding: EdgeInsets.all(10.0),
                //   child: GridView.count(
                //     physics: NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     childAspectRatio: 1,
                //     crossAxisCount: 4,
                //     children: List.generate(
                //       businessIcons.length,
                //       (index) => HomeGridCards(
                //         gridItems: businessIcons[index],
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'What\'s New',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                    ],
                  ),
                ),
                // ignore: sized_box_for_whitespace
                Container(
                  height: 150,
                  width: 320,
                  child: PageView.builder(
                    pageSnapping: true,
                    itemCount: sliderList.length,
                    controller: pageController,
                    onPageChanged: (int index) {},
                    itemBuilder: (_, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            sliderList[index]['icon'],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       SizedBox(
                //         width: 10.0,
                //       ),
                //       Text(
                //         'Enterprise',
                //         style: GoogleFonts.poppins(
                //           color: Colors.black,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 20.0,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   padding: EdgeInsets.all(10.0),
                //   child: GridView.count(
                //     physics: NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     childAspectRatio: 1,
                //     crossAxisCount: 4,
                //     children: List.generate(
                //       enterpriseIcons.length,
                //       (index) => HomeGridCards(
                //         gridItems: enterpriseIcons[index],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class HomeGridCards extends StatelessWidget {
  const HomeGridCards({Key? key, required this.gridItems, required this.color}) : super(key: key);
  final GridItems gridItems;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Card(
      elevation: 2,
      color: color,
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              gridItems.title.contains('Issue')
                  ? const SalesContact().launch(context)
                  : Navigator.of(context).pushNamed('/${gridItems.title}');
            },
            child: Image(
              height: 70,
              width: 70,
              image: AssetImage(
                gridItems.icon.toString(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              gridItems.title.toString(),
              style: const TextStyle(fontSize: 16),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
