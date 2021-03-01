import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/services/distant_google.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:weather/weather.dart';


 /**i wanted to improve functionality abit so instead of hardcoding the device location i used the flutter
     geolocator to get device longitude and latitude then used another api to convert the info into a string that could be taken
     with the openweather api data so that your weather app would give your the location of your device.
 **/ 

void main() => runApp(MaterialApp(
      title: 'Gabriel\'s Simple weather App',
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}





class _HomeState extends State<Home> {


  var currently;
  var temp;
  var humidity;
  var windSpeed;
  var description;
  String Location;
  String country ;

  WeatherFactory wf = new WeatherFactory("5ac1833d0b7f70b735b017f6804d99be");

  void getUserLocation() async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.lowest);

    Weather w = await wf.currentWeatherByLocation(position.latitude,  position.longitude);

setState(() {
  this.Location =w.areaName;
  this.country =' '+ w.country;
});
//get user location first and then get weather 
    getWeather();


  }




    Future getWeather() async {
    getUserLocation();
      http.Response response = await http.get(
            /**i wanted to improve functionality abit so instead of hardcoding the device location i used the flutter
            geolocator to get device longitude and latitude then used another api to convert the info into a string that could be taken
            with the openweather api data so that your weather app would give your the location of your device.
            **/ 
          'http://api.openweathermap.org/data/2.5/weather?q=$Location&units=imperial&appid=5ac1833d0b7f70b735b017f6804d99be');
      var result = jsonDecode(response.body);
      setState(() {
        this.temp = result['main']['temp'];
        this.description = result['weather'][0]['description'];
        this.currently = result['weather'][0]['main'];
        this.humidity = result['main']['humidity'];
        this.windSpeed = result['wind']['speed'];
      }
      );
    }

    @override
    void initState() {
      super.initState();
      this.getUserLocation();

    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,

              decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('Currently in $Location$country',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                  Text( temp == null ? 'loading' : '$temp\u00b0',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                        currently == null ? 'loading' : currently.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        )
                    ),
                  ),

                ],
              ),
            ),

            Expanded(child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height/35,
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.thermometerHalf),
                    title: Text('Temperature'),
                    trailing: Text(temp == null ? 'loading' : '$temp\u00b0'),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/50,
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.cloud),
                    title: Text('Weather'),
                    trailing: Text(description == null ? 'loading' : description
                        .toString()),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/50,
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.sun),
                    title: Text('Humidity'),
                    trailing: Text(
                        humidity == null ? 'loading' : humidity.toString()),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/50,
                  ),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.wind),
                    title: Text('Wind Speed'),
                    trailing: Text(
                        windSpeed == null ? 'loading' : windSpeed.toString()),
                  ),

                ],
              ),
            ))
          ],
        ),
      );
    }


  }

