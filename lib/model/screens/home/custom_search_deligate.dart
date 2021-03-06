import 'package:chito_shopping/model/screens/home/product_detail_screen.dart';
import 'package:chito_shopping/provider/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSearchDeligate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchItems =
        Provider.of<Products>(context, listen: false).getSearchItems(query);
    return query.isEmpty
        ? Center(
            child: Text("Search your products"),
          )
        : searchItems.length > 0
            ? ListView.builder(
                itemCount: searchItems.length,
                itemBuilder: (ctx, index) => ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, ProductDetailScreen.routeName,
                        arguments: searchItems[index].id);
                  },
                  title: Text(searchItems[index].title),
                  leading: searchItems[index].imageUrl == null ||
                          searchItems[index].imageUrl.isEmpty
                      ? Image.asset("assets/images/placeholder.png")
                      : CircleAvatar(
                          backgroundImage:
                              NetworkImage(searchItems[index].imageUrl),
                        ),
                ),
              )
            : Center(
                child: Text("No Products Found For \"$query\""),
              );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchItems =
        Provider.of<Products>(context, listen: false).getSearchItems(query);
    return query.isEmpty
        ? Center(
            child: Text("Search your products"),
          )
        : ListView.builder(
            itemCount: searchItems.length,
            itemBuilder: (ctx, index) => ListTile(
              onTap: () {
                Navigator.pushNamed(context, ProductDetailScreen.routeName,
                    arguments: searchItems[index].id);
              },
              title: Text(searchItems[index].title),
              leading: searchItems[index].imageUrl == null ||
                      searchItems[index].imageUrl.isEmpty
                  ? Image.asset("assets/images/placeholder.png")
                  : CircleAvatar(
                      backgroundImage:
                          NetworkImage(searchItems[index].imageUrl),
                    ),
            ),
          );
  }
}
