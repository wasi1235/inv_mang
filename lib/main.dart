import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_pos/Screens/Authentication/forgot_password.dart';
import 'package:mobile_pos/Screens/Authentication/login_form.dart';
import 'package:mobile_pos/Screens/Authentication/otp_page.dart';
import 'package:mobile_pos/Screens/Authentication/register_form.dart';
import 'package:mobile_pos/Screens/Authentication/sign_in.dart';
import 'package:mobile_pos/Screens/Authentication/success_screen.dart';
import 'package:mobile_pos/Screens/Customers/customer_list.dart';
import 'package:mobile_pos/Screens/Delivery/delivery_address_list.dart';
import 'package:mobile_pos/Screens/Expense/expense_list.dart';
import 'package:mobile_pos/Screens/Home/home.dart';
import 'package:mobile_pos/Screens/Payment/payment_options.dart';
import 'package:mobile_pos/Screens/Products/add_product.dart';
import 'package:mobile_pos/Screens/Products/product_list.dart';
import 'package:mobile_pos/Screens/Profile/profile_screen.dart';
import 'package:mobile_pos/Screens/Purchase/purchase_contact.dart';
import 'package:mobile_pos/Screens/Report/reports.dart';
import 'package:mobile_pos/Screens/Sales/add_discount.dart';
import 'package:mobile_pos/Screens/Sales/add_promo_code.dart';
import 'package:mobile_pos/Screens/Sales/sales_contact.dart';
import 'package:mobile_pos/Screens/Sales/sales_details.dart';
import 'package:mobile_pos/Screens/Sales/sales_list.dart';
import 'package:mobile_pos/Screens/Sales/sales_screen.dart';
import 'package:mobile_pos/Screens/Sales/stock_list.dart';
import 'package:mobile_pos/Screens/SplashScreen/on_board.dart';
import 'package:mobile_pos/Screens/SplashScreen/splash_screen.dart';

import 'Screens/Authentication/profile_setup.dart';
import 'Screens/Due Calculation/due_calculation_contact_screen.dart';
import 'Screens/Products/update_product.dart';
import 'Screens/Purchase/choose_supplier_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Sales-pro',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SalesPro',
      initialRoute: '/',
      builder: EasyLoading.init(),
      routes: {
        '/': (context) => const SplashScreen(),
        '/onBoard': (context) => const OnBoard(),
        '/signIn': (context) => const SignInScreen(),
        '/loginForm': (context) => const LoginForm(),
        '/signup': (context) => const RegisterScreen(),
        '/otp': (context) => const OtpPage(),
        '/purchaseCustomer': (context) => const PurchaseContact(),
        '/forgotPassword': (context) => const ForgotPassword(),
        '/success': (context) => const SuccessScreen(),
        '/setupProfile': (context) => const ProfileSetup(),
        '/home': (context) => const Home(),
        '/profile': (context) => const ProfileScreen(),
        // ignore: missing_required_param

        '/AddProducts': (context) => AddProduct(),
        '/UpdateProducts': (context) => UpdateProduct(),

        '/Products': (context) => const ProductList(),
        '/SalesList': (context) => const SalesScreen(),
        // ignore: missing_required_param
        '/SalesDetails': (context) => SalesDetails(),
        // ignore: prefer_const_constructors
        '/salesCustomer': (context) => SalesContact(),
        '/addPromoCode': (context) => const AddPromoCode(),
        '/addDiscount': (context) => const AddDiscount(),
        '/Sales': (context) => SaleProducts(
              catName: 'Laptop',
            ),
        '/Parties': (context) => const CustomerList(),
        '/Expense': (context) => const ExpenseList(),
        '/Stock': (context) => const StockList(),
        '/Purchase': (context) => const PurchaseContacts(),
        '/Delivery': (context) => const DeliveryAddress(),
        '/Reports': (context) => const Reports(),
        '/Due List': (context) => const DueCalculationContactScreen(),
        '/PaymentOptions': (context) => const PaymentOptions(),
      },
    );
  }
}
