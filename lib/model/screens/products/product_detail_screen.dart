import 'package:chito_shopping/theme/constants.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  ThemeData themeConst;
  static const String routeName = "/product_detail_screen";

  Chip _sizedChips({@required String title, @required Color color}) {
    return Chip(
      label: Text(
        title,
        style: themeConst.textTheme.subtitle1
            .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
      ),
      backgroundColor: color,
    );
  }

  ListTile _detailTiles({@required String title, @required String desc}) {
    return ListTile(
      title: Text(
        title,
        style: themeConst.textTheme.headline6
            .copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        desc,
        style: themeConst.textTheme.subtitle2.copyWith(color: grayColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final mHeight = mediaQuery.size.height;
    themeConst = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Shoes"),
      ),
      body: ListView(
        children: [
          Image.network(
            "https://assets.ajio.com/medias/sys_master/root/ajio/catalog/5ef38fcbf997dd433b43d714/-473Wx593H-461205998-black-MODEL.jpg",
            height: mHeight * 0.4,
            fit: BoxFit.contain,
          ),
          ListTile(
            title: Text(
              "Rs 1500",
              style: themeConst.textTheme.headline5
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("GoldStar Shoes Blue Jx123",
                style: themeConst.textTheme.subtitle2),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: themeConst.accentColor,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text("4.5"),
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: themeConst.primaryColor,
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text("100"),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Text(
              "Size",
              style: themeConst.textTheme.headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _sizedChips(
                title: "S",
                color: Colors.orange[200],
              ),
              _sizedChips(
                title: "M",
                color: Colors.pink[200],
              ),
              _sizedChips(
                title: "L",
                color: Colors.lightBlue[200],
              ),
              _sizedChips(
                title: "XL",
                color: Colors.green[200],
              ),
            ],
          ),
          _detailTiles(title: "Brand", desc: "Gold Star"),
          _detailTiles(title: "Category", desc: "Man Shoes"),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: themeConst.primaryColor,
              textColor: Colors.white,
              icon: Icon(Icons.shopping_cart),
              label: Text("Add To Cart"),
              onPressed: () {},
            ),
          )
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     IconButton(
          //         padding: const EdgeInsets.all(0),
          //         icon: Icon(
          //           FontAwesomeIcons.minus,
          //           size: 18,
          //         ),
          //         onPressed: () {}),
          //     Text(
          //       "1",
          //       style: themeConst.textTheme.headline4
          //           .copyWith(fontWeight: FontWeight.w600),
          //     ),
          //     IconButton(
          //         padding: const EdgeInsets.all(0),
          //         icon: Icon(
          //           FontAwesomeIcons.plus,
          //           size: 18,
          //         ),
          //         onPressed: () {}),
          //   ],
          // )
        ],
      ),
    );
  }
}
