import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RoverPage extends StatefulWidget {
  final String roverName;

  const RoverPage({required this.roverName});

  @override
  State<RoverPage> createState() => _RoverPageState();
}

class _RoverPageState extends State<RoverPage> {
  dynamic roverData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRoverData();
  }

  Future<void> fetchRoverData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.nasa.gov/mars-photos/api/v1/manifests/${widget.roverName}?api_key=UFiFpneTkxOvAyI54FkvojpKUNFMLnMLCfnaUiVs',
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          roverData = jsonDecode(response.body);
        });
      } else {
        setState(() {
          roverData = null; // Ou gère l’erreur comme tu veux
        });
      }
    } catch (e) {
      setState(() {
        roverData = null; // Ou gère l’erreur comme tu veux
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle boxLeftTextStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );
    return Scaffold(
      appBar: AppBar(title: Text(widget.roverName)),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Welcome to the Mars Rover API app! Select a rover to view its photos.',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          widget.roverName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Landing date:', style: boxLeftTextStyle),
                            Text(
                              roverData != null
                                  ? roverData["photo_manifest"]['landing_date']
                                  : 'not found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Launching date:', style: boxLeftTextStyle),
                            Text(
                              roverData != null
                                  ? roverData["photo_manifest"]['launch_date']
                                  : 'not found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Mission Status:', style: boxLeftTextStyle),
                            Text(
                              roverData != null
                                  ? roverData["photo_manifest"]['status']
                                  : 'not found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Max sol:', style: boxLeftTextStyle),
                            Text(
                              roverData != null
                                  ? roverData["photo_manifest"]['max_sol']
                                        .toString()
                                  : 'not found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Max date:', style: boxLeftTextStyle),
                            Text(
                              roverData != null
                                  ? roverData["photo_manifest"]['max_date']
                                  : 'not found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total photos:', style: boxLeftTextStyle),
                            Text(
                              roverData != null
                                  ? roverData["photo_manifest"]['total_photos']
                                        .toString()
                                  : 'not found',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
