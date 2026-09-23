# Step 03 — Create the Errand Model

## What We Are Building

In this step, you will create a dedicated Dart data model to represent an errand. You will define an `ErrandStatus` enum and an `Errand` class to store task attributes like title, description, reward, status, and ownership.

---

## What You Will Learn

* What a `class` is and why apps use models to bundle related data
* What an `object` is
* How an `enum` prevents typos by restricting values to a fixed set of choices
* What a constructor is, what `required` means, and how default values work

---

## Starting Point

You should have `lib/main.dart` displaying the basic "Errands Board" app bar and welcome text.

---

## Why Do We Need a Model?

Every errand has multiple related pieces of information:
* Title (text)
* Description (text)
* Reward amount (whole number)
* Progress status (open, accepted, done)
* Ownership (whether it was posted or accepted by you)

Instead of managing separate lists of strings and numbers, Dart lets you define a **class**. A class is a blueprint that groups these fields together. Each individual errand you create from that blueprint is called an **object**.

---

## Step 1 — Create the `models/` Directory and File

In your editor, create a new folder inside `lib/` named `models`.

Inside `lib/models/`, create a new file named `errand.dart`:

```text
lib/
├── main.dart
└── models/
    └── errand.dart
```

---

## Step 2 — Define the `ErrandStatus` Enum

Open `lib/models/errand.dart` and add this enum at the top:

```dart
/// Represents the current progress of an errand.
enum ErrandStatus {
  open,
  accepted,
  done,
}
```

### What is an Enum?
`enum` is short for "enumeration". It restricts a variable to a strict set of fixed choices.

Instead of using raw text like `'open'` or `'done'` (which can easily cause bugs if misspelled like `'oepn'`), an enum guarantees the status can only be `ErrandStatus.open`, `ErrandStatus.accepted`, or `ErrandStatus.done`. Dart will catch any invalid value immediately as an error.

---

## Step 3 — Define the `Errand` Class

Directly below the enum in `lib/models/errand.dart`, add:

```dart
/// Represents a single errand posted on the board.
class Errand {
  String title;
  String description;
  int reward;
  ErrandStatus status;
  bool isMine;

  Errand({
    required this.title,
    required this.description,
    required this.reward,
    this.status = ErrandStatus.open,
    this.isMine = false,
  });
}
```

### What this code means
1. **Fields (Properties)**:
   * `String title`: The short name of the task.
   * `String description`: Detailed instructions.
   * `int reward`: Whole number for the rupee reward (e.g., `50`).
   * `ErrandStatus status`: Tracks lifecycle state using our enum.
   * `bool isMine`: A boolean (`true` or `false`) indicating if this task belongs to the user.

2. **The Constructor (`Errand({ ... })`)**:
   The function called to create a new `Errand` object.
   * `required this.title`: You *must* supply a title when creating an errand.
   * `required this.description`: Description is also mandatory.
   * `required this.reward`: Reward amount is mandatory.
   * `this.status = ErrandStatus.open`: A default value. If not specified, the errand automatically starts as `open`.
   * `this.isMine = false`: Defaults to `false` unless explicitly passed as `true`.

---

## Verify with Code Analysis

Because `lib/models/errand.dart` contains data definitions rather than visual widgets, your running app screen will not change yet. Verify that your Dart syntax has zero errors by running:

```bash
flutter analyze
```

---

## What You Should See

Your terminal should output:

```text
Analyzing errands_app...
No issues found!
```

---

## Common Mistakes

### File placed in project root
* **Issue**: Creating `errand.dart` directly in the project root instead of inside `lib/models/`.
* **Fix**: Ensure the path is exactly `lib/models/errand.dart`.

### Capitalizing enum values
* **Error**: `Undefined name 'ErrandStatus.Open'.`
* **Fix**: Dart enum values are lowercase: `open`, `accepted`, `done`.

### Missing commas in constructor
* **Fix**: Inside `{ ... }` in a constructor, separate every parameter with a comma `,`.

---

## Checkpoint

You can continue to Step 04 when:

- [ ] `lib/models/errand.dart` exists and has no syntax errors.
- [ ] `ErrandStatus` defines `open`, `accepted`, and `done`.
- [ ] `Errand` defines `title`, `description`, `reward`, `status`, and `isMine`.
- [ ] `flutter analyze` reports `No issues found!`.

---

## What You Learned

* How a `class` bundles related fields into a single data model.
* How an `enum` provides a type-safe list of options.
* How constructor parameters enforce `required` values and provide defaults.

Next: [Step 04 — Display Errands](04-display-errands.md)
