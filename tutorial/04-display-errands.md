# Step 04 — Display Errands

## What We Are Building

In this step, you will create the main screen of the application: `ErrandsBoardPage`. You will store a list of sample campus errands in memory and render them on screen using a scrollable `ListView.builder`.

---

## What You Will Learn

* The difference between `StatelessWidget` and `StatefulWidget`
* How to store multiple objects in a `List<Errand>`
* How `ListView.builder` renders rows efficiently on screen
* How to use `Card` and `ListTile` to structure content
* How to connect `ErrandsBoardPage` as the starting screen in `lib/main.dart`

---

## Starting Point

You should have `lib/models/errand.dart` created and passing `flutter analyze`.

---

## Why a StatefulWidget?

In Flutter, widgets are divided into two types:
1. **`StatelessWidget`**: Fixed. It takes information when created and displays it. It never updates on its own.
2. **`StatefulWidget`**: Dynamic. It holds data (its **state**) that can change over time as users interact with the app. When data changes, it rebuilds to show the latest values.

Because our errands list will have items added, accepted, and removed, `ErrandsBoardPage` must be a `StatefulWidget`.

---

## Step 1 — Create `lib/pages/errands_board_page.dart`

In your editor, create a new folder inside `lib/` named `pages`.

Inside `lib/pages/`, create a new file named `errands_board_page.dart`:

```text
lib/
├── main.dart
├── models/
│   └── errand.dart
└── pages/
    └── errands_board_page.dart
```

---

## Step 2 — Create the `StatefulWidget` Structure

Open `lib/pages/errands_board_page.dart` and add:

```dart
import 'package:flutter/material.dart';

import '../models/errand.dart';

class ErrandsBoardPage extends StatefulWidget {
  const ErrandsBoardPage({super.key});

  @override
  State<ErrandsBoardPage> createState() => _ErrandsBoardPageState();
}

class _ErrandsBoardPageState extends State<ErrandsBoardPage> {
  // 1. We will add our list of errands here next!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Errands Board'),
      ),
      body: const Center(
        child: Text('Errands will appear here.'),
      ),
    );
  }
}
```

### What this code means
A `StatefulWidget` is always split into **two classes**:
1. `ErrandsBoardPage`: The widget configuration.
2. `_ErrandsBoardPageState`: The state class that stores the active data and contains the `build` method. The leading underscore `_` marks it as private to this file.

---

## Step 3 — Add the Seed List of Errands

Inside `_ErrandsBoardPageState`, directly above the `build` method, add this list:

```dart
class _ErrandsBoardPageState extends State<ErrandsBoardPage> {
  // Master list of errands: this is the single source of truth
  final List<Errand> errands = [
    Errand(
      title: 'Collect parcel from gate',
      description: 'Need someone to pick up an Amazon package from the main gate.',
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

  @override
  Widget build(BuildContext context) {
```

### What `List<Errand>` means
* `List`: Dart's standard ordered collection.
* `<Errand>`: Specifies the type. Only `Errand` objects can be added to this list.
* `final`: The `errands` variable will always refer to this specific list instance.

---

## Step 4 — Display the List with `ListView.builder`

Replace the `body:` property inside the `build` method of `_ErrandsBoardPageState` with:

```dart
      body: ListView.builder(
        itemCount: errands.length,
        itemBuilder: (context, index) {
          final errand = errands[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text(
                errand.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(errand.description),
              trailing: Text(
                '₹${errand.reward}',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          );
        },
      ),
```

### What `ListView.builder` does
* `itemCount: errands.length`: Tells Flutter how many rows to draw (3).
* `itemBuilder: (context, index)`: Runs once for each item index (`0`, `1`, `2`).
* `final errand = errands[index]`: Retrieves the errand at the current position.
* `Card`: Draws a Material card container with rounded corners and elevation.
* `ListTile`: A convenient built-in row widget with slots for `title`, `subtitle`, and `trailing`.

---

## Step 5 — Connect `ErrandsBoardPage` in `lib/main.dart`

Open `lib/main.dart`.

Import `errands_board_page.dart` and update `home:` to point to `ErrandsBoardPage`:

```dart
import 'package:flutter/material.dart';

import 'pages/errands_board_page.dart';

void main() {
  runApp(const ErrandsApp());
}

class ErrandsApp extends StatelessWidget {
  const ErrandsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Errands Board',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ErrandsBoardPage(),
    );
  }
}
```

Notice how clean `main.dart` is now: it initializes the app and hands off display duties to `ErrandsBoardPage`.

---

## Run the App

Save both files and Hot Reload (`r`) or Hot Restart (`R`).

---

## What You Should See

Three errand cards appear on screen:
1. **Collect parcel from gate** — ₹50
2. **Photocopy notes** — ₹30
3. **Pick up food from canteen** — ₹40

---

## What Just Happened?

You connected your Dart data model to real Flutter widgets:
* `errands` holds 3 instances of `Errand` in memory.
* `ListView.builder` looped over the list and built a `Card` for each one.
* `main.dart` set `ErrandsBoardPage` as the root screen.

In the next step, we will extract that card layout into a clean, reusable widget.

---

## Common Mistakes

### "Undefined name 'Errand'"
* **Cause**: Missing the model import.
* **Fix**: Ensure `import '../models/errand.dart';` is at the top of `lib/pages/errands_board_page.dart`.

### "A value of type 'List<Errand>' can't be assigned to parameter of type 'Errand'"
* **Cause**: Writing `errands` instead of `errands[index]`.
* **Fix**: Ensure you access a single element using the index: `final errand = errands[index];`.

---

## Checkpoint

You can continue to Step 05 when:

- [ ] `lib/pages/errands_board_page.dart` is created.
- [ ] `lib/main.dart` sets `home: const ErrandsBoardPage()`.
- [ ] Three errand cards appear on your screen with titles, descriptions, and rewards.

---

## What You Learned

* The role of `StatefulWidget` and its private `State` class.
* How to store objects in a `List<Errand>`.
* How `ListView.builder` builds scrollable lists dynamically.
* How `Card` and `ListTile` render structured data rows.

Next: [Step 05 — Create the Errand Card](05-create-the-errand-card.md)
