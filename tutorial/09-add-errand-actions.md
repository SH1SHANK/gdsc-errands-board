# Step 09 — Add Errand Actions

## What We Are Building

In this step, you will make the detail screen interactive. When a student taps **Accept Errand**, the task will update to `accepted` and the UI will immediately re-render. When they tap **Complete Errand**, it will transition to `done`. You will also add a **Delete Errand** action with an `AlertDialog` confirmation and a callback function.

---

## What You Will Learn

* How `setState()` notifies Flutter to re-execute a widget's `build()` method
* How to convert a `StatelessWidget` into a `StatefulWidget`
* What a callback function is and why child widgets use callbacks to communicate with parents
* How to display popups with `showDialog()` and `AlertDialog`
* How `await Navigator.push()` pauses execution so the board can refresh when returning

---

## Starting Point

You should have `lib/pages/errand_detail_page.dart` rendering the task layout, but button presses currently only print messages.

---

## Understanding `setState()`

Suppose you write:

```dart
errand.status = ErrandStatus.accepted;
```

This modifies the object in memory. However, Flutter will not automatically refresh the screen. Without a notification, the screen will continue to show the old status!

To update the screen, you call:

```dart
setState(() {
  errand.status = ErrandStatus.accepted;
  errand.isMine = true;
});
```

* The code inside the `{ ... }` modifies the data.
* `setState()` tells Flutter: *"Data has changed. Run this widget's `build()` method again so the user sees the new status and buttons."*

---

## Step 1 — Convert `ErrandDetailPage` to a `StatefulWidget`

Open `lib/pages/errand_detail_page.dart`.

Replace the entire file with this interactive implementation:

```dart
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
  // Shows a confirmation dialog before deleting an errand
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
                // 1. Close the dialog
                Navigator.pop(dialogContext);
                // 2. Call the delete callback provided by the board
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
    // In a State class, constructor properties are accessed via "widget."
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

            // Description
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

            // Action: Accept Errand
            if (errand.status == ErrandStatus.open)
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () {
                    // Update state and rebuild the screen
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

            // Action: Complete Errand
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

            // Action: Delete Errand (Only visible if the errand is mine)
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
```

### What this code introduces

1. **`widget.errand` and `widget.onDelete`**:
   In a `StatefulWidget`, constructor properties belong to the widget class (`ErrandDetailPage`). Inside its state class (`_ErrandDetailPageState`), you access them by prefixing `widget.`.
2. **Callbacks (`final VoidCallback onDelete;`)**:
   A callback is simply a function passed from a parent widget to a child widget. The board page owns the master list. The detail page does not own that list. When the user confirms deletion, the detail page runs `widget.onDelete()`, telling the board: *"Please remove this item from your list."*
3. **`showDialog()` and `AlertDialog`**:
   Displays a Material modal popup over the current screen. It provides `title`, `content`, and an array of `actions` (buttons).

---

## Step 2 — Update `_openDetail` on the Board Page

Open `lib/pages/errands_board_page.dart`.

Update `_openDetail` to:
1. Supply the `onDelete` callback.
2. Add `await` so the board refreshes its tabs whenever returning from the detail page.

```dart
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
```

### Why `async` and `await`?
Adding `await` before `Navigator.push(...)` pauses execution until the user presses the back button and returns to the board. Once back, `setState(() {})` runs on the board, updating the Open, Mine, and Done tabs!

---

## Run the App

Save both files and Hot Restart (`R`).

Test the full flow:
1. In the **Open** tab, tap **Collect parcel from gate**.
2. Tap **Accept Errand**:
   * The status chip immediately changes to **ACCEPTED**.
   * The button changes to **Complete Errand**.
   * A red **Delete Errand** button appears.
3. Tap the top-left back arrow to return to the board:
   * "Collect parcel from gate" has disappeared from the **Open** tab!
   * Tap the **Mine** tab: it is now visible there!
4. Tap it again from the **Mine** tab and tap **Complete Errand**:
   * The status changes to **DONE**.
5. Return to the board and tap the **Done** tab:
   * It is now listed in the **Done** tab!
6. Tap it, tap **Delete Errand**, and tap **Delete** in the popup:
   * The detail page closes, and the errand is completely removed from the board.

---

## What Just Happened?

You completed the state update lifecycle:
* `setState()` told Flutter to re-render the detail page immediately upon button clicks.
* The `onDelete` callback cleanly requested the master list owner to remove the item.
* `await Navigator.push` ensured the board refreshed its tabs upon return.

---

## Common Mistakes

### Forgetting `widget.` in State class
* **Error**: `Undefined name 'errand'.`
* **Fix**: In a `State` class, access constructor parameters as `widget.errand`.

### Tabs not updating after returning to board
* **Cause**: Forgetting `await` before `Navigator.push(...)`.
* **Fix**: Ensure `void _openDetail(Errand errand) async` includes `await Navigator.push(...)` followed by `setState(() {});`.

---

## Checkpoint

You can continue to Step 10 when:

- [ ] Tapping "Accept Errand" updates status to ACCEPTED immediately.
- [ ] Tapping "Complete Errand" updates status to DONE immediately.
- [ ] Accepted and completed errands shift to the Mine and Done tabs on the board.
- [ ] Tapping "Delete Errand" prompts a confirmation dialog and deletes the task if confirmed.

---

## What You Learned

* Why `setState()` is required to trigger UI rebuilds when data changes.
* How to use `async` / `await` with `Navigator.push()` to refresh parent screens.
* How callback functions allow child widgets to trigger actions in parent widgets.
* How to build dialogs with `showDialog()` and `AlertDialog`.

Next: [Step 10 — Build the Add Errand Form](10-build-the-add-errand-form.md)
