import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class BitcoinPriceIndexPage extends StatefulWidget {
  @override
  _BitcoinPriceIndexPageState createState() => _BitcoinPriceIndexPageState();
}

class _BitcoinPriceIndexPageState extends State<BitcoinPriceIndexPage> {
  double _bitcoinPrice = 0.0;
  String _disclaimer = '';

  @override
  void initState() {
    super.initState();
    fetchBitcoinPrice();
  }

  Future<void> fetchBitcoinPrice() async {
    final response = await http
        .get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice.json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        _bitcoinPrice =
            double.parse(data['bpi']['USD']['rate'].replaceAll(',', ''));
        _disclaimer = data['disclaimer'];
      });
    } else {
      throw Exception('Failed to load Bitcoin price');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bitcoin Price Index'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.blue,
              child: Text(
                'Bitcoin Price Index',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10.0),
              color: Colors.grey[300],
              child: Text(
                'Current Price: \$$_bitcoinPrice',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 10.0),
            SizedBox(height: 20.0),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  color: Colors.grey[200],
                  child: Text(
                    'Disclaimer: $_disclaimer',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}