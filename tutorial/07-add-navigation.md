# Step 07 — Add Navigation

## What We Are Building

In this step, you will implement screen-to-screen navigation. When a user taps an errand card on the board, Flutter will push a new screen (`ErrandDetailPage`) onto the navigation stack and pass the selected `Errand` object to it.

---

## What You Will Learn

* How Flutter uses a **navigation stack** (push and pop)
* How to use `Navigator.push()` with `MaterialPageRoute`
* How to pass an object from one screen to another through a constructor parameter
* How Flutter automatically supplies a back button in the `AppBar`

---

## Starting Point

You should have `lib/pages/errands_board_page.dart` with working tabs. Currently, tapping an errand card only prints to the debug console.

---

## The Navigation Mental Model: A Stack of Cards

Flutter manages screens like a deck of cards:

```text
+-----------------------+
|   ErrandDetailPage    |  <- Top of stack (visible on screen)
+-----------------------+
|   ErrandsBoardPage    |  <- Bottom of stack (hidden underneath)
+-----------------------+
```

* **`Navigator.push()`**: Places a new screen card on top of the stack.
* **`Navigator.pop()`**: Removes the top screen card, revealing the previous screen underneath.

---

## Step 1 — Create `lib/pages/errand_detail_page.dart`

In your `lib/pages/` folder, create a new file named `errand_detail_page.dart`:

```text
lib/
├── main.dart
├── models/
│   └── errand.dart
├── pages/
│   ├── errands_board_page.dart
│   └── errand_detail_page.dart
└── widgets/
    └── errand_card.dart
```

---

## Step 2 — Create the Starter Detail Page

Open `lib/pages/errand_detail_page.dart` and add:

```dart
import 'package:flutter/material.dart';

import '../models/errand.dart';

/// Screen that displays the details of a single selected [Errand].
class ErrandDetailPage extends StatelessWidget {
  const ErrandDetailPage({
    super.key,
    required this.errand,
  });

  final Errand errand;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Errand Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              errand.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Reward: ₹${errand.reward}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### What this code means
* `final Errand errand;`: Declares that this screen requires an `Errand` object to render.
* `required this.errand`: The constructor enforces that whoever pushes this page *must* provide the errand to display.
* Notice that we do not manually write a back button. Flutter's `AppBar` detects that another screen sits below it in the navigation stack and automatically displays a back arrow that calls `Navigator.pop()`.

---

## Step 3 — Wire `Navigator.push` on the Board Page

Open `lib/pages/errands_board_page.dart`.

Add the import at the top of the file:

```dart
import 'errand_detail_page.dart';
```

Inside `_ErrandsBoardPageState`, add an `_openDetail` method directly above `_buildErrandList`:

```dart
  // Navigates to the detail page for the selected errand
  void _openDetail(Errand errand) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ErrandDetailPage(
          errand: errand,
        ),
      ),
    );
  }
```

Now, update `_buildErrandList` so the `ErrandCard` invokes `_openDetail`:

```dart
    return ListView.builder(
      itemCount: filteredErrands.length,
      itemBuilder: (context, index) {
        final errand = filteredErrands[index];
        return ErrandCard(
          errand: errand,
          onTap: () => _openDetail(errand),
        );
      },
    );
```

### What `MaterialPageRoute` does
`MaterialPageRoute` is a built-in Flutter helper that handles screen transitions:
* On Android, it performs a subtle slide/fade animation.
* On iOS, it performs a horizontal swipe animation.
* It ties device back gestures and hardware back buttons to `Navigator.pop()`.

---

## Run the App

Save both files and Hot Reload (`r`).

Tap on **Photocopy notes** on your screen.

---

## What You Should See

* The screen transitions to the detail view.
* The AppBar displays **Errand Details** with a back arrow on the left.
* The screen displays the title: **Photocopy notes** and **Reward: ₹30**.
* Tapping the back arrow returns you to the Errands Board.

---

## What Just Happened?

1. Tapping an `ErrandCard` triggered `_openDetail(errand)`.
2. `Navigator.push` placed `ErrandDetailPage` on top of the navigation stack.
3. The specific `Errand` object was passed directly into the detail page constructor.
4. Tapping the back arrow popped `ErrandDetailPage` off the stack, returning you to the board.

In the next step, we will complete the detail screen layout by adding the description, status chip, and action buttons.

---

## Common Mistakes

### "The named parameter 'errand' is required, but there's no corresponding argument"
* **Cause**: Calling `ErrandDetailPage()` without passing the `errand:` parameter.
* **Fix**: Ensure your route builder passes the tapped item: `ErrandDetailPage(errand: errand)`.

### Missing import in `errands_board_page.dart`
* **Error**: `Undefined name 'ErrandDetailPage'.`
* **Fix**: Ensure `import 'errand_detail_page.dart';` is present at the top of `errands_board_page.dart`.

---

## Checkpoint

You can continue to Step 08 when:

- [ ] `lib/pages/errand_detail_page.dart` exists and passes analysis.
- [ ] Tapping any card opens the detail page for that specific errand.
- [ ] The detail page shows the selected task's title and reward amount.
- [ ] Tapping the back arrow returns smoothly to the board.

---

## What You Learned

* How the Flutter navigation stack works using push and pop.
* How to use `Navigator.push()` with `MaterialPageRoute`.
* How to pass data objects across screens via constructor parameters.

Next: [Step 08 — Build the Detail Page](08-build-the-detail-page.md)
