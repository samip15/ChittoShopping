import 'package:chito_shopping/model/screens/user_product/edit_product_screen.dart';
import 'package:chito_shopping/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  ThemeData themeConst;
  double mHeight, mWidth;
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    mHeight = mediaConst.size.height;
    mWidth = mediaConst.size.width;
    themeConst = Theme.of(context);
    final productsProvider = Provider.of<Products>(context);
    final userProducts = productsProvider.userProducts;
    return userProducts.length == 0
        ? Center(
            child: Text(
              "Please Add Your Own Products",
              style: themeConst.textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: userProducts[index].imageUrl == null ||
                        userProducts[index].imageUrl.isEmpty
                    ? Image.asset("assets/images/placeholder.png")
                    : CircleAvatar(
                        backgroundImage:
                            NetworkImage(userProducts[index].imageUrl),
                        radius: 40,
                      ),
                title: Text("${userProducts[index].title}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: themeConst.primaryColor,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                              context, EditProductScreen.routeName,
                              arguments: userProducts[index].id);
                        }),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: themeConst.errorColor,
                      ),
                      onPressed: () async {
                        try {
                          await productsProvider
                              .deleteProduct(userProducts[index].id);
                          showDialog(
                            context: context,
                            builder: (dCtx) => AlertDialog(
                              title: Text("Success"),
                              content: Text("Deleted the item!"),
                              actions: [
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(dCtx);
                                  },
                                  child: Text("Okay"),
                                  color: themeConst.primaryColor,
                                ),
                              ],
                            ),
                          );
                        } catch (error) {
                          showDialog(
                            context: context,
                            builder: (dCtx) => AlertDialog(
                              title: Text("Error!"),
                              content: Text("Cannot delete The Item!"),
                              actions: [
                                RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(dCtx);
                                  },
                                  child: Text("Okay"),
                                  color: themeConst.primaryColor,
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            itemCount: userProducts.length,
          );
  }
}
