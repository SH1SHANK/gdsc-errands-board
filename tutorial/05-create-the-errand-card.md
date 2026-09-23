# Step 05 — Create the Errand Card

## What We Are Building

In this step, you will extract the card layout into its own reusable widget: `ErrandCard`. This separates the presentation of an individual errand from the board page managing the list.

---

## What You Will Learn

* Why extracting reusable UI into custom widgets keeps code modular and maintainable
* How to create a custom `StatelessWidget` that accepts input properties
* What `final` means in Dart
* What a callback function (`VoidCallback`) is and how it reports taps back to parent widgets
* How `InkWell` adds interactive touch ripples to Material cards

---

## Starting Point

You should have `lib/pages/errands_board_page.dart` displaying 3 basic cards using `ListTile`.

---

## Why Separate the Card?

In Step 04, we wrote the card layout directly inside the `ListView.builder`. While that worked, embedding UI layout inside list orchestration creates cluttered files.

By extracting the card into `lib/widgets/errand_card.dart`:
* **`ErrandCard`** is solely responsible for: *"How does an errand look?"*
* **`ErrandsBoardPage`** is solely responsible for: *"What errands exist, and what happens when one is tapped?"*

---

## Step 1 — Create `lib/widgets/errand_card.dart`

In your editor, create a new folder inside `lib/` named `widgets`.

Inside `lib/widgets/`, create a new file named `errand_card.dart`:

```text
lib/
├── main.dart
├── models/
│   └── errand.dart
├── pages/
│   └── errands_board_page.dart
└── widgets/
    └── errand_card.dart
```

---

## Step 2 — Implement the `ErrandCard` Widget

Open `lib/widgets/errand_card.dart` and add:

```dart
import 'package:flutter/material.dart';

import '../models/errand.dart';

/// Reusable widget for displaying an errand in a list.
class ErrandCard extends StatelessWidget {
  const ErrandCard({
    super.key,
    required this.errand,
    required this.onTap,
  });

  final Errand errand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row containing the Title and Reward
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      errand.title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '₹${errand.reward}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              // Description snippet
              Text(
                errand.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

### What this code means
1. **`final Errand errand;`**:
   The card receives an `Errand` object to render. `final` means once the card is built, this field cannot be reassigned.
2. **`final VoidCallback onTap;`**:
   A **callback**. `VoidCallback` is Dart's type for a function that accepts no parameters and returns nothing (`void`). The card doesn't perform navigation itself; it simply runs `onTap()` when clicked, letting the parent page handle navigation.
3. **`InkWell`**:
   Wraps the card content to produce an ink ripple animation when touched.
4. **`Row` & `Column`**:
   * `Row`: Places the title and reward side-by-side horizontally.
   * `Column`: Places the title row and the description vertically.
5. **`Expanded`**:
   Prevents long errand titles from overflowing the screen width by forcing the text to wrap to the next line.

---

## Step 3 — Use `ErrandCard` in `errands_board_page.dart`

Open `lib/pages/errands_board_page.dart`.

Add the import for your new widget at the top:

```dart
import '../widgets/errand_card.dart';
```

Now, update the `ListView.builder` inside `build()` to use `ErrandCard`:

```dart
      body: ListView.builder(
        itemCount: errands.length,
        itemBuilder: (context, index) {
          final errand = errands[index];
          return ErrandCard(
            errand: errand,
            onTap: () {
              print('Tapped on: ${errand.title}');
            },
          );
        },
      ),
```

---

## Run the App

Save both files and Hot Reload (`r`). Tap on any card on your screen.

---

## What You Should See

* Polished card styling: bolder titles, prominent purple reward badges, and truncated two-line descriptions.
* A visual ripple effect whenever you tap a card.
* In your terminal debug console, you will see: `Tapped on: Collect parcel from gate`.

---

## What Just Happened?

You practiced the core Flutter architectural pattern of **component decoupling**:
* `ErrandCard` is a focused visual component that receives data and reports taps.
* `ErrandsBoardPage` owns the data and decides what action to execute upon tap.

---

## Common Mistakes

### "Target of URI doesn't exist: '../widgets/errand_card.dart'"
* **Cause**: Incorrect file path.
* **Fix**: Ensure `errand_card.dart` is inside `lib/widgets/`.

### Yellow-and-black striped box ("A RenderFlex overflowed by X pixels")
* **Cause**: In a `Row`, text that is too long will push past the edge of the screen.
* **Fix**: Wrap the text widget in an `Expanded` widget so Flutter limits its width.

---

## Checkpoint

You can continue to Step 06 when:

- [ ] `lib/widgets/errand_card.dart` exists and passes analysis.
- [ ] `ErrandsBoardPage` renders `ErrandCard` widgets.
- [ ] Tapping a card displays a ripple effect and prints the title to your terminal console.

---

## What You Learned

* How to build a custom, reusable `StatelessWidget`.
* What `final` fields are.
* How `VoidCallback` delegates user actions back to a parent widget.
* How to structure flexible card rows with `Row`, `Expanded`, and `InkWell`.

Next: [Step 06 — Add the Tabs](06-add-the-tabs.md)
