import 'package:chito_shopping/provider/product_provider.dart';
import 'package:chito_shopping/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        style: themeConst.textTheme.subtitle2.copyWith(color: greyColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final mHeight = mediaQuery.size.height;
    themeConst = Theme.of(context);
    final id = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context).findProductById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: ListView(
        children: [
          Image.network(
            loadedProduct.imageUrl,
            height: mHeight * 0.4,
            fit: BoxFit.contain,
          ),
          ListTile(
            title: Text(
              "Rs. ${loadedProduct.price}",
              style: themeConst.textTheme.headline5
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            contentPadding: const EdgeInsets.all(18),
            subtitle: Text(loadedProduct.title,
                style: themeConst.textTheme.subtitle1.copyWith(fontSize: 18)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: themeConst.accentColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Text(loadedProduct.rating,
                        style: themeConst.textTheme.subtitle1
                            .copyWith(fontSize: 18)),
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
                IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: Icon(
                    loadedProduct.isFavourite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 30,
                  ),
                  color: themeConst.primaryColor,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          loadedProduct.category == "Electronics"
              ? Container()
              : Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 10.0,
                    top: 0,
                    bottom: 10,
                  ),
                  child: Text(
                    "Size",
                    style: themeConst.textTheme.headline6
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
          loadedProduct.category == "Electronics"
              ? Container()
              : Row(
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
          _detailTiles(title: "Description", desc: loadedProduct.description),
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
