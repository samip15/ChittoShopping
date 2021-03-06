import 'package:chito_shopping/model/screens/Home/product_list_screen.dart';
import 'package:chito_shopping/provider/product_provider.dart';
import 'package:chito_shopping/widgets/home_carousel_widget.dart';
import 'package:chito_shopping/widgets/product_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  ThemeData themeConst;
  double mHeight, mWidth;
  Widget _getCategoryItems(
      {@required String title,
      @required IconData icon,
      @required Function onPress,
      @required Color color}) {
    return InkWell(
      onTap: onPress,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: mHeight * 0.05,
            width: mWidth * 0.14,
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
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
      ),
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
    final productsProvider = Provider.of<Products>(context);
    final flashSales = productsProvider.flashSaleProducts;
    final newSales = productsProvider.newProducts;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
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
                    onPress: () {
                      Navigator.pushNamed(context, ProductListScreen.routeName,
                          arguments: {"type": "Clothing", "diff": "category"});
                    },
                    icon: FontAwesomeIcons.tshirt,
                    color: themeConst.primaryColor),
                _getCategoryItems(
                  title: "Electronics",
                  onPress: () {
                    Navigator.pushNamed(context, ProductListScreen.routeName,
                        arguments: {"type": "Electronics", "diff": "category"});
                  },
                  icon: FontAwesomeIcons.laptop,
                  color: Colors.green,
                ),
                _getCategoryItems(
                    title: "Furniture",
                    onPress: () {
                      Navigator.pushNamed(context, ProductListScreen.routeName,
                          arguments: {"type": "Furniture", "diff": "category"});
                    },
                    icon: FontAwesomeIcons.couch,
                    color: Colors.blue),
                _getCategoryItems(
                    title: "Sports",
                    onPress: () {
                      Navigator.pushNamed(context, ProductListScreen.routeName,
                          arguments: {"type": "Sports", "diff": "category"});
                    },
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
                      arguments: {"type": "Flash Sale", "diff": "type"});
                }),
            Container(
              height: mHeight * 0.24,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                itemCount: flashSales.length,
                itemBuilder: (ctx, index) {
                  return ProductItem(
                    id: flashSales[index].id,
                  );
                },
              ),
            ),
            SizedBox(
              height: mHeight * 0.03,
            ),
            _getTitleWidget(
                title: "New Product",
                onPress: () {
                  Navigator.pushNamed(context, ProductListScreen.routeName,
                      arguments: {"type": "New Product", "diff": "type"});
                }),
            Container(
              height: mHeight * 0.23,
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                itemCount: newSales.length,
                itemBuilder: (ctx, index) {
                  return ProductItem(
                    id: newSales[index].id,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
