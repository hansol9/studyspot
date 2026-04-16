import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/study_spot.dart';

class DetailScreen extends StatefulWidget {
  final StudySpot spot;

  const DetailScreen({super.key, required this.spot});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TextEditingController nameController;
  late TextEditingController addressController;
  late TextEditingController notesController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;

  String selectedCategory = 'Library';
  double rating = 3.0;
  bool isFavorite = false;

  List<String> allAmenities = ['WiFi', 'Power', 'Quiet', 'Food', 'Printing'];
  List<String> selectedAmenities = [];

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.spot.name);
    addressController = TextEditingController(text: widget.spot.address);
    notesController = TextEditingController(text: widget.spot.notes);
    latitudeController =
        TextEditingController(text: widget.spot.latitude.toString());
    longitudeController =
        TextEditingController(text: widget.spot.longitude.toString());

    selectedCategory = widget.spot.category;
    rating = widget.spot.rating;
    isFavorite = widget.spot.isFavorite;
    selectedAmenities = List.from(widget.spot.amenitiesList);
  }

  Future<void> updateSpot() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter spot name')),
      );
      return;
    }

    double latitude = double.tryParse(latitudeController.text) ?? 0.0;
    double longitude = double.tryParse(longitudeController.text) ?? 0.0;

    StudySpot updatedSpot = widget.spot.copyWith(
      name: nameController.text.trim(),
      category: selectedCategory,
      address: addressController.text.trim(),
      latitude: latitude,
      longitude: longitude,
      rating: rating,
      amenities: selectedAmenities.join(','),
      notes: notesController.text.trim(),
      isFavorite: isFavorite,
    );

    await DatabaseHelper.instance.updateSpot(updatedSpot);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> deleteSpot() async {
    if (widget.spot.id != null) {
      await DatabaseHelper.instance.deleteSpot(widget.spot.id!);
    }

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    notesController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Spot'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Spot Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: ['Library', 'Cafe', 'Co-working', 'Outdoor']
                  .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 15),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: latitudeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Latitude',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: longitudeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Longitude',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Rating: ${rating.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 16),
            ),
            Slider(
              value: rating,
              min: 0,
              max: 5,
              divisions: 10,
              label: rating.toStringAsFixed(1),
              onChanged: (value) {
                setState(() {
                  rating = value;
                });
              },
            ),
            const SizedBox(height: 10),

            const Text(
              'Amenities',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Wrap(
              spacing: 8,
              children: allAmenities.map((amenity) {
                return FilterChip(
                  label: Text(amenity),
                  selected: selectedAmenities.contains(amenity),
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedAmenities.add(amenity);
                      } else {
                        selectedAmenities.remove(amenity);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 15),

            SwitchListTile(
              title: const Text('Favorite'),
              value: isFavorite,
              onChanged: (value) {
                setState(() {
                  isFavorite = value;
                });
              },
            ),
            const SizedBox(height: 15),

            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: updateSpot,
                child: const Text('Update Spot'),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: deleteSpot,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete Spot'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}