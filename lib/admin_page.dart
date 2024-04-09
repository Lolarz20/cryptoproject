import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Column(
        children: [
          SlidingBarMoving(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ManageBot(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SummaryWidget(),
                    SizedBox(height: height*0.025),
                    ChartWidget()
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SlidingBarMoving extends StatefulWidget {
  const SlidingBarMoving({Key? key}) : super(key: key);

  @override
  State<SlidingBarMoving> createState() => _SlidingBarMovingState();
}

class _SlidingBarMovingState extends State<SlidingBarMoving> {
  final List<String> _images = const [
    'BTC',
    'ETH',
    'ADA',
    'XRP',
    'SAGA',
    'USDT',
  ];

  final CarouselController _carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    // Add this to start the animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carouselController.nextPage(
          duration: const Duration(milliseconds: 2000));
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      height: 50,
      width: width,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            // Carousel
            CarouselSlider(
              carouselController: _carouselController,
              options: CarouselOptions(
                  pageSnapping: false,
                  height: 50,
                  viewportFraction: 150 / MediaQuery.of(context).size.width,
                  // Add this
                  onPageChanged: (_, __) {
                    _carouselController.nextPage(
                        duration: const Duration(milliseconds: 2000));
                  }),
              items: _images
                  .map((image) => ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(image)
                  )))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ManageBot extends StatefulWidget {
  const ManageBot({super.key});

  @override
  State<ManageBot> createState() => _ManageBotState();
}

class _ManageBotState extends State<ManageBot> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: width*0.2,
        height: height*0.8,
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}

class SummaryWidget extends StatefulWidget {
  const SummaryWidget({super.key});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: width*0.65,
        height: height*0.32,
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}

class ChartWidget extends StatefulWidget {
  const ChartWidget({super.key});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Card(
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: width*0.65,
        height: height*0.45,
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}

