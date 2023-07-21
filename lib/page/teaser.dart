import 'package:fiserv/page/home_page.dart';
import 'package:fiserv/page/teaser_page_1.dart';
import 'package:fiserv/page/teaser_page_2.dart';
import 'package:fiserv/page/teaser_page_3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../main.dart';
import 'NavAppOverlay.dart';

class TeaserScreen extends StatefulWidget {
  const TeaserScreen({Key? key}) : super(key: key);

  @override
  _TeaserScreenState createState() => _TeaserScreenState();
}

class _TeaserScreenState extends State<TeaserScreen> {

  PageController _controller = PageController();

  bool onLastPage= false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [
              TeaserPage1(),
              TeaserPage2(),
              TeaserPage3(),
            ],
          ),

          // dot scroll icons
          Container(
            alignment: Alignment(0,0.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                  child: const Text('Skip'),
                  onTap: () { _controller.jumpToPage(2); },
                ),

                SmoothPageIndicator(controller: _controller, count: 3),

                //Next or done
                onLastPage ?
                GestureDetector(
                  child: const Text('Done'),
                  onTap: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                        return MyHomePage();
                      }));
                  },
                ) : GestureDetector(
                  child: const Text('Next'),
                  onTap: () {
                    _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}
