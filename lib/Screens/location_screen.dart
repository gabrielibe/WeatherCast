import 'package:flutter/material.dart';
import 'package:my_weather_app/Utilities/constants.dart';

import 'package:my_weather_app/Screens/city_screen.dart';
import 'package:my_weather_app/Services/weather.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen({this.locationWeather});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  late int temperature;
  late String weatherIcon;
  late String cityName;
  late String weatherMessage;
  late String imagePath;

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
      temperature = weatherData["main"]["temp"].toInt();
      var condition = weatherData["weather"][0]["id"];
      cityName = weatherData["name"];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);

      print(cityName);
    });

    String getImagePathForTemperature(int temperature) {
      if (temperature > 25) {
        return 'lib/assets/images/sunny.jpg'; // Replace with your image path
      } else if (temperature > 20) {
        return 'lib/assets/images/sunnymid.jpg'; // Replace with your image path
      } else if (temperature < 10) {
        return 'lib/assets/images/snow.jpg'; // Replace with your image path
      } else {
        return 'lib/assets/images/night.jpg'; // Replace with your image path
      }
    }

    imagePath = getImagePathForTemperature(temperature);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () async {
                        var weatherData = await weather.getLocationWeather();
                        updateUI(weatherData);
                      },
                      child: Icon(
                        color: Colors.white,
                        Icons.near_me,
                        size: 50.0,
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var typedName = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CityScreen(),
                            ));
                        if (typedName != null) {
                          var weatherData =
                              await weather.getCityWeather(typedName);
                          updateUI(weatherData);
                        }
                      },
                      child: Icon(
                        color: Colors.white,
                        Icons.location_city,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '$temperature°',
                        style: kTempTextStyle,
                      ),
                      Text(
                        weatherIcon,
                        style: kConditionTextStyle,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 15.0, top: 40),
                  child: Text(
                    "$weatherMessage in $cityName",
                    textAlign: TextAlign.right,
                    style: kMessageTextStyle,
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
