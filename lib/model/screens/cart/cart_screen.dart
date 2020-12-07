import 'package:chito_shopping/theme/constants.dart';
import 'package:chito_shopping/widgets/card_item.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  ThemeData themeConst;
  double mHeight, mWidth;
  List _cartList = ["1", "2", "3", "4", "5"];
  @override
  Widget build(BuildContext context) {
    themeConst = Theme.of(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);
    mHeight = mediaQuery.size.height;
    mWidth = mediaQuery.size.width;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Column(
              children: _cartList.map((e) {
                return CardItem(
                  id: e,
                );
              }).toList(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: accentColor.withOpacity(0.1),
                border: Border.all(color: themeConst.primaryColor, width: 2),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Text(
                          "Total",
                          style: themeConst.textTheme.subtitle1
                              .copyWith(fontSize: 15, color: greyColor),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Rs 10000",
                          style: themeConst.textTheme.headline5.copyWith(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text(
                        "Checkout",
                        style: TextStyle(fontSize: 12),
                      ),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: themeConst.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
