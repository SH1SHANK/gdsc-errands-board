# Errands Board Tutorial

A step-by-step beginner guide for building the **Errands Board** campus task application from scratch. This tutorial is designed for the **GDSC Flutter App Development Workshop 2026**.

No prior experience with Flutter or Dart is required. Every concept is introduced step-by-step as you build the application.

---

## What We Are Building

Errands Board is a campus task exchange app where university students can post, accept, complete, and delete everyday favors:
* Picking up an Amazon package from the campus gate
* Photocopying lecture notes from the library
* Grabbing a sandwich from the canteen before class

The finished app features:
* **Three Task Tabs**:
  * **Open**: Tasks waiting for someone to help.
  * **Mine**: Tasks you have posted or accepted to help with.
  * **Done**: Tasks that have been finished.
* **Core Actions**:
  * Post a new errand with a title, description, and reward.
  * View full errand details and live status.
  * Accept an open errand.
  * Mark an accepted errand as complete.
  * Delete your own errands with a confirmation dialog.

All application data is stored in local memory using Flutter's built-in state tools. No database, server, or cloud setup is required.

---

## Prerequisites

Before starting, ensure your development environment is set up:
* **Flutter SDK**: Version 3.47.5 (Stable channel)
* **Dart SDK**: Version 3.13.4
* A code editor: Visual Studio Code or Android Studio with the Flutter extension installed.
* A target device: Android emulator, iOS simulator, macOS desktop, or Google Chrome.

Verify your setup by running in your terminal:

```bash
flutter --version
flutter doctor
```

Make sure `flutter doctor` reports no blocking issues before continuing.

---

## Final Project Structure

By the end of this tutorial, your `lib/` directory will have this clean, organized structure:

```text
lib/
├── main.dart
├── models/
│   └── errand.dart
├── pages/
│   ├── errands_board_page.dart
│   ├── errand_detail_page.dart
│   └── add_errand_page.dart
└── widgets/
    └── errand_card.dart
```

* `main.dart`: Boots the application and applies the theme.
* `models/`: Defines data structures (`Errand`, `ErrandStatus`).
* `pages/`: Contains complete screens (`ErrandsBoardPage`, `ErrandDetailPage`, `AddErrandPage`).
* `widgets/`: Contains reusable visual components (`ErrandCard`).

---

## How to Use This Guide

Follow the chapters in order. Do not skip ahead to the final code.

Each chapter follows a five-step workshop loop:
1. **Explain the concept**: Understand why the feature is needed.
2. **Write the code**: Add small, focused blocks of code to a specific file.
3. **Run the app**: Execute `flutter run` or Hot Reload.
4. **Observe the result**: Confirm the screen matches the expected visual output.
5. **Verify the checkpoint**: Review common mistakes and check off your progress.

---

## Tutorial Roadmap

* [Step 01 — Create the Project](01-create-the-project.md): Generate the Flutter app and understand the project files.
* [Step 02 — Build the App Shell](02-build-the-app-shell.md): Set up `main()`, `MaterialApp`, `Scaffold`, and `AppBar`.
* [Step 03 — Create the Errand Model](03-create-the-errand-model.md): Define classes, properties, and the `ErrandStatus` enum.
* [Step 04 — Display Errands](04-display-errands.md): Use `StatefulWidget`, in-memory lists, and `ListView.builder`.
* [Step 05 — Create the Errand Card](05-create-the-errand-card.md): Extract reusable UI into a custom `ErrandCard` widget.
* [Step 06 — Add the Tabs](06-add-the-tabs.md): Implement `DefaultTabController`, `.where()` filtering, and empty states.
* [Step 07 — Add Navigation](07-add-navigation.md): Move between screens using `Navigator.push()` and pass objects.
* [Step 08 — Build the Detail Page](08-build-the-detail-page.md): Layout task details, status chips, and conditional action buttons.
* [Step 09 — Add Errand Actions](09-add-errand-actions.md): Update state with `setState()`, handle callbacks, and show confirmation dialogs.
* [Step 10 — Build the Add Errand Form](10-build-the-add-errand-form.md): Capture input using `Form`, `TextFormField`, and `TextEditingController`.
* [Step 11 — Add Form Validation](11-add-form-validation.md): Enforce validation rules and return newly created errands with `Navigator.pop()`.
* [Step 12 — Complete CRUD](12-complete-crud.md): Understand how Create, Read, Update, and Delete map across the codebase.
* [Step 13 — Final Project & Architecture](13-final-project.md): Review the architecture, run automated tests, and complete the self-assessment.

---

## Learning Outcomes

After completing this tutorial, you will be able to:
* Explain what a widget is and how to nest widgets to build mobile layouts.
* Explain the difference between `StatelessWidget` and `StatefulWidget`.
* Use `setState()` to update the user interface when data changes.
* Structure data using Dart classes and enums.
* Render dynamic, scrollable lists with `ListView.builder`.
* Move between pages using `Navigator.push()` and return data with `Navigator.pop()`.
* Build forms with input controllers and validate user input.
* Implement complete in-memory CRUD operations in Flutter.

Begin with [Step 01 — Create the Project](01-create-the-project.md).
