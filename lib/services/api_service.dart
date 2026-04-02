import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class for RESTful API calls.
/// Handles Weather API and Places API integration.
class ApiService {
  // TODO: Replace with your actual API keys
  static const String _weatherApiKey = 'YOUR_WEATHER_API_KEY';
  static const String _weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';

  /// Fetch current weather for given coordinates.
  /// Returns a Map with weather data or null on failure.
  static Future<Map<String, dynamic>?> getWeather(
      double latitude, double longitude) async {
    try {
      final url = Uri.parse(
        '$_weatherBaseUrl/weather?lat=$latitude&lon=$longitude'
            '&appid=$_weatherApiKey&units=metric',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print('Weather API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Weather API exception: $e');
      return null;
    }
  }

  /// Parse weather response into a simplified map.
  static Map<String, String> parseWeather(Map<String, dynamic> data) {
    final weather = data['weather'][0];
    final main = data['main'];

    return {
      'description': weather['description'] as String,
      'icon': weather['icon'] as String,
      'temperature': '${main['temp']}°C',
      'humidity': '${main['humidity']}%',
      'feelsLike': '${main['feels_like']}°C',
    };
  }

  /// Get weather icon URL from icon code.
  static String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  // ==================== PLACES API ====================
  // TODO: Implement your chosen Places API here.
  // Options: Foursquare, Google Places, or any other.

  /// Search for nearby study-friendly places.
  /// This is a placeholder - implement with your chosen API.
  static Future<List<Map<String, dynamic>>> searchNearbyPlaces(
      double latitude, double longitude, {String query = 'study'}) async {
    // TODO: Replace with actual API call
    // Example structure for the return data:
    // [
    //   {
    //     'name': 'Library Name',
    //     'address': '123 Main St',
    //     'latitude': 43.4723,
    //     'longitude': -80.5449,
    //     'category': 'library',
    //     'rating': 4.5,
    //   }
    // ]

    return [];
  }
}
