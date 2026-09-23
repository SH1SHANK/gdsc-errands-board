// test/widget_test.dart
// Automated widget tests verifying the complete GDSC Errands Board workshop flow.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:errands_app/main.dart';

void main() {
  testWidgets('App displays initial seed errands and handles tab switching', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ErrandsApp());

    // 1. Verify app title and seed data are displayed in the "Open" tab
    expect(find.text('Errands Board'), findsOneWidget);
    expect(find.text('Collect parcel from gate'), findsOneWidget);
    expect(find.text('Photocopy notes'), findsOneWidget);
    expect(find.text('Pick up food from canteen'), findsOneWidget);

    // 2. Switch to "Mine" tab and verify empty state
    await tester.tap(find.text('Mine'));
    await tester.pumpAndSettle();
    expect(
      find.text("You haven't posted or accepted any errands yet."),
      findsOneWidget,
    );

    // 3. Switch to "Done" tab and verify empty state
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('No completed errands yet.'), findsOneWidget);
  });

  testWidgets('Accepting and completing an errand updates status and tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ErrandsApp());

    // Tap on the first errand in the "Open" tab
    await tester.tap(find.text('Collect parcel from gate'));
    await tester.pumpAndSettle();

    // Verify detail page elements
    expect(find.text('Errand Details'), findsOneWidget);
    expect(find.text('Reward: ₹50'), findsOneWidget);
    expect(find.text('OPEN'), findsOneWidget);
    expect(find.text('Accept Errand'), findsOneWidget);

    // Tap "Accept Errand"
    await tester.tap(find.text('Accept Errand'));
    await tester.pumpAndSettle();

    // Verify status updated to ACCEPTED and button changed to "Complete Errand"
    expect(find.text('ACCEPTED'), findsOneWidget);
    expect(find.text('Complete Errand'), findsOneWidget);
    expect(find.text('Delete Errand'), findsOneWidget);

    // Tap "Complete Errand"
    await tester.tap(find.text('Complete Errand'));
    await tester.pumpAndSettle();

    // Verify status is now DONE
    expect(find.text('DONE'), findsOneWidget);

    // Navigate back to the board
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Errand should no longer be in the "Open" tab
    expect(find.text('Collect parcel from gate'), findsNothing);

    // Switch to "Mine" tab: completed errand should be visible
    await tester.tap(find.text('Mine'));
    await tester.pumpAndSettle();
    expect(find.text('Collect parcel from gate'), findsOneWidget);

    // Switch to "Done" tab: completed errand should be visible
    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(find.text('Collect parcel from gate'), findsOneWidget);
  });

  testWidgets('Creating a new errand with validation adds it to the board', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ErrandsApp());

    // Tap the FAB to post a new errand
    await tester.tap(find.text('Post Errand'));
    await tester.pumpAndSettle();

    expect(find.text('Post Errand'), findsWidgets);

    // Attempt to submit empty form to test validation
    await tester.tap(find.widgetWithText(ElevatedButton, 'Post Errand'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a title'), findsOneWidget);
    expect(find.text('Please enter a description'), findsOneWidget);
    expect(find.text('Please enter a reward amount'), findsOneWidget);

    // Test invalid reward validation
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Reward (₹)'),
      '0',
    );
    await tester.tap(find.widgetWithText(ElevatedButton, 'Post Errand'));
    await tester.pumpAndSettle();
    expect(find.text('Reward must be greater than 0'), findsOneWidget);

    // Fill valid form fields
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Buy stationery',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Description'),
      'Get 2 blue gel pens from the store.',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Reward (₹)'),
      '25',
    );

    // Submit valid form
    await tester.tap(find.widgetWithText(ElevatedButton, 'Post Errand'));
    await tester.pumpAndSettle();

    // Verify we are back on the board and new errand is visible in "Open"
    expect(find.text('Buy stationery'), findsOneWidget);
    expect(find.text('₹25'), findsOneWidget);

    // Switch to "Mine" tab: posted errand should also appear because isMine is true
    await tester.tap(find.text('Mine'));
    await tester.pumpAndSettle();
    expect(find.text('Buy stationery'), findsOneWidget);
  });

  testWidgets(
    'Deleting an errand removes it from the list after confirmation',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ErrandsApp());

      // Accept an errand so it becomes "mine"
      await tester.tap(find.text('Photocopy notes'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Accept Errand'));
      await tester.pumpAndSettle();

      // Delete Errand button should be present
      expect(find.text('Delete Errand'), findsOneWidget);

      // Tap Delete Errand button
      await tester.tap(find.text('Delete Errand'));
      await tester.pumpAndSettle();

      // Confirmation dialog should appear
      expect(find.text('Delete this errand?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);

      // Tap Cancel: errand is NOT deleted
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Delete this errand?'), findsNothing);
      expect(find.text('Errand Details'), findsOneWidget);

      // Tap Delete Errand button again
      await tester.tap(find.text('Delete Errand'));
      await tester.pumpAndSettle();

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Should return to board and "Photocopy notes" is removed
      expect(find.text('Errands Board'), findsOneWidget);
      expect(find.text('Photocopy notes'), findsNothing);
    },
  );
}
