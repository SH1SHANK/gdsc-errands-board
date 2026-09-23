# Errands Board

A lightweight campus task exchange system built with Flutter and Dart for the Google Developer Student Clubs (GDSC) App Dev Workshop 2026.

---

## Executive Summary

Errands Board is a mobile campus marketplace that enables students to publish, discover, claim, and complete everyday logistical tasks within a localized university ecosystem. The system addresses common student micro-coordination bottlenecks—such as gate package deliveries, printouts, and campus food pickups—by providing an open task board with real-time state tracking and task lifecycle management.

Engineered with Flutter's core framework primitives, the application demonstrates production-grade engineering principles: predictable unidirectional data flow, explicit state ownership, disciplined resource lifecycle management, and comprehensive widget test coverage without third-party dependencies.

---

## System Architecture

The application adopts a modular, domain-driven layered architecture that cleanly separates presentation concerns, state management, and domain models.

### Directory Structure

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

### Module Responsibilities

| Layer / File | Component Type | Primary Responsibility |
| :--- | :--- | :--- |
| `lib/main.dart` | Application Bootstrap | Configures the application entry point, root `MaterialApp`, and global Material 3 theme scheme. |
| `lib/models/errand.dart` | Domain Model | Defines the core domain entity (`Errand`) and task lifecycle state machine (`ErrandStatus`). |
| `lib/pages/errands_board_page.dart` | Root Screen & State Controller | Serves as the single source of truth for task state, orchestrates tab filtering, manages navigation, and handles list mutations. |
| `lib/pages/errand_detail_page.dart` | Detail View & Action Processor | Displays entity attributes, manages task transitions (`open` -> `accepted` -> `done`), and initiates deletion confirmation. |
| `lib/pages/add_errand_page.dart` | Form View & Input Validator | Manages input controllers, enforces validation contracts, and instantiates valid `Errand` instances. |
| `lib/widgets/errand_card.dart` | Atomic UI Component | Renders an individual errand card with title, description truncation, and reward metadata. Decoupled from state and navigation. |

---

## Technical Architecture & State Flow

### Unidirectional Data Flow

Application state is held exclusively at the highest relevant level of the widget hierarchy: `_ErrandsBoardPageState`. Child routes and widgets interact with the master state through explicit interfaces:

1. **Downwards Propagation**: State is passed down to child widgets through constructor arguments (`ErrandCard(errand: ...)`, `ErrandDetailPage(errand: ...)`).
2. **Upwards Notification**: State changes are communicated back to parent owners via strongly typed callbacks (`VoidCallback onDelete`) or asynchronous route returns (`Navigator.pop(context, newErrand)`).

```text
                   +-------------------------------+
                   |     _ErrandsBoardPageState    |
                   |   (Master List<Errand> State) |
                   +---------------+---------------+
                                   |
         +-------------------------+-------------------------+
         |                                                   |
         v                                                   v
+------------------+                              +--------------------+
|    ErrandCard    |                              |   AddErrandPage    |
| (Pure UI Render) |                              | (Form Validation)  |
+--------+---------+                              +---------+----------+
         |                                                  |
         | onTap()                                          | Navigator.pop(newErrand)
         v                                                  v
+----------------------+                          +--------------------+
|   ErrandDetailPage   |                          | Master List Append |
| (State Transitions)  |                          | (setState Rebuild) |
+----------+-----------+                          +--------------------+
           |
           +---> Accepted / Done: Local Mutation & Parent Re-render
           +---> Delete: onDelete() Callback -> Master List Removal
```

### Finite State Machine (Task Lifecycle)

Every task conforms to a deterministic finite state machine governed by the `ErrandStatus` enum and the `isMine` ownership flag.

```text
       [ Post Errand Form ]
                 |
                 v
           +-----------+
           |   OPEN    | <------------------ Visible in "Open" Tab
           +-----+-----+
                 |
                 | Accept Errand (status = accepted, isMine = true)
                 v
           +-----------+
           | ACCEPTED  | <------------------ Visible in "Mine" Tab
           +-----+-----+
                 |
                 | Complete Errand (status = done)
                 v
           +-----------+
           |   DONE    | <------------------ Visible in "Mine" & "Done" Tabs
           +-----------+
```

State transition rules:
* **Creation**: Instantiated with `ErrandStatus.open` and `isMine = true`.
* **Acceptance**: Permitted only when `status == ErrandStatus.open`. Transitions `status` to `accepted` and assigns `isMine = true`.
* **Completion**: Permitted only when `status == ErrandStatus.accepted` and `isMine == true`. Transitions `status` to `done`.
* **Deletion**: Permitted only when `isMine == true`. Requires explicit user confirmation before executing list removal.

---

## Engineering Details

### State Management Strategy
* **Zero External Dependencies**: The application utilizes Flutter's native `StatefulWidget` and `setState()` primitives, avoiding the overhead, boilerplate, and dependency coupling of external state management libraries.
* **Predictable Garbage Collection & Resource Disposal**: Input controllers (`_titleController`, `_descriptionController`, `_rewardController`) are explicitly unregistered within the `dispose()` lifecycle method to prevent memory leaks.
* **Separation of Presentation and Business Logic**: Pure presentation widgets (`ErrandCard`) possess no state mutators or route handling logic, maximizing testability and reusability.

### Form Validation Engine
Input validation in `AddErrandPage` uses standard `FormState` validation rules:
* **Title**: Trims whitespace; enforces non-empty input.
* **Description**: Trims whitespace; enforces non-empty input across multiline entries.
* **Reward**: Enforces non-empty string, valid integer parsing via `int.tryParse()`, and boundary condition check (`reward > 0`).

---

## Testing Strategy & Quality Assurance

The codebase includes an automated widget test suite in `test/widget_test.dart` that validates UI rendering, tab filtering, navigation pipelines, input validation, and CRUD operations.

### Test Matrix

| Test Suite | Target Feature | Validation Criteria |
| :--- | :--- | :--- |
| `App displays initial seed errands and handles tab switching` | Feed Rendering & Tabs | Verifies initial campus seed data, tab transitions, and empty-state fallbacks for "Mine" and "Done" tabs. |
| `Accepting and completing an errand updates status and tabs` | Lifecycle State Machine | Tests route push to `ErrandDetailPage`, status transition from `open` to `accepted`, transition to `done`, and cross-tab propagation upon pop. |
| `Creating a new errand with validation adds it to the board` | Form Engine & Navigation | Verifies boundary validation triggers, negative/zero reward rejections, valid model construction, and dynamic feed insertion. |
| `Deleting an errand removes it from the list after confirmation` | Deletion Safeguard | Verifies dialog prompt appearance, cancellation preservation, confirmed deletion callback execution, and board eviction. |

### Quality Enforcement Commands

Run static code analysis:
```bash
flutter analyze
```

Verify formatting compliance:
```bash
dart format --output=none --set-exit-if-changed lib test
```

Execute automated test suite:
```bash
flutter test
```

---

## System Requirements & Toolchain

| Component | Specification |
| :--- | :--- |
| Framework | Flutter 3.47.5 (Channel Stable) |
| Runtime | Dart 3.13.4 |
| Target Environments | Android (API 21+), macOS Desktop, iOS (12.0+), Web (WASM / CanvasKit) |
| Architecture Standard | Material Design 3 |
| Package Dependencies | None (`flutter` SDK only) |

---

## Local Setup & Execution

### 1. Environment Preparation
Verify your local Flutter environment passes all system health checks:
```bash
flutter doctor
```

### 2. Dependency Resolution
Fetch internal Flutter SDK packages:
```bash
flutter pub get
```

### 3. Execution Targets

* **Android Emulator / Connected Device**:
  ```bash
  flutter run -d <device_id>
  ```
  *(To list attached devices: `flutter devices`)*

* **macOS Desktop**:
  ```bash
  flutter run -d macos
  ```

* **Web Browser (Google Chrome)**:
  ```bash
  flutter run -d chrome
  ```

---

## Cloud Integration Roadmap (Firebase Architecture Preview)

The Errands Board in-memory state contracts are specifically structured to map directly to a cloud document database (Google Cloud Firestore):

```text
In-Memory Contract                     Cloud Datastore Equivalent (Firestore)
----------------------------------     ---------------------------------------
List<Errand> errands               -->  CollectionReference ('errands')
errands.where(...)                 -->  Query: collection.where('status', isEqualTo: 'open')
errands.add(newErrand)             -->  collection.add(newErrand.toMap())
errand.status = ErrandStatus.done  -->  documentReference.update({'status': 'done'})
errands.remove(errand)             -->  documentReference.delete()
setState(() {})                    -->  StreamBuilder<QuerySnapshot> / StreamSubscription
```

By decoupling presentation from storage mechanisms, cloud persistence can be introduced without altering UI layouts, widget boundaries, or page contracts.

---

## License & Attribution

Developed as reference curriculum for the **GDSC Flutter App Development Workshop 2026**.
Google Developer Student Clubs (GDSC).
