# Step 10 — Build the Add Errand Form

## What We Are Building

In this step, you will build the screen where students can post a new errand: `AddErrandPage`. You will learn how to capture user input using `Form`, `TextFormField`, and `TextEditingController`, and attach a `FloatingActionButton` to the board screen to launch the form.

---

## What You Will Learn

* How the `Form` widget groups and coordinates multiple inputs
* How `TextFormField` renders input fields on mobile screens
* What a `TextEditingController` does and how to read user-typed text
* Why controllers must be cleaned up in the `dispose()` lifecycle method
* How to attach a `FloatingActionButton.extended` to a `Scaffold`

---

## Starting Point

You should have `lib/pages/errands_board_page.dart` and `lib/pages/errand_detail_page.dart` with working state actions and deletion.

---

## What is a `TextEditingController`?

When a user types on their phone keyboard, the text appears on screen. To read that text in your Dart code, Flutter uses a `TextEditingController`.

A controller listens to text changes. Whenever you want the current text, you call:

```dart
_titleController.text
```

Because controllers consume system memory in the background, you must release them when the page is destroyed by calling `.dispose()` in the widget's `dispose()` method.

---

## Step 1 — Create `lib/pages/add_errand_page.dart`

In your `lib/pages/` folder, create a new file named `add_errand_page.dart`:

```text
lib/
└── pages/
    ├── add_errand_page.dart
    ├── errand_detail_page.dart
    └── errands_board_page.dart
```

---

## Step 2 — Implement the Form Structure

Open `lib/pages/add_errand_page.dart` and add:

```dart
import 'package:flutter/material.dart';

import '../models/errand.dart';

/// Screen where users can enter details to post a new errand.
class AddErrandPage extends StatefulWidget {
  const AddErrandPage({super.key});

  @override
  State<AddErrandPage> createState() => _AddErrandPageState();
}

class _AddErrandPageState extends State<AddErrandPage> {
  // Key used to coordinate form validation (we will use this in Step 11)
  final _formKey = GlobalKey<FormState>();

  // Controllers to read what the user types
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rewardController = TextEditingController();

  @override
  void dispose() {
    // Controllers hold resources, so dispose them when the page is closed
    _titleController.dispose();
    _descriptionController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // We will add validation and return data in Step 11!
    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Reward: ${_rewardController.text}');
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
              // 1. Title Input
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Collect parcel from gate',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // 2. Description Input
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Pick up package from main gate before 5 PM',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // 3. Reward Input
              TextFormField(
                controller: _rewardController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Reward (₹)',
                  hintText: 'e.g., 50',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24.0),

              // 4. Submit Button
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
```

### What this code means
* `SingleChildScrollView`: When the on-screen keyboard appears, it covers half the screen. Wrapping the form in `SingleChildScrollView` prevents keyboard overflow errors by making the view scrollable.
* `TextFormField`: A Material text input. `OutlineInputBorder()` gives it a clean, modern rectangular border.
* `keyboardType: TextInputType.number`: Automatically opens the numeric keypad when the user taps into the reward box.
* `maxLines: 3`: Expands the description box vertically for longer instructions.

---

## Step 3 — Add the Floating Action Button to the Board

Open `lib/pages/errands_board_page.dart`.

Add the import at the top of the file:

```dart
import 'add_errand_page.dart';
```

Inside `_ErrandsBoardPageState`, add an `_openAddErrand` method above `_openDetail`:

```dart
  // Navigates to the Add Errand page
  void _openAddErrand() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddErrandPage(),
      ),
    );
  }
```

Now, inside the `Scaffold` of `ErrandsBoardPage`, add the `floatingActionButton:` property:

```dart
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openAddErrand,
          icon: const Icon(Icons.add),
          label: const Text('Post Errand'),
        ),
```

---

## Run the App

Save both files and Hot Reload (`r`).

---

## What You Should See

* In the bottom-right corner of the Errands Board, a purple floating button reading **+ Post Errand** appears.
* Tapping **Post Errand** opens the form screen.
* You can type in the Title, Description, and Reward boxes.
* Tapping Reward brings up the numeric keyboard.
* Tapping the purple **Post Errand** button prints what you typed to your debug console.

---

## What Just Happened?

You assembled the input pipeline:
* `TextEditingController` reads user keystrokes into Dart variables.
* `FloatingActionButton.extended` launches the form from the board.
* `SingleChildScrollView` and `keyboardType` ensure comfortable mobile ergonomics.

In the next step, we will validate the inputs and return the newly created errand to the board!

---

## Common Mistakes

### "A RenderFlex overflowed by X pixels on the bottom"
* **Cause**: Missing `SingleChildScrollView`. The on-screen keyboard pushed the form beyond the screen boundary.
* **Fix**: Ensure your `Form` is wrapped inside a `SingleChildScrollView`.

### Forgetting to dispose controllers
* **Cause**: Omitting `_controller.dispose()` in `dispose()`.
* **Fix**: Always call `.dispose()` on every controller you create when the widget is destroyed.

---

## Checkpoint

You can continue to Step 11 when:

- [ ] A "Post Errand" floating button appears on the board.
- [ ] Tapping the button opens `AddErrandPage`.
- [ ] You can type in all three text fields.
- [ ] Tapping "Post Errand" prints your text to your terminal console.

---

## What You Learned

* How `Form` and `TextFormField` build user input interfaces.
* How `TextEditingController` captures typed text.
* Why `dispose()` is needed to free memory.
* How to add a `FloatingActionButton` to a `Scaffold`.

Next: [Step 11 — Add Form Validation](11-add-form-validation.md)
