import 'package:chito_shopping/theme/constants.dart';
import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  ThemeData themeConst;
  double mHeight, mWidth;
  final String id;
  CardItem({@required this.id});
  @override
  Widget build(BuildContext context) {
    themeConst = Theme.of(context);
    MediaQueryData mediaQuery = MediaQuery.of(context);
    mHeight = mediaQuery.size.height;
    mWidth = mediaQuery.size.width;
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (direction) {},
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: Image.network(
                    "https://cnet2.cbsistatic.com/img/71wqPB80Rvuu1Q1vUBGFXHe77PI=/940x0/2017/10/04/a822218f-dfef-41c2-a613-1430f6ec6c82/100417-google-home-mini7347.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Google Home",
                        style: themeConst.textTheme.subtitle1
                            .copyWith(fontSize: 18),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rs 2000",
                            style: themeConst.textTheme.subtitle2.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: greyColor),
                                ),
                                child: Text("2"),
                              ),
                              IconButton(
                                  padding: const EdgeInsets.all(0),
                                  icon: Icon(
                                    Icons.add,
                                    color: themeConst.primaryColor,
                                  ),
                                  onPressed: () {}),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
