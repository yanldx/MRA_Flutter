import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'sol_photo.dart';
import 'package:lottie/lottie.dart';

class RoverPage extends StatefulWidget {
  final String roverName;

  const RoverPage({required this.roverName});

  @override
  State<RoverPage> createState() => _RoverPageState();
}

class _RoverPageState extends State<RoverPage> {
  dynamic roverData;
  bool isLoading = true;
  List<dynamic> sortedPhotosBySol = [];

  @override
  void initState() {
    super.initState();
    fetchRoverData();
  }

  Future<void> fetchRoverData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.nasa.gov/mars-photos/api/v1/manifests/${widget.roverName}?api_key=os3SUbs6XsaafeHHibwqf5oeIfBE3SScU7gi2IZp',
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          roverData = jsonDecode(response.body);

          if (roverData != null &&
              roverData["photo_manifest"] != null &&
              roverData["photo_manifest"]["photos"] != null) {
            List photos = roverData["photo_manifest"]["photos"];
            photos.sort((a, b) => a["sol"].compareTo(b["sol"]));
            sortedPhotosBySol = photos;
          }
        });
      } else {
        setState(() {
          roverData = null;
        });
      }
    } catch (e) {
      setState(() {
        roverData = null;
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
    return Center(
      child: isLoading
          ? Lottie.asset(
        'assets/rover.json',
        width: 80,
        height: 80,
        fit: BoxFit.contain,
      )
          : Column(
              children: [
                Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
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
                ),
                // List of grouped photo by sol
                Expanded(
                  child: ListView.builder(
                    itemCount: sortedPhotosBySol.length,
                    itemBuilder: (context, index) {
                      final photo = sortedPhotosBySol[index];
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Sol ${photo["sol"]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: const Color.fromARGB(
                                      255,
                                      71,
                                      167,
                                      151,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Center(
                                child: Text('on ${photo["earth_date"]}'),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${photo["total_photos"]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: const Color.fromARGB(
                                      255,
                                      200,
                                      15,
                                      15,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          final sol = photo["sol"];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SolPhotoPage(
                                roverName: widget.roverName,
                                sol: sol,
                              ),
                            ),
                          );
                        },
                      );
                      // ...existing code...
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
