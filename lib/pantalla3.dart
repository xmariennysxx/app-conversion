import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

class Pantalla3 extends StatefulWidget {
  final Function(String) onConversion;
  const Pantalla3({super.key, required this.onConversion});

  @override
  _Pantalla3State createState() => _Pantalla3State();
}

class _Pantalla3State extends State<Pantalla3> with SingleTickerProviderStateMixin {
  final TextEditingController amountController = TextEditingController();
  String fromCurrency = 'VES';
  String toCurrency = 'USD_PARALELO';
  double result = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  final Map<String, double> exchangeRates = {
    'VES': 1.0,
    'EUR': 49.00,
    'USD_BCV': 46.00,
    'USD_PARALELO': 56.06,
  };

  final List<String> currencies = ['VES', 'EUR', 'USD_BCV', 'USD_PARALELO'];
  final Map<String, String> currencyNames = {
    'VES': 'Bolívares',
    'EUR': 'Euros',
    'USD_BCV': 'BCV',
    'USD_PARALELO': 'Paralelo',
  };

  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    amountController.dispose();
    super.dispose();
  }

  void convert() {
    if (amountController.text.isEmpty) {
      return;
    }
    double amount = double.parse(amountController.text);
    if (!exchangeRates.containsKey(fromCurrency) || !exchangeRates.containsKey(toCurrency)) {
      return;
    }
    double rate = exchangeRates[toCurrency]! / exchangeRates[fromCurrency]!;
    setState(() {
      result = double.parse(amount.toStringAsFixed(2)) * rate;
    });
    player.play(AssetSource('coin_sound.mp3'));
    widget.onConversion(currencyNames[toCurrency]!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 252, 255), 
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 25, 75, 130)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Center(
                  child: Column(
                    children: [
                      ScaleTransition(
                        scale: _animation,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 300.0,
                          height: 300.0, 
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Monto',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: toCurrency,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: currencies.map((currency) => DropdownMenuItem(
                    value: currency,
                    child: Text(currencyNames[currency]!),
                  )).toList(),
                  onChanged: (value) => setState(() => toCurrency = value!),
                ),
                const SizedBox(height: 10.0),
                DropdownButtonFormField<String>(
                  value: fromCurrency,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: currencies.map((currency) => DropdownMenuItem(
                    value: currency,
                    child: Text(currencyNames[currency]!),
                  )).toList(),
                  onChanged: (value) => setState(() => fromCurrency = value!),
                ),
                const SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 25, 75, 130),
                      foregroundColor: Colors.white, 
                    ),
                    onPressed: convert,
                    child: const Text('Convertir'),
                  ),
                ),
                const SizedBox(height: 20.0),
                Center( 
                  child: Container(
                    color: const Color.fromARGB(255, 239, 252, 255),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'TOTAL: ${NumberFormat.decimalPattern('es').format(result)} ${currencyNames[fromCurrency]}',
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
