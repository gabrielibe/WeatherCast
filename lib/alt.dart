import 'dart:async';
import 'dart:ui';
import 'package:my_weather_app/Screens/city_screen.dart';
import 'package:my_weather_app/Services/weather.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';
// import 'package:weatherapitest/services/weather_service.dart';

// import 'model/weather.dart';

class MainScreen extends StatefulWidget {
  final locationWeather;
  MainScreen({this.locationWeather});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  WeatherModel weather = WeatherModel();
  late double temperature;
  late String weatherIcon;
  late String cityName;
  late String weatherMessage;
  late String imagePath;
  late double humidity;
  late double windSpeed;
  String description = '';

  @override
  void initState() {
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    setState(() {
      if (weatherData == null) {
        //if internet is down, location is off, openWeatherAPI is down
        temperature = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        cityName = 'No city Name ';
        return;
      }
      temperature = weatherData["main"]["temp"].toDouble(); // Convert to double
      var condition = weatherData["weather"][0]["id"];
      cityName = weatherData["name"];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature.toInt());
      humidity =
          weatherData['main']['humidity'].toDouble(); // Convert to double
      windSpeed = weatherData['wind']['speed'].toDouble(); // Convert to double
      description = weatherData['weather'][0]['description'];

      print(cityName);
    });

    String getImagePathForTemperature(int temperature) {
      if (temperature > 25) {
        return 'lib/assets/images/sunny.jpg';
      } else if (temperature > 20) {
        return 'lib/assets/images/sunnymid.jpg';
      } else if (temperature < 10) {
        return 'lib/assets/images/snow.jpg';
      } else {
        return 'lib/assets/images/night.jpg';
      }
    }

    imagePath = getImagePathForTemperature(temperature.toInt());
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed action here

          var typedName = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CityScreen(),
              ));
          if (typedName != null) {
            var weatherData = await weather.getCityWeather(typedName);
            updateUI(weatherData);
          }
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.search,
          color: Colors.grey,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.dstATop),
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          child: Icon(
                            FontAwesomeIcons.locationArrow, // Location icon
                            color: Colors.grey,
                          ),
                          onPressed: () async {
                            var weatherData =
                                await weather.getLocationWeather();
                            updateUI(weatherData);
                          },
                        ),
                      ),
                      SizedBox(
                        height: screenHeight / 25,
                      ),
                      Text(
                        '$description $weatherIcon',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth / 9,
                        ),
                      ),
                      Text(
                        'in',
                        // "$locationName, $locationCountry",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontSize: screenWidth / 15,
                        ),
                      ),
                      Text(
                        "$cityName",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth / 10,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              weatherMessage,
                              // "$locationName, $locationCountry",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Montserrat",
                                fontSize: screenWidth / 15,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight / 30,
                          ),
                          Divider(
                            thickness: 2,
                          ),
                          SizedBox(
                            height: screenHeight / 20,
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.thermometerHalf),
                            title: Text('Temperature'),
                            trailing: Text('${temperature.toString()}°c'
                                // temp == null ? 'loading' : '$temp\u00b0'

                                ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 50,
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.cloud),
                            title: Text('Weather'),
                            trailing: Text(description
                                // description == null ? 'loading' : description.toString()

                                ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 50,
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.sun),
                            title: Text('Humidity'),
                            trailing: Text('${humidity.round().toString()} %'
                                //  humidity == null ? 'loading' : humidity.toString()

                                ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 50,
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.wind),
                            title: Text('Wind Speed'),
                            trailing: Text('${windSpeed.toString()} mph'
                                // windSpeed == null ? 'loading' : windSpeed.toString()
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
