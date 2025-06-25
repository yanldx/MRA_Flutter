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
  int currentPage = 1;
  int totalPhotos = 0;
  int totalPages = 1;
  final int photosPerPage = 25;

  @override
  void initState() {
    super.initState();
    fetchPhotos();
  }

  Future<void> fetchPhotos() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(
      Uri.parse(
        'https://api.nasa.gov/mars-photos/api/v1/rovers/${widget.roverName}/photos?sol=${widget.sol}&page=$currentPage&api_key=os3SUbs6XsaafeHHibwqf5oeIfBE3SScU7gi2IZp',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        photoData = data["photos"];
        if (totalPhotos == 0) {
          // On suppose que le nombre total est approximatif car l'API ne retourne pas total exact
          totalPhotos = photoData.length < photosPerPage && currentPage == 1
              ? photoData.length
              : currentPage * photosPerPage;
          totalPages = (totalPhotos / photosPerPage).ceil();
        }
        isLoading = false;
      });
    } else {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des photos')),
      );
    }
  }

  void _goToNextPage() {
    setState(() {
      currentPage++;
    });
    fetchPhotos();
  }

  void _goToPreviousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchPhotos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.roverName} - Sol ${widget.sol} - $totalPhotos photos',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          SizedBox(height: 12),
          Text(
            'Page $currentPage / $totalPages',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
            child: photoData.isEmpty
                ? Center(child: Text('Aucune photo trouvée.'))
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
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
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
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: currentPage > 1 ? _goToPreviousPage : null,
                child: Text('Précédent'),
              ),
              ElevatedButton(
                onPressed: photoData.length == photosPerPage
                    ? _goToNextPage
                    : null,
                child: Text('Suivant'),
              ),
            ],
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}