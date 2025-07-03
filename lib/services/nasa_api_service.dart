import 'dart:convert';
import 'package:http/http.dart' as http;

// Service pour récupérer les données du rover
class NasaApiService {
  static const String _baseUrl = 'https://api.nasa.gov/mars-photos/api/v1/manifests';
  static const String _apiKey = 'UFiFpneTkxOvAyI54FkvojpKUNFMLnMLCfnaUiVs';

  static Future<Map<String, dynamic>> fetchManifest(String roverName) async {
    final url = Uri.parse('$_baseUrl/$roverName?api_key=$_apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur lors du chargement des données du rover $roverName');
    }
  }
}
