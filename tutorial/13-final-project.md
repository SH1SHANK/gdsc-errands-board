# Step 13 — Final Project & Architecture

## What We Built

Congratulations on finishing the application! You have built the complete **Errands Board** from an empty directory into a fully functioning, multi-screen mobile task marketplace.

In this final chapter, we will review the overall architecture, run automated code quality tools, and perform a comprehensive test of all user flows.

---

## Final Project Architecture

Your application code in `lib/` is organized into four intuitive directories:

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

---

## File Responsibility Breakdown

| File | Purpose | Responsibilities |
| :--- | :--- | :--- |
| `lib/main.dart` | Application Bootstrap | Boots the app with `runApp()`, configures `MaterialApp`, sets the Material 3 theme. |
| `lib/models/errand.dart` | Domain Model | Defines the `Errand` data class and `ErrandStatus` enum (`open`, `accepted`, `done`). |
| `lib/pages/errands_board_page.dart` | Master Screen & State Owner | **Single source of truth**: owns `List<Errand>`, manages 3 tabs (**Open**, **Mine**, **Done**), orchestrates FAB and delete callback. |
| `lib/pages/errand_detail_page.dart` | Detail View & Actions | Displays task details; handles **Accept**, **Complete**, and **Delete** actions. |
| `lib/pages/add_errand_page.dart` | Form & Validation | Collects title, description, reward; validates inputs; returns new `Errand` to the board. |
| `lib/widgets/errand_card.dart` | Reusable UI Component | Renders an individual errand card with title, reward, and description; reports taps via `onTap`. |

---

## Automated Verification Commands

In your project terminal, run these three standard quality commands:

### 1. Code Formatting
```bash
dart format lib test
```
Formats all Dart files according to official style guidelines.

### 2. Static Code Analysis
```bash
flutter analyze
```
Verifies there are zero errors, zero warnings, and zero unused imports. You should see:
```text
Analyzing errands_app...
No issues found!
```

### 3. Automated Test Suite
```bash
flutter test
```
Executes the automated widget test suite. You should see:
```text
00:00 +0: App displays initial seed errands and handles tab switching
00:00 +1: Accepting and completing an errand updates status and tabs
00:00 +2: Creating a new errand with validation adds it to the board
00:00 +3: Deleting an errand removes it from the list after confirmation
00:00 +4: All tests passed!
```

---

## Complete Manual Testing Checklist

Run `flutter run` and verify each item:

### 1. Board & Tabs
- [ ] The app launches with the title "Errands Board".
- [ ] Three tabs are visible: **Open**, **Mine**, **Done**.
- [ ] Three sample campus errands appear in the **Open** tab.
- [ ] The **Mine** tab displays: *"You haven't posted or accepted any errands yet."*.
- [ ] The **Done** tab displays: *"No completed errands yet."*.

### 2. Detail View & Lifecycle
- [ ] Tapping an errand opens `ErrandDetailPage` displaying its title, reward, status chip (OPEN), and description.
- [ ] Tapping **Accept Errand** updates the status chip to ACCEPTED and button to **Complete Errand**.
- [ ] Tapping the back arrow shows the errand has moved from **Open** into **Mine**.
- [ ] Tapping **Complete Errand** updates the status chip to DONE.
- [ ] Tapping the back arrow shows the errand is now in **Mine** and **Done**.

### 3. Posting an Errand
- [ ] Tapping **+ Post Errand** opens `AddErrandPage`.
- [ ] Submitting empty fields displays red validation errors.
- [ ] Entering `0` or negative rewards displays *"Reward must be greater than 0"*.
- [ ] Submitting a valid errand closes the form and returns to the board.
- [ ] The new errand appears immediately in **Open** and **Mine**.

### 4. Deleting an Errand
- [ ] Opening your own errand displays a red **Delete Errand** button.
- [ ] Tapping **Delete Errand** displays an `AlertDialog` confirmation.
- [ ] Tapping **Cancel** dismisses the dialog without deleting.
- [ ] Tapping **Delete** removes the errand from the master list and returns to the board.

---

## Final Self-Assessment

Can you explain these 14 core concepts to a classmate?

1. **What is a Flutter widget?**
   A visual building block of a Flutter UI (such as text, rows, columns, or buttons).
2. **What is a StatefulWidget?**
   A widget that stores mutable data and can rebuild its appearance when that data changes.
3. **What is state?**
   The active data in memory that determines what is currently displayed on screen.
4. **Why do we use `setState()`?**
   To inform Flutter that data has changed, prompting it to call `build()` and redraw the interface.
5. **What is a `List<Errand>`?**
   A typed Dart collection that stores multiple `Errand` objects in order.
6. **How does `ListView.builder` work?**
   It constructs list rows on demand as the user scrolls, conserving device memory.
7. **What is a reusable widget?**
   A standalone component (like `ErrandCard`) that encapsulates layout logic so it can be reused without duplication.
8. **How does `Navigator.push()` work?**
   Pushes a new screen onto the top of Flutter's navigation stack.
9. **How does `Navigator.pop()` work?**
   Removes the topmost screen from the navigation stack, revealing the screen underneath.
10. **How do we pass data to another page?**
    Through the destination page's constructor parameters (`ErrandDetailPage(errand: errand)`).
11. **How does a `Form` work?**
    It groups form fields together and coordinates validation using a `GlobalKey<FormState>`.
12. **What does a `validator` function do?**
    Inspects input text and returns an error message if invalid, or `null` if valid.
13. **What is CRUD?**
    Create, Read, Update, Delete: the four fundamental data operations of software development.
14. **Where is this application's state stored?**
    In memory inside `_ErrandsBoardPageState`, serving as the single source of truth for the entire app.

---

## Next Steps

You now have a solid understanding of core Flutter fundamentals. You can:
* Add new fields to the `Errand` model (such as a category or due time).
* Personalize the Material 3 theme in `lib/main.dart` with custom color schemes.
* Explore building other campus or productivity applications using the same patterns!
