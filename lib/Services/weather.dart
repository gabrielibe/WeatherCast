import 'package:my_weather_app/Services/location.dart';
import 'package:my_weather_app/Services/networking.dart';

//TODO API key from openweathermap
const apiKey = '5ac1833d0b7f70b735b017f6804d99be';
const openWeatherMapURL = "https://api.openweathermap.org/data/2.5/weather";

class WeatherModel {

  Future<dynamic> getCityWeather(String cityName) async{
    var url = '$openWeatherMapURL?q=$cityName&appid=$apiKey&units=metric';
    NetworkHelper helper = NetworkHelper(url);
    var weatherData = await helper.getData();
    return weatherData;
  }

  Future<dynamic> getLocationWeather() async {
    
    Location loc = new Location();
    await loc.getCurrentLocation();
    NetworkHelper helper = NetworkHelper(
        "$openWeatherMapURL?lat=${loc.latitude}&lon=${loc.longitude}&appid=$apiKey&units=metric");
    var weatherData = await helper.getData();

    return weatherData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s hot out there! Stay cool and enjoy the sunshine! 🌞🌴';
    } else if (temp > 20) {
      return 'Nice weather we\'re having. Time for shorts and 👕';
    } else if (temp < 10) {
      return 'Cold days are here, You\'ll need 🧣 and 🧤,';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}