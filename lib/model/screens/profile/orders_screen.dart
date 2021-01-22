import 'package:chito_shopping/provider/order_provider.dart' show Orders;
import 'package:chito_shopping/widgets/empty_order_widget.dart';
import 'package:chito_shopping/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const String routeName = "/order_screen";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Future _fetchAllorders;
  bool _isInit = true;
  bool _showAnimaton = false;
  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Color> _colorAnimation;
  Animation<Offset> _offSetAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut));
    _colorAnimation = ColorTween(begin: Colors.red, end: Colors.green)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _offSetAnimation = Tween<Offset>(begin: Offset(-5, -5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _fetchAllorders =
          Provider.of<Orders>(context, listen: false).fetchAllAndSetOrders();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorAnimation.value,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      body: FutureBuilder(
        future: _fetchAllorders,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : snapshot.hasError
                  ? Center(
                      child: Text("Something went wrong !!"),
                    )
                  : snapshot.data?.length == 0
                      ? EmptyOrder(
                          type: "Order",
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          itemBuilder: (context, i) {
                            return OrderItem(
                              orderItem: snapshot.data[i],
                            );
                          },
                          itemCount: snapshot.data.length,
                        );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showAnimaton = true;
          });
        },
        child: AnimatedOpacity(
          duration: Duration(seconds: 2),
          curve: Curves.bounceInOut,
          opacity: _opacityAnimation.value,
          // width: _showAnimaton ? 60 : 50,
          // height: _showAnimaton ? 60 : 50,
          // color: Colors.white,
          child: Icon(
            Icons.favorite,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
