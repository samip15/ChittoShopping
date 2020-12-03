import 'package:chito_shopping/theme/constants.dart';
import 'package:chito_shopping/widgets/product_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  static const String routeName = "/product_list_screen";
  @override
  Widget build(BuildContext context) {
    final themeConst = Theme.of(context);
    final title = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
              icon: Icon(
                Icons.search,
                color: blackColor,
              ),
              onPressed: () {})
        ],
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1.4,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10),
          itemCount: 12,
          itemBuilder: (ctx, index) {
            return ProductItem(
              imageUrl:
                  "https://assets.ajio.com/medias/sys_master/root/ajio/catalog/5ef38fcbf997dd433b43d714/-473Wx593H-461205998-black-MODEL.jpg",
              price: 2000,
              title: "Shoes",
            );
          }),
    );
  }
}
