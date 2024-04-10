import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

String apiKey = '097941fec6ce719b0f177ce6f614d1b050c3dd9aa7cebccd6d28ada3b205acd0';
String apiSecret = '7b033f039d6158bad616cf1f9dd19ede75c697b0ba72cce2dd4e783a86ce35d6';

Future<List<String>> getFuturesSymbols() async {
  const String url = 'https://fapi.binance.com/fapi/v1/exchangeInfo';
  List<String> symbolsList = [];

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final symbols = data['symbols'] as List<dynamic>;

      // Dodawanie symboli do listy
      for (var symbol in symbols) {
        symbolsList.add(symbol['symbol']);
      }
    } else {
      print('Failed to load futures symbols. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return symbolsList;
}

Future<List<String>> getFuturesSymbolsSortedByVolume() async {
  const String url = 'https://fapi.binance.com/fapi/v1/ticker/24hr';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> tickers = jsonDecode(response.body);
    // Sortowanie według wolumenu obrotu (konwersja string na double)
    tickers.sort((a, b) => double.parse(b['quoteVolume']).compareTo(double.parse(a['quoteVolume'])));
    // Pobieranie symboli
    List<String> sortedSymbols = tickers.map<String>((ticker) => ticker['symbol'].toString()).toList();
    // Zwracanie pierwszych 30 symboli po sortowaniu
    return sortedSymbols.take(100).toList();
  } else {
    throw Exception('Failed to load futures symbols');
  }
}

Future<List<String>> getSpotSymbols() async {
  const String url = 'https://api.binance.com/api/v3/exchangeInfo';
  List<String> symbolsList = [];

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final symbols = data['symbols'] as List<dynamic>;

      // Dodawanie symboli do listy
      for (var symbol in symbols) {
        symbolsList.add(symbol['symbol']);
      }
    } else {
      print('Failed to load spot symbols. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error: $e');
  }

  return symbolsList;
}

String generateSignature(String data) {
  var key = utf8.encode(apiSecret);
  var bytes = utf8.encode(data);

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);

  return digest.toString();
}

Future<String> getFuturesAccountBalance() async {
  String baseUrl = 'https://testnet.binancefuture.com';
  String endPoint = '/fapi/v2/account';
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  String queryString = 'timestamp=$timestamp';
  String signature = generateSignature(queryString);

  String url = '$baseUrl$endPoint?$queryString&signature=$signature';

  var headers = {
    'X-MBX-APIKEY': apiKey,
  };

  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    // Return the body of the response
    return (double.parse(jsonDecode(response.body)['totalWalletBalance'].toString()).roundToDouble()).toString();
  } else {
    return 'Error fetching futures account info: ${response.body}';
  }
}

Future<String> getFuturesPNL() async {
  String baseUrl = 'https://testnet.binancefuture.com';
  String endPoint = '/fapi/v2/account';
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  String queryString = 'timestamp=$timestamp';
  String signature = generateSignature(queryString);

  String url = '$baseUrl$endPoint?$queryString&signature=$signature';

  var headers = {
    'X-MBX-APIKEY': apiKey,
  };

  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    // Return the body of the response
    return (double.parse(jsonDecode(response.body)['totalUnrealizedProfit']).toStringAsFixed(2));
  } else {
    return 'Error fetching futures account info: ${response.body}';
  }
}

const List<String> listOfSymbol = [
  'BTC',
  'ETH',
  'BNB',
  'SOL',
  'XRP',
  'DOGE',
  'ADA',
  'AVAX',
  'SHIB',
  'BCH',
  'DOT',
  'TRX',
  'LINK',
  'MATIC',
  'NEAR',
  'ICP',
  'LTC',
  'UNI',
  'DAI',
  'APT',
  'ETC',
  'STX',
  'FIL',
  'ATOM',
  'ARB',
  'XLM',
  'IMX',
  'RNDR',
  'HBAR',
  'VET',
  'GRT',
  'MKR',
  'OP',
  'INJ',
  'THETA',
  'FTM',
  'RUNE',
  'XMR',
  'AAVE',
  'FLOW',
  'NEO',
  'EOS',
];

Future<String> getSpotAccountBalance() async {
  String baseUrl = 'https://testnet.binance.vision/api';
  String endPoint = '/api/v3/account';
  int timestamp = DateTime.now().millisecondsSinceEpoch;

  String queryString = 'timestamp=$timestamp';
  String signature = generateSignature(queryString);

  String url = '$baseUrl$endPoint?$queryString&signature=$signature';

  var headers = {
    'X-MBX-APIKEY': apiKey,
  };

  var response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    // Return the body of the response
    return response.body;
  } else {
    return 'Error fetching spot account info: ${response.body}';
  }
}

Future<List<String>> getCryptoIconsUrls(List<String> symbols) async {
  List<String> urls = [];
  final storageRef = FirebaseStorage.instance.ref();

  for (String symbol in symbols) {
    String iconPath = 'CRYPTOICONS/$symbol.png';
    String url = await storageRef.child(iconPath).getDownloadURL();
    urls.add(url);
  }
  return urls;
}

Future<String> getCryptoIconsUrl(String symbol) async {
  final storageRef = FirebaseStorage.instance.ref();
  String iconPath = 'CRYPTOICONS/$symbol.png';
  String url = await storageRef.child(iconPath).getDownloadURL();

  return url;
}

Future<Map<String, double>> getCryptoPrices(List<String> symbols) async {
  Map<String, double> prices = {};

  for (String symbol in symbols) {
    final response = await http.get(Uri.parse('https://api.binance.com/api/v3/ticker/price?symbol=${symbol}USDT'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String symbol = data['symbol'];
      final double price = double.parse(data['price']);
      prices[symbol] = price;
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  return prices;
}

class FuturePosition {
  final String symbol;
  final double positionAmt; // Ilość
  final double unrealizedProfit; // Niezrealizowany zysk

  FuturePosition({required this.symbol, required this.positionAmt, required this.unrealizedProfit});

  factory FuturePosition.fromJson(Map<String, dynamic> json) {
    return FuturePosition(
      symbol: json['symbol'],
      positionAmt: double.parse(json['positionAmt']),
      unrealizedProfit: double.parse(json['unrealizedProfit']),
    );
  }
}

Future<List<Map<String, String>>> getOpenFuturesPositions() async {
  const baseUrl = 'https://testnet.binancefuture.com';
  const endpoint = '/fapi/v2/positionRisk';
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final queryParams = 'timestamp=$timestamp';
  final signature = Hmac(sha256, utf8.encode(apiSecret)).convert(utf8.encode(queryParams));
  final url = Uri.parse('$baseUrl$endpoint?$queryParams&signature=$signature');

  try {
    final response = await http.get(url, headers: {
    'X-MBX-APIKEY': apiKey,
    },);
    if (response.statusCode == 200) {
      List<dynamic> positions = json.decode(response.body);
      List<Map<String, String>> list = [];
      for (var position in positions) {
        if(double.parse(position['unRealizedProfit'])!=0.00000000) {
          list.add({position['symbol']:position['unRealizedProfit']});
        }
      }
      return list;
    } else {
      print('Błąd podczas pobierania danych o pozycji: ${response.body}');
      return [{}];
    }
  } catch (e) {
    print('Wystąpił błąd: $e');
    return [{}];
  }
}

String generateSignature2(String data, String secret) {
  var key = utf8.encode(secret);
  var bytes = utf8.encode(data);

  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);

  return digest.toString();
}

Future<String> getFuturesAccountMargin() async {
  var endpoint = 'https://testnet.binancefuture.co/fapi/v2/account';
  var timestamp = DateTime.now().millisecondsSinceEpoch;

  var queryString = 'timestamp=$timestamp';
  var signature = generateSignature2(queryString, apiSecret);

  var headers = {
    'X-MBX-APIKEY': apiKey,
  };

  var uri = Uri.parse('$endpoint?$queryString&signature=$signature');
  var response = await http.get(uri, headers: headers);

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    print("Margin Account Information: ${data['availableBalance']}");
    return data['availableBalance'];
    // Tutaj możesz przetwarzać dane, np. wyodrębnić i wyświetlić konkretne informacje o margin
  } else {
    print("Error fetching futures account margin: ${response.body}");
    return '';
  }
}
