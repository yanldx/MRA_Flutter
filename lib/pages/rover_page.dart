import 'package:flutter/material.dart';
import '../services/nasa_api_service.dart';

class RoverPageContent extends StatefulWidget {
  final String roverName;
  const RoverPageContent({Key? key, required this.roverName}) : super(key: key);

  @override
  _RoverPageContentState createState() => _RoverPageContentState();
}

class _RoverPageContentState extends State<RoverPageContent> {
  // même code que ton RoverPage actuel, sans Scaffold
  bool isLoading = true;
  Map<String, dynamic>? data;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await NasaApiService.fetchManifest(widget.roverName);
      setState(() {
        data = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : error != null
          ? Text('Erreur : $error')
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          data.toString(),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

