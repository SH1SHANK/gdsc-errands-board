// pages/errand_detail_page.dart
// Displays full details for a single errand and provides actions (Accept, Complete, Delete).

import 'package:flutter/material.dart';

import '../models/errand.dart';

/// Screen that displays the details of a single selected [Errand].
class ErrandDetailPage extends StatefulWidget {
  const ErrandDetailPage({
    super.key,
    required this.errand,
    required this.onDelete,
  });

  final Errand errand;
  final VoidCallback onDelete;

  @override
  State<ErrandDetailPage> createState() => _ErrandDetailPageState();
}

class _ErrandDetailPageState extends State<ErrandDetailPage> {
  // Shows a basic confirmation dialog before deleting an errand
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete this errand?'),
          content: const Text('Are you sure you want to delete this errand?'),
          actions: [
            TextButton(
              onPressed: () {
                // Close the dialog without deleting
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Close the dialog first
                Navigator.pop(dialogContext);
                // Call the delete callback provided by ErrandsBoardPage
                widget.onDelete();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final errand = widget.errand;

    return Scaffold(
      appBar: AppBar(title: const Text('Errand Details')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              errand.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),

            // Reward
            Text(
              'Reward: ₹${errand.reward}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12.0),

            // Status indicator
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Chip(
                  label: Text(
                    errand.status.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // Description Header and Content
            const Text(
              'Description',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6.0),
            Text(
              errand.description,
              style: const TextStyle(fontSize: 16.0, height: 1.4),
            ),

            const Spacer(),

            // Action Button: Accept Errand
            if (errand.status == ErrandStatus.open)
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Updating state directly on the object and rebuilding the page
                    setState(() {
                      errand.status = ErrandStatus.accepted;
                      errand.isMine = true;
                    });
                  },
                  child: const Text(
                    'Accept Errand',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),

            // Action Button: Complete Errand
            if (errand.status == ErrandStatus.accepted && errand.isMine)
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      errand.status = ErrandStatus.done;
                    });
                  },
                  child: const Text(
                    'Complete Errand',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),

            // Action Button: Delete Errand (Only visible if the errand is mine)
            if (errand.isMine) ...[
              const SizedBox(height: 12.0),
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: _confirmDelete,
                  child: const Text(
                    'Delete Errand',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
