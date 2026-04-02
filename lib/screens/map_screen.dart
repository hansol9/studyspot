import 'package:flutter/material.dart';

/// Map screen - displays study spots on an interactive map.
/// TODO: Implement with flutter_map, markers, bottom sheet.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Spots'),
      ),
      body: const Center(
        child: Text('TODO: Implement Map Screen'),
      ),
    );
  }
}
