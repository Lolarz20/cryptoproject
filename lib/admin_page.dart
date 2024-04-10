import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cryptoproject/functions.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          const SlidingBarMoving(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ManageBot(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SummaryWidget(),
                    SizedBox(height: height*0.025),
                    const ChartWidget()
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

  final List<String> _images = [];
  final List<String> _symbols = [];
  final List<String> _pnl = [];

  final CarouselController _carouselController = CarouselController();

  void getPositions() async {
    List<Map> list = [];
    list = await getOpenFuturesPositions();
    for(var i in list){
      for(var x in i.keys){
        _symbols.add(x);
      }
      for(var y in i.values){
        _pnl.add(y);
      }
      for(var z in i.keys){
        _images.add(await getCryptoIconsUrl(z.toString().replaceAll('USDT', '')));
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPositions();
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
      height: 80,
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
                  viewportFraction: 200 / MediaQuery.of(context).size.width,
                  // Add this
                  onPageChanged: (_, __) {
                    _carouselController.nextPage(
                        duration: const Duration(milliseconds: 2000));
                  }),
              items: List.generate(_symbols.length, (index) => ContainerForTicker(icon: _images[index], symbol: _symbols[index], pnl: _pnl[index]))
            ),
          ],
        ),
      ),
    );
  }
}

class ContainerForTicker extends StatelessWidget {
  final String icon;
  final String symbol;
  final String pnl;
  const ContainerForTicker({super.key, required this.icon, required this.symbol, required this.pnl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            CircleAvatar(foregroundImage: NetworkImage(icon)),
            Text(symbol),
            Text(double.parse(pnl).toStringAsFixed(2))
          ],
        ),
      ),
    );
  }
}


enum Bots {futures, spot}

class ManageBot extends StatefulWidget {
  const ManageBot({super.key});

  @override
  State<ManageBot> createState() => _ManageBotState();
}

class _ManageBotState extends State<ManageBot> {

  final List<String> symbols = [
    'Bitcoin',
    'Ethereum',
    'BNB',
    'Solana',
    'XRP',
    'Dogecoin',
    'Cardano',
    'Avalanche',
    'Shiba Inu',
    'Bitcoin Cash',
    'Polkadot',
    'Tron',
    'Chainlink',
    'Polygon',
    'NEAR Protocol',
    'Internet Computer',
    'Litecoin',
    'Uniswap',
    'Dai',
    'Aptos',
    'Ethereum Classic',
    'Stacks',
    'Filecoin',
    'Cosmos',
    'Arbitrum',
    'Stellar',
    'Immutable',
    'Render',
    'Hedera',
    'VeChain',
    'The Graph',
    'Maker',
    'Optimism',
    'Injective',
    'Theta Network',
    'Fantom',
    'THORChain',
    'Monero',
    'Aave',
    'Flow',
    'NEO',
    'EOS',
  ];

  bool loadingSymbol = false;

  void createListOfSymbols() async {
    List<String> list1 = await getCryptoIconsUrls(listOfSymbol);
    List<double> list2 = (await getCryptoPrices(listOfSymbol)).values.toList();
    List<String> list3 = listOfSymbol;
    List<String> list4 = symbols;
    setState(() {
      list = List.generate(listOfSymbol.length, (index) => SymbolWidget(image: list1[index], price: list2[index], symbol: list3[index], sign: list4[index]));
      loadingSymbol = true;
    });
  }

  @override
  void initState() {
    createListOfSymbols();
    super.initState();
  }

  List<SymbolWidget> list = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: width*0.2,
        height: height*0.8,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomSlidingSegmentedControl<Bots>(
                initialValue: Bots.futures,
                isStretch: true,
                children: const {
                  Bots.futures: Text(
                    'Futures',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Russo',
                        color: Colors.blue,
                        fontSize: 9),
                  ),
                  Bots.spot: Text(
                    'Spot',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Russo',
                        color: Colors.blue,
                        fontSize: 9),
                  ), //1
                },
                innerPadding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                thumbDecoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(12),
                ),
                onValueChanged: (v) async {
                    if(v==Bots.spot){
                      //getSpotSymbols();
                      print(await getSpotAccountBalance());
                    } else {
                      print(await getFuturesSymbolsSortedByVolume());
                      print(await getFuturesAccountBalance());
                    }
                },
              ),
            ),
            loadingSymbol==false? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: CupertinoColors.systemGrey),
                Text('loading symbols...', style: TextStyle(color: Colors.grey))
              ]
            ) : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: height*0.7,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      shrinkWrap: true,
                      children: list,
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SymbolWidget extends StatelessWidget {
  final String image;
  final double price;
  final String symbol;
  final String sign;
  const SymbolWidget({super.key, required this.image, required this.price, required this.symbol, required this.sign});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: height*0.075,
        width: width*0.01,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.blue, width: 5)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(foregroundImage: NetworkImage(image)),
              Text(sign, style: const TextStyle(fontFamily: 'Russo', color: Colors.blueAccent, fontSize: 18)),
              Text(symbol, style: const TextStyle(fontFamily: 'Russo', color: Colors.grey, fontSize: 12)),
              Text('\$$price', style: const TextStyle(fontFamily: 'Russo', color: Colors.grey))
            ],
          ),
        ),
      ),
    );
  }
}


class AddAvailableSymbols extends StatefulWidget {
  final List<String> symbols;
  const AddAvailableSymbols({super.key, required this.symbols});

  @override
  State<AddAvailableSymbols> createState() => _AddAvailableSymbolsState();
}

class _AddAvailableSymbolsState extends State<AddAvailableSymbols> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


class SummaryWidget extends StatefulWidget {
  const SummaryWidget({super.key});

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {

  double pnl = 0.0;
  double moneyOnFutures = 0.0;

  void getPNL() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      pnl = double.parse(await getFuturesPNL());
      setState(() {});
    });
  }

  void getFuturesAccount() async {
    moneyOnFutures = double.parse(await getFuturesAccountBalance());
    setState(() {});
  }

  @override
  void initState() {
    getPNL();
    getFuturesAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: width*0.65,
        height: height*0.32,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.all(25), child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Profit and Loss (PNL):', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 25)),
                    Text('${pnl.isNegative? pnl : '+$pnl'}', style: TextStyle(color: pnl.isNegative? Colors.red : Colors.green, fontSize: 40, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            )),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const Text('Futures Balance:', style: TextStyle(fontWeight: FontWeight.w200, fontSize: 20)),
                        Text('\$$moneyOnFutures', style: const TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                )
              ],
            )
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
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: width*0.65,
        height: height*0.45,
        child: const Column(
          children: [
            LineChartSample2()
          ],
        ),
      ),
    );
  }
}

class BotCreationWidget extends StatefulWidget {
  const BotCreationWidget({super.key});

  @override
  State<BotCreationWidget> createState() => _BotCreationWidgetState();
}

class _BotCreationWidgetState extends State<BotCreationWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: SizedBox(
        width: width*0.65,
        height: height*0.7,
        child: const Column(
          children: [

          ],
        ),
      ),
    );
  }
}

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    return SizedBox(
      width: width*0.64,
      height: height*0.44,
      child: AspectRatio(
        aspectRatio: 1.70,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 18,
            left: 12,
            top: 24,
            bottom: 12,
          ),
          child: LineChart(
            mainData()
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.grey
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.grey
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      baselineX: 0,
      baselineY: 0,
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 10,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

