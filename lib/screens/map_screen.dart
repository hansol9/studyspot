import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../database/database_helper.dart';
import '../models/study_spot.dart';
import 'detail_screen.dart';

/// Map screen to display study spots using flutter_map
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  // Displays list of study spots
  List<StudySpot> _spots = [];

  bool _isLoading = true;

  // Default Initial location
  double initialLatitude = 43.4516;
  double initialLongitude = -80.4925;

  @override
  void initState() {
    super.initState();
    loadSpots();
  }

  /// Loads study spots from SQLite database
  Future<void> loadSpots() async {
    final spots = await DatabaseHelper.instance.getAllSpots();

    setState(() {
      _spots = spots;
      _isLoading = false;

      if (_spots.isNotEmpty) {
        initialLatitude = _spots.first.latitude;
        initialLongitude = _spots.first.longitude;
      }
    });
  }

  /// Returns marker color based on type of location
  Color getMarkerColor(String category) {
    if (category == 'Library') {
      return Colors.blue;
    } else if (category == 'Cafe') {
      return Colors.green;
    } else if (category == 'Co-working') {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  //moves map to track first study spot
  void trackLocation() {
    if (_spots.isNotEmpty) {
      _mapController.move(
        LatLng(_spots.first.latitude, _spots.first.longitude),
        14.0,
      );
    }
  }

  /// Shows extra spot details when marker is pressed
  void showSpotDetails(StudySpot spot) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Text(
                spot.name,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text('Category: ${spot.category}'),
              SizedBox(height: 8),
              Text('Address: ${spot.address}'),
              SizedBox(height: 8),
              Text('Rating: ${spot.rating.toStringAsFixed(1)}'),
              SizedBox(height: 8),
              Text(
                'Amenities: ${spot.amenities.isEmpty ? "None" : spot.amenities}',
              ),
              SizedBox(height: 8),
              Text(
                'Notes: ${spot.notes.isEmpty ? "No notes" : spot.notes}',
              ),
              SizedBox(height: 16),

              // Directs to detail screen
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);

                    final result = await Navigator.push(
                      this.context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(spot: spot),
                      ),
                    );

                    if (result == true) {
                      loadSpots();
                    }
                  },
                  child: Text("View"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build markers for study spots
  List<Marker> buildMarkers() {
    return _spots.map((spot) {
      return Marker(
        point: LatLng(spot.latitude, spot.longitude),
        width: 80,
        height: 80,
        child: GestureDetector(
          onTap: () => showSpotDetails(spot),
          child: Icon(
            Icons.location_on,
            color: getMarkerColor(spot.category),
            size: 40,
          ),
        ),
      );
    }).toList();
  }

  /// Build spot cards
  Widget buildSpotCards() {
    if (_spots.isEmpty) {
      return Center(child: Text('No study spots found'));
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _spots.length,
        itemBuilder: (context, index) {
          final spot = _spots[index];

          return GestureDetector(
            onTap: () {
              _mapController.move(
                LatLng(spot.latitude, spot.longitude),
                14.0,
              );
              showSpotDetails(spot);
            },
            child: Card(
              margin: EdgeInsets.all(8),
              child: Container(
                width: 200,
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spot.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      spot.category,
                      style: TextStyle(
                        color: getMarkerColor(spot.category),
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      spot.address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Spots'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          //Header
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Study Spot Map",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: trackLocation,
                  child: Text("Track Location"),
                ),
              ],
            ),
          ),

          // Map Section
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                LatLng(initialLatitude, initialLongitude),
                initialZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.studyspot',
                ),
                MarkerLayer(
                  markers: buildMarkers(),
                ),
              ],
            ),
          ),

          //Card Section
          buildSpotCards(),
        ],
      ),
    );
  }
}