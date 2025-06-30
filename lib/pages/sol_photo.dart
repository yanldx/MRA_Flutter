import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';

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
    fetchManifestAndPhotos();
  }

  Future<void> fetchManifestAndPhotos() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Obtenir le manifeste pour récupérer totalPhotos
      final manifestUrl =
          'https://api.nasa.gov/mars-photos/api/v1/manifests/${widget.roverName}?api_key=os3SUbs6XsaafeHHibwqf5oeIfBE3SScU7gi2IZp';
      final manifestResponse = await http.get(Uri.parse(manifestUrl));

      if (manifestResponse.statusCode == 200) {
        final manifestData = jsonDecode(manifestResponse.body);
        final photosList = manifestData["photo_manifest"]["photos"];
        final solData = photosList.firstWhere(
              (item) => item["sol"] == widget.sol,
          orElse: () => null,
        );

        if (solData != null) {
          totalPhotos = solData["total_photos"];
          totalPages = (totalPhotos / photosPerPage).ceil();
        } else {
          totalPhotos = 0;
          totalPages = 1;
        }

        await fetchPhotos();
      } else {
        throw Exception('Erreur lors du chargement du manifeste');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
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
    print('URL : https://api.nasa.gov/mars-photos/api/v1/rovers/${widget.roverName}/photos?sol=${widget.sol}&page=$currentPage&api_key=os3SUbs6XsaafeHHibwqf5oeIfBE3SScU7gi2IZp',);
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
    if (currentPage < totalPages) {
      setState(() {
        currentPage++;
      });
      fetchPhotos();
    }
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
          ? Center(
        child: Lottie.asset(
          'assets/rover.json',
          width: 80,
          height: 80,
          fit: BoxFit.contain,
        ),
      )
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
                      child: Stack(
                        children: [
                          Positioned.fill(
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
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              color: Colors.black.withOpacity(0.7),
                              child: Text(
                                photoData[index]['camera']['name'],
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: currentPage > 1 ? _goToPreviousPage : null,
                child: Text('Précédent'),
              ),
              ElevatedButton(
                onPressed: currentPage < totalPages ? _goToNextPage : null,
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