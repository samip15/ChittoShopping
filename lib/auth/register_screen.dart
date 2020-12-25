import 'package:chito_shopping/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/register_screen";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  ThemeData themeConst;

  double mHeight, mWidth;

  final _form_key = GlobalKey<FormState>();

  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    mHeight = mediaConst.size.height;
    mWidth = mediaConst.size.width;
    themeConst = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                image: AssetImage("assets/images/bg_register.jpg"),
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              children: [
                Container(
                  height: mHeight * 0.18,
                ),
                Text(
                  "Join Us",
                  style: themeConst.textTheme.headline4.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Text(
                  "Sign up to continue",
                  style: themeConst.textTheme.subtitle1.copyWith(
                    color: Colors.white,
                  ),
                ),
                Card(
                  margin: const EdgeInsets.only(top: 50),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Form(
                    key: _form_key,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 25, bottom: 40),
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Email",
                              focusColor: greyColor,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Password",
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: true,
                                obscuringCharacter: "*",
                              ),
                              IconButton(
                                icon: _hidePassword
                                    ? Icon(
                                        FontAwesomeIcons.eyeSlash,
                                        size: 15,
                                      )
                                    : Icon(
                                        FontAwesomeIcons.eye,
                                        size: 15,
                                      ),
                                onPressed: () {
                                  setState(() {
                                    _hidePassword = !_hidePassword;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 60,
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: RaisedButton(
                              color: themeConst.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              onPressed: () {},
                              child: Text(
                                "Sign Up",
                                style: themeConst.textTheme.headline6.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account ? ",
                                style: themeConst.textTheme.subtitle1.copyWith(
                                    color: greyColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Sign in",
                                  style: themeConst.textTheme.subtitle1
                                      .copyWith(
                                          color: accentColor,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}