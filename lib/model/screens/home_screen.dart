import 'package:chito_shopping/model/screens/products/product_list_screen.dart';
import 'package:chito_shopping/widgets/home_carousel_widget.dart';
import 'package:chito_shopping/widgets/product_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatelessWidget {
  ThemeData themeConst;
  double mHeight, mWidth;
  Widget _getCategoryItems(
      {@required String title,
      @required IconData icon,
      @required Color color}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: mHeight * 0.05,
          width: mWidth * 0.14,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            color: color,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
        SizedBox(
          height: mHeight * 0.01,
        ),
        Text(title)
      ],
    );
  }

  Widget _getTitleWidget({@required String title, @required Function onPress}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: themeConst.textTheme.headline5
              .copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: onPress,
              child: Text(
                "All",
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    mHeight = mediaConst.size.height;
    mWidth = mediaConst.size.width;
    themeConst = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: const EdgeInsets.only(top: 25),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                height: mHeight * 0.05,
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    labelText: "search",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ),
              SizedBox(
                height: mHeight * 0.015,
              ),
              HomeCarouselWidget(),
              SizedBox(
                height: mHeight * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _getCategoryItems(
                      title: "Clothing",
                      icon: FontAwesomeIcons.tshirt,
                      color: themeConst.primaryColor),
                  _getCategoryItems(
                    title: "Electronics",
                    icon: FontAwesomeIcons.laptop,
                    color: Colors.green,
                  ),
                  _getCategoryItems(
                      title: "Furniture",
                      icon: FontAwesomeIcons.couch,
                      color: Colors.blue),
                  _getCategoryItems(
                      title: "Sports",
                      icon: FontAwesomeIcons.basketballBall,
                      color: Colors.purple),
                ],
              ),
              SizedBox(
                height: mHeight * 0.03,
              ),
              _getTitleWidget(
                  title: "Flash Sale",
                  onPress: () {
                    Navigator.pushNamed(context, ProductListScreen.routeName,
                        arguments: "Flash Sale");
                  }),
              Container(
                height: mHeight * 0.22,
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductItem(
                      imageUrl:
                          "https://cdn.shopify.com/s/files/1/1832/4455/products/1153_S17_IconShirt_MendocinoBlue_FR_1024x.jpg",
                      price: 1500,
                      title: "Shirt",
                    ),
                    ProductItem(
                      imageUrl:
                          "https://static-01.daraz.com.np/p/4c5094d6a02b16c291b0af55e00661e1.jpg_340x340q80.jpg_.webp",
                      price: 5300,
                      title: "Pant",
                    ),
                    ProductItem(
                      imageUrl:
                          "https://images.canadagoose.com/image/upload/w_1333,c_scale,f_auto,q_auto:best/v1547146139/product-image/2078M_11_d.jpg",
                      price: 6900,
                      title: "Jacket",
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: mHeight * 0.03,
              ),
              _getTitleWidget(
                  title: "New Product",
                  onPress: () {
                    Navigator.pushNamed(context, ProductListScreen.routeName,
                        arguments: "New Products");
                  }),
              Container(
                height: mHeight * 0.22,
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  scrollDirection: Axis.horizontal,
                  children: [
                    ProductItem(
                      imageUrl:
                          "https://www.riteaid.com/shop/media/catalog/product/y/r/yrswpjdhddaewhuw8evq.jpg",
                      price: 1500,
                      title: "Sanitizer",
                    ),
                    ProductItem(
                      imageUrl:
                          "https://images-na.ssl-images-amazon.com/images/I/51cpuHdXzIL._AC_SX569_.jpg",
                      price: 1500,
                      title: "JBL Speaker",
                    ),
                    ProductItem(
                      imageUrl:
                          "https://static.bhphoto.com/images/images2500x2500/google_home_mini_charcoal_1545143933000_1364563.jpg",
                      price: 5000,
                      title: "Google Home",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
