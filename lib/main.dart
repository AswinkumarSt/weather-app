import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String city = "";
  var temperature;
  var description;
  var humidity;
  var windSpeed;

  final apiKey = "20350b0930ef5f4b592ee84dabf6d705"; // Replace with your OpenWeatherMap API key

  Future<void> getWeather(String city) async {
    final url = Uri.parse(
  "http://api.openweathermap.org/data/2.5/weather?q=London&appid=20350b0930ef5f4b592ee84dabf6d705&units=metric"
);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      setState(() {
        temperature = jsonResponse['main']['temp'];
        description = jsonResponse['weather'][0]['description'];
        humidity = jsonResponse['main']['humidity'];
        windSpeed = jsonResponse['wind']['speed'];
      });
    } else {
      // Handle error here (like city not found)
      setState(() {
        temperature = null;
        description = "City not found";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Enter City",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                city = value;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => getWeather(city),
              child: Text("Get Weather"),
            ),
            SizedBox(height: 20),
            if (temperature != null)
              Column(
                children: [
                  Text(
                    "Temperature: $temperature°C",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    "Description: $description",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    "Humidity: $humidity%",
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    "Wind Speed: $windSpeed m/s",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              )
            else
              Text(
                description ?? "Enter a city name to get weather",
                style: TextStyle(fontSize: 24),
              ),
          ],
        ),
      ),
    );
  }
}
