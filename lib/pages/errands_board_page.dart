// pages/errands_board_page.dart
// The main screen of the Errands Board application.
// Owns the master list of errands and manages the Open, Mine, and Done tabs.

import 'package:flutter/material.dart';

import '../models/errand.dart';
import '../widgets/errand_card.dart';
import 'add_errand_page.dart';
import 'errand_detail_page.dart';

/// The main board screen containing the TabBar and the errand list.
class ErrandsBoardPage extends StatefulWidget {
  const ErrandsBoardPage({super.key});

  @override
  State<ErrandsBoardPage> createState() => _ErrandsBoardPageState();
}

class _ErrandsBoardPageState extends State<ErrandsBoardPage> {
  // Master list of errands: this is the single source of truth for the app
  final List<Errand> errands = [
    Errand(
      title: 'Collect parcel from gate',
      description:
          'Need someone to pick up an Amazon package from the main gate.',
      reward: 50,
      status: ErrandStatus.open,
      isMine: false,
    ),
    Errand(
      title: 'Photocopy notes',
      description: 'Photocopy 20 pages of DSA lecture notes from the library.',
      reward: 30,
      status: ErrandStatus.open,
      isMine: false,
    ),
    Errand(
      title: 'Pick up food from canteen',
      description: 'Grab a sandwich and cold coffee from the central canteen before 1 PM.',
      reward: 40,
      status: ErrandStatus.open,
      isMine: false,
    ),
  ];

  // Navigates to the Add Errand page and adds the result to the list
  void _openAddErrand() async {
    final newErrand = await Navigator.push<Errand>(
      context,
      MaterialPageRoute(builder: (context) => const AddErrandPage()),
    );

    // If the user submitted a valid errand, add it and rebuild the UI
    if (newErrand != null) {
      setState(() {
        errands.add(newErrand);
      });
    }
  }

  // Navigates to the detail page for the selected errand
  void _openDetail(Errand errand) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ErrandDetailPage(
          errand: errand,
          onDelete: () {
            // Delete callback: removes the errand from the list
            setState(() {
              errands.remove(errand);
            });
            // Close the detail page
            Navigator.pop(context);
          },
        ),
      ),
    );

    // Rebuild the board when returning so updated status is reflected in tabs
    setState(() {});
  }

  // Helper method to build a list or an empty-state message
  Widget _buildErrandList(List<Errand> filteredErrands, String emptyMessage) {
    if (filteredErrands.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredErrands.length,
      itemBuilder: (context, index) {
        final errand = filteredErrands[index];
        return ErrandCard(errand: errand, onTap: () => _openDetail(errand));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1. Filter open errands
    final openErrands = errands
        .where((errand) => errand.status == ErrandStatus.open)
        .toList();

    // 2. Filter user's errands (either posted by user or accepted by user)
    final myErrands = errands.where((errand) => errand.isMine).toList();

    // 3. Filter completed errands
    final doneErrands = errands
        .where((errand) => errand.status == ErrandStatus.done)
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Errands Board'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Open'),
              Tab(text: 'Mine'),
              Tab(text: 'Done'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildErrandList(openErrands, 'No open errands yet.'),
            _buildErrandList(
              myErrands,
              "You haven't posted or accepted any errands yet.",
            ),
            _buildErrandList(doneErrands, 'No completed errands yet.'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openAddErrand,
          icon: const Icon(Icons.add),
          label: const Text('Post Errand'),
        ),
      ),
    );
  }
}
