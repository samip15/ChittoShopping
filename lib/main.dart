import 'package:chito_shopping/auth/login_screen.dart';
import 'package:chito_shopping/auth/register_screen.dart';
import 'package:chito_shopping/model/screens/botton_overview_screen.dart';
import 'package:chito_shopping/model/screens/profile/favoroite_screen.dart';
import 'package:chito_shopping/model/screens/profile/orders_screen.dart';
import 'package:chito_shopping/model/screens/user_product/edit_product_screen.dart';
import 'package:chito_shopping/provider/auth_provider.dart';
import 'package:chito_shopping/provider/cart_provider.dart';
import 'package:chito_shopping/provider/order_provider.dart';
import 'package:chito_shopping/provider/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/screens/Home/product_detail_screen.dart';
import 'model/screens/Home/product_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Products();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Cart();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return AuthProvider();
          },
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) {
            return Orders();
          },
        ),
      ],
      child: MaterialApp(
        title: 'Chito Shopping',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.green,
          primaryColorDark: Colors.green,
          primaryColorLight: Colors.green,
          accentColor: Color(0xFFF7B733),
          canvasColor: Colors.white,
          fontFamily: "Montserrat",
          appBarTheme: AppBarTheme(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            textTheme: TextTheme(
              headline6: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 24),
            ),
          ),
        ),
        home: MainPage(),
        routes: {
          BottomOverviewScreen.routeName: (ctx) => BottomOverviewScreen(),
          FavouritesScreen.routeName: (ctx) => FavouritesScreen(),
          ProductListScreen.routeName: (ctx) => ProductListScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
          LoginScreen.routeName: (ctx) => LoginScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isInit = true;
  bool _isLogin = false;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<AuthProvider>(context).tryAutoLogin(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.data ? BottomOverviewScreen() : LoginScreen();
        });
  }
}
