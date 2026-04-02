import 'package:flutter/material.dart';

/// Add New Spot screen - create a new study spot entry.
/// TODO: Implement form with location picker.
class AddSpotScreen extends StatefulWidget {
  const AddSpotScreen({super.key});

  @override
  State<AddSpotScreen> createState() => _AddSpotScreenState();
}

class _AddSpotScreenState extends State<AddSpotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Spot'),
      ),
      body: const Center(
        child: Text('TODO: Implement Add Spot Screen'),
      ),
    );
  }
}
