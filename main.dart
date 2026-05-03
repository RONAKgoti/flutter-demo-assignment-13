import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController cityController =
  TextEditingController();

  String city = "Jamnagar";
  String temp = "";
  String condition = "";
  bool loading = false;
  String error = "";

  @override
  void initState() {
    super.initState();
    fetchWeather(city);
  }

  Future<void> fetchWeather(String cityName) async {
    setState(() {
      loading = true;
      error = "";
    });

    try {
      final url =
      Uri.parse("https://wttr.in/$cityName?format=j1");

      final response = await http.get(url);

      final data = jsonDecode(response.body);

      setState(() {
        city = cityName;
        temp = data["current_condition"][0]["temp_C"];
        condition =
        data["current_condition"][0]["weatherDesc"][0]["value"];
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = "Failed to load weather";
        loading = false;
      });
    }
  }

  void searchCity() {
    if (cityController.text.trim().isNotEmpty) {
      fetchWeather(cityController.text.trim());
      cityController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather App"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: "Enter City Name",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: searchCity,
                  icon: const Icon(Icons.search),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: Center(
                child: loading
                    ? const CircularProgressIndicator()
                    : error.isNotEmpty
                    ? Text(
                  error,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                )
                    : Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [

                    Text(
                      city,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      "$temp°C",
                      style: const TextStyle(
                        fontSize: 50,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      condition,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}