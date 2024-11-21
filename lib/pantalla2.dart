import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'pantalla3.dart';

class Pantalla2 extends StatefulWidget {
  final String parametro;
  const Pantalla2({super.key, required this.parametro});

  @override
  _Pantalla2State createState() => _Pantalla2State();
}

class _Pantalla2State extends State<Pantalla2> {
  final Map<String, int> conversionCounts = {
    'Euros': 0,
    'Bolívares': 0,
    'BCV': 0,
    'Paralelo': 0,
  };

  void updateConversionCount(String currency) {
    setState(() {
      conversionCounts[currency] = (conversionCounts[currency] ?? 0) + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<CurrencyUsage> data = conversionCounts.entries
        .map((entry) => CurrencyUsage(entry.key, entry.value))
        .toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 252, 255),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color.fromARGB(255, 25, 75, 130)),
                onPressed: () {
                  Navigator.pop(context); // Retorna a Pantalla1
                },
              ),
              const Center(
                child: Text(
                  'MONEDAS DISPONIBLES',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Column(
                    children: [
                      Text(
                        'Euros',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(FontAwesomeIcons.euroSign, size: 50, color: Colors.blue),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Bolívares',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.money, size: 50, color: Colors.orange),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'BCV',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(FontAwesomeIcons.dollarSign, size: 50, color: Colors.green),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Paralelo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(FontAwesomeIcons.coins, size: 50, color: Colors.purple),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                series: <ChartSeries<CurrencyUsage, String>>[
                  BarSeries<CurrencyUsage, String>(
                    dataSource: data,
                    xValueMapper: (CurrencyUsage usage, _) => usage.currency,
                    yValueMapper: (CurrencyUsage usage, _) => usage.usage,
                    pointColorMapper: (CurrencyUsage usage, _) {
                      switch (usage.currency) {
                        case 'Euros':
                          return Colors.blue;
                        case 'Bolívares':
                          return Colors.orange;
                        case 'BCV':
                          return Colors.green;
                        case 'Paralelo':
                          return Colors.purple;
                        default:
                          return Colors.grey; 
                      }
                    },
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Center(
                
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 25, 75, 130), 
                    foregroundColor: Colors.white, 
                  ),
                  child: const Text('Ir al Conversor'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Pantalla3(
                          onConversion: updateConversionCount,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyUsage {
  final String currency;
  final int usage;

  CurrencyUsage(this.currency, this.usage);
}
