import 'package:flutter/material.dart';
import '../models/study_spot.dart';

/// Detail/Edit screen - view and edit study spot information.
/// TODO: Implement form with TextField, DropdownButton, Slider,
///       Chip, Switch, weather API call.
class DetailScreen extends StatefulWidget {
  final StudySpot spot;

  const DetailScreen({super.key, required this.spot});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Spot'),
        actions: [
          TextButton(
            onPressed: () {
              // TODO: Save to database
            },
            child: const Text('Save'),
          ),
        ],
      ),
      body: const Center(
        child: Text('TODO: Implement Detail/Edit Screen'),
      ),
    );
  }
}
