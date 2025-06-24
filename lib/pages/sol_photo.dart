import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SolPhotoPage extends StatefulWidget {
  final int sol;
  final String roverName;

  const SolPhotoPage({required this.roverName, required this.sol, super.key});

  @override
  State<SolPhotoPage> createState() => _SolPhotoPageState();
}

class _SolPhotoPageState extends State<SolPhotoPage> {
  bool isLoading = true;
  List<dynamic> photoData = [];

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    final response = await http.get(
      Uri.parse(
        'https://api.nasa.gov/mars-photos/api/v1/rovers/${widget.roverName}/photos?sol=${widget.sol}&page=1&api_key=os3SUbs6XsaafeHHibwqf5oeIfBE3SScU7gi2IZp',
      ),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        photoData = data["photos"];
        isLoading = false;
      });
    } else {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement des photos')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sol ${widget.sol} of ${widget.roverName}')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: photoData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: Image.network(
                        photoData[index]["img_src"],
                        fit: BoxFit.cover,
                        width: 200,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.red,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
