// pages/add_errand_page.dart
// Form page for creating and posting a new errand.

import 'package:flutter/material.dart';

import '../models/errand.dart';

/// Screen where users can enter details to post a new errand.
class AddErrandPage extends StatefulWidget {
  const AddErrandPage({super.key});

  @override
  State<AddErrandPage> createState() => _AddErrandPageState();
}

class _AddErrandPageState extends State<AddErrandPage> {
  // Key used to validate the form
  final _formKey = GlobalKey<FormState>();

  // Controllers to read the user's input from text fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rewardController = TextEditingController();

  @override
  void dispose() {
    // Always dispose controllers when the widget is removed
    _titleController.dispose();
    _descriptionController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Run validation on all FormFields
    if (_formKey.currentState!.validate()) {
      // Create the new Errand object
      final newErrand = Errand(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        reward: int.parse(_rewardController.text.trim()),
        status: ErrandStatus.open,
        isMine: true,
      );

      // Return the new errand back to the board page
      Navigator.pop(context, newErrand);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post Errand')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Input
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Collect parcel from gate',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Description Input
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Pick up package from main gate before 5 PM',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Reward Input
              TextFormField(
                controller: _rewardController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Reward (₹)',
                  hintText: 'e.g., 50',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a reward amount';
                  }
                  final parsedNumber = int.tryParse(value.trim());
                  if (parsedNumber == null || parsedNumber <= 0) {
                    return 'Reward must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),

              // Submit Button
              SizedBox(
                height: 48.0,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text(
                    'Post Errand',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
