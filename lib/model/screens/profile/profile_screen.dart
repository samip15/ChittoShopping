import 'dart:convert';
import 'dart:io';

import 'package:chito_shopping/auth/login_screen.dart';
import 'package:chito_shopping/model/screens/profile/favoroite_screen.dart';
import 'package:chito_shopping/model/screens/profile/orders_screen.dart';
import 'package:chito_shopping/provider/auth_provider.dart';
import 'package:chito_shopping/theme/coustom_route_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ThemeData themeConst;
  double mHeight, mWidth;
  bool _uploadNewPhoto = false;
  Map<String, dynamic> jsonUserData;
  bool _isUploading = false;
  bool _isInit = true;
  Future<Map<String, dynamic>> _getUserData;
  //image picker
  File _imageFile;
  final imagePicker = ImagePicker();

  // get user data from shared preferences
  Future<Map<String, dynamic>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> data = json.decode(prefs.getString("userData"));
    String imgURL = prefs.getString("profileUrl");
    data.putIfAbsent("profileUrl", () => imgURL);
    return data == null ? {} : data;
  }

  // capture image from camera
  Future<void> _takePhoto() async {
    final capturePhoto = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      _imageFile = File(capturePhoto.path);
      _uploadNewPhoto = true;
    });
  }

  // get the image widget
  ImageProvider _getImageWidget(String profileUrl) {
    if (profileUrl == "" && _imageFile == null) {
      return AssetImage("assets/images/useravatar.png");
    } else if (_imageFile != null) {
      return FileImage(_imageFile);
    } else {
      return NetworkImage(profileUrl);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _getUserData = getData();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    mHeight = mediaConst.size.height;
    mWidth = mediaConst.size.width;
    themeConst = Theme.of(context);
    return FutureBuilder(
      future: _getUserData,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Stack(children: [
                    Container(
                      height: mHeight * 0.3,
                      color: themeConst.primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(children: [
                            InkWell(
                              onTap: _takePhoto,
                              child: CircleAvatar(
                                radius: 75,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: _getImageWidget(
                                      snapshot.data["profileUrl"]),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              snapshot.data["userName"],
                              style: themeConst.textTheme.headline6.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              snapshot.data["email"],
                              style: themeConst.textTheme.caption.copyWith(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                  ListTile(
                    onTap: () {
                      Navigator.push(context,
                          CustomPageRoute(builder: (ctx) => OrderScreen()));
                    },
                    leading: Icon(
                      FontAwesomeIcons.boxes,
                      color: themeConst.accentColor,
                    ),
                    title: Text(
                      "My Orders",
                      style: themeConst.textTheme.subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, FavouritesScreen.routeName);
                    },
                    leading: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.blue.shade600,
                    ),
                    title: Text(
                      "Favourites",
                      style: themeConst.textTheme.subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: Colors.red.shade400,
                    ),
                    title: Text(
                      "Logout",
                      style: themeConst.textTheme.subtitle1
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    onTap: () async {
                      try {
                        await Provider.of<AuthProvider>(context, listen: false)
                            .logOut();
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName);
                      } catch (error) {
                        print(error);
                      }
                    },
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  _uploadNewPhoto
                      ? Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          child: RaisedButton(
                            onPressed: _isUploading
                                ? null
                                : () async {
                                    try {
                                      setState(() {
                                        _isUploading = true;
                                      });
                                      await Provider.of<AuthProvider>(context,
                                              listen: false)
                                          .uploadProductPhoto(_imageFile);
                                      setState(() {
                                        _uploadNewPhoto = false;
                                      });
                                    } catch (error) {
                                      showDialog(
                                          context: context,
                                          builder: (dCtx) => AlertDialog(
                                                content: Text(
                                                    "Can't Upload the photo"),
                                                actions: [
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.pop(dCtx);
                                                      },
                                                      child: Text("OK"))
                                                ],
                                              ));
                                    }
                                    setState(() {
                                      _isUploading = false;
                                    });
                                  },
                            color: themeConst.accentColor,
                            textColor: Colors.white,
                            child: _isUploading
                                ? Center(
                                    child: Container(
                                      height: 15,
                                      width: 15,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : Text("Upload Profile Photo"),
                          ),
                        )
                      : Container()
                ],
              );
      },
    );
  }
}
