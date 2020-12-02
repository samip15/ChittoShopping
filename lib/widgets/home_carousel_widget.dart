import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class HomeCarouselWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaConst = MediaQuery.of(context);
    double mHeight = mediaConst.size.height;
    return Card(
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CarouselSlider(
          items: [
            Image.network(
              "https://p.bigstockphoto.com/GeFvQkBbSLaMdpKXF1Zv_bigstock-Aerial-View-Of-Blue-Lakes-And--227291596.jpg",
              fit: BoxFit.cover,
            ),
            Image.network(
              "https://static.toiimg.com/thumb/msid-58475411,width-748,height-499,resizemode=4,imgsize-142947/.jpg",
              fit: BoxFit.cover,
            ),
            Image.network(
              "https://www.w3schools.com/w3css/img_forest.jpg",
              fit: BoxFit.cover,
            ),
            Image.network(
              "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Convex_lens_%28magnifying_glass%29_and_upside-down_image.jpg/341px-Convex_lens_%28magnifying_glass%29_and_upside-down_image.jpg",
              fit: BoxFit.cover,
            ),
          ],
          options: CarouselOptions(
            height: mHeight * 0.2,
            autoPlay: true,
            autoPlayCurve: Curves.easeInBack,
            autoPlayInterval: Duration(seconds: 2),
          ),
        ),
      ),
    );
  }
}
