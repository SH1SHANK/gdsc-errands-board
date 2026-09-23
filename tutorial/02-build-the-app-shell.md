# Step 02 — Build the App Shell

## What We Are Building

In this step, you will clear out the sample counter code in `lib/main.dart` and build the foundational shell of the **Errands Board** app using `MaterialApp`, `Scaffold`, and `AppBar`.

---

## What You Will Learn

* What the `main()` function and `runApp()` do
* What a widget is in Flutter
* What `MaterialApp` configures
* How `Scaffold` and `AppBar` provide the basic layout of a mobile screen

---

## Starting Point

You should have a freshly generated Flutter project with `lib/main.dart` displaying the default counter app.

---

## Step 1 — Clear `lib/main.dart` and Add the Import

Open `lib/main.dart`. Delete all of the generated code inside the file so you start with a blank document.

At the very top of `lib/main.dart`, add:

```dart
import 'package:flutter/material.dart';
```

### What this line means
Flutter builds user interfaces using pre-made components called **widgets**. Google's design system is called **Material Design**. Importing `flutter/material.dart` gives this file access to all built-in Material widgets: app bars, buttons, text fields, cards, and theme colors.

---

## Step 2 — Add the `main()` Entry Function

Directly below the import in `lib/main.dart`, add:

```dart
void main() {
  runApp(const ErrandsApp());
}
```

### What this code means
* `void main()`: The entry point of every Dart program. When the app launches, Dart runs this function first.
* `runApp(...)`: Takes a widget and makes it the root of the screen.
* `const ErrandsApp()`: Tells Flutter to display our root widget, which we will define next.

---

## Step 3 — Create the `ErrandsApp` Widget

Below the `main()` function in `lib/main.dart`, add:

```dart
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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Errands Board'),
        ),
        body: const Center(
          child: Text('Welcome to Errands Board!'),
        ),
      ),
    );
  }
}
```

### What this code means
* `class ErrandsApp extends StatelessWidget`: A `StatelessWidget` is a widget that does not store changing data. Its appearance is fixed when built.
* `Widget build(BuildContext context)`: Every widget has a `build` method that returns what should be drawn on the screen.
* `MaterialApp`: The wrapper for your whole application. It configures the app title, the Material 3 color theme, and the starting screen (`home:`).
* `Scaffold`: The standard visual structure for a mobile screen. It provides slots for an app bar, body content, and buttons.
* `AppBar`: The top header bar. Here, it displays the text `"Errands Board"`.
* `Center`: Centers its child widget directly in the middle of the screen.

---

## Run the App

Save `lib/main.dart`. If your app is already running, press `r` in the terminal to trigger a **Hot Reload**. If not, run:

```bash
flutter run
```

---

## What You Should See

* The counter app is gone.
* A top app bar with the title **Errands Board**.
* A light purple-tinted theme.
* Centered text in the middle of the screen reading: `"Welcome to Errands Board!"`.

---

## What Just Happened?

You built the visual foundation of the application:
1. `main()` started the app.
2. `ErrandsApp` created a `MaterialApp` with Material 3 styling.
3. `Scaffold` and `AppBar` created our first screen structure.

In the next step, we will define the Dart data model that represents an errand.

---

## Common Mistakes

### Missing semicolons
* **Error**: `Expected to find ';'.`
* **Fix**: In Dart, every statement ends with a semicolon `;`. Check the end of lines like `runApp(const ErrandsApp());`.

### Unmatched brackets or parentheses
* **Error**: `Expected '}'` or `Expected ')'`.
* **Fix**: Widgets nest inside one another. Ensure every `(` has a matching `)` and every `{` has a matching `}`. Use auto-format in your editor (`Shift+Option+F` on macOS or `Shift+Alt+F` on Windows).

---

## Checkpoint

You can continue to Step 03 when:

- [ ] `lib/main.dart` contains only the code shown above.
- [ ] There are zero red squiggly lines in your editor.
- [ ] The app displays an AppBar with "Errands Board".
- [ ] Centered text reads "Welcome to Errands Board!".

---

## What You Learned

* How `main()` and `runApp()` start a Flutter application.
* What a `StatelessWidget` and its `build()` method do.
* How `MaterialApp` configures application-wide settings and themes.
* How `Scaffold` and `AppBar` create the primary screen layout.

Next: [Step 03 — Create the Errand Model](03-create-the-errand-model.md)
