# Step 12 — Complete CRUD

## What We Are Building

In this step, you will review the complete application through one of the most foundational concepts in software engineering: **CRUD** (Create, Read, Update, Delete). You will trace where each operation lives in your code and test the entire data lifecycle.

---

## What You Will Learn

* What CRUD stands for and why it underpins nearly every mobile application
* Where each CRUD operation is implemented in Errands Board
* How state management and Dart object references coordinate all four operations
* Why in-memory state provides a clean foundation for app development

---

## Starting Point

You should have all screens, forms, tabs, state actions, and deletion safeguards fully built and running.

---

## The CRUD Framework

CRUD describes the four basic operations performed on persistent or in-memory data:

| Operation | Meaning | In Errands Board | Code Location |
| :--- | :--- | :--- | :--- |
| **Create** | Make a new item | Post Errand form | `lib/pages/add_errand_page.dart` |
| **Read** | View or display items | Feed cards & Detail page | `lib/pages/errands_board_page.dart` & `lib/pages/errand_detail_page.dart` |
| **Update** | Modify an existing item | Accept & Complete actions | `lib/pages/errand_detail_page.dart` |
| **Delete** | Remove an existing item | Delete Errand with dialog | `lib/pages/errand_detail_page.dart` & callback in `errands_board_page.dart` |

---

## Tracing CRUD in Your Code

### 1. Create
* The user inputs details into `AddErrandPage`.
* Upon passing validation, an `Errand` object is instantiated:
  ```dart
  final newErrand = Errand(
    title: ...,
    description: ...,
    reward: ...,
    status: ErrandStatus.open,
    isMine: true,
  );
  ```
* `Navigator.pop(context, newErrand)` passes it back to `ErrandsBoardPage`.
* `_ErrandsBoardPageState` appends it to the master list inside `setState()`:
  ```dart
  setState(() {
    errands.add(newErrand);
  });
  ```

### 2. Read
* **Overview Feed**: `_ErrandsBoardPageState` reads `errands`, applies `.where()` filters, and maps each item to an `ErrandCard`.
* **Deep View**: Tapping a card passes the selected `Errand` to `ErrandDetailPage(errand: errand)` to inspect full details.

### 3. Update
* On `ErrandDetailPage`, tapping **Accept Errand** modifies the object:
  ```dart
  setState(() {
    errand.status = ErrandStatus.accepted;
    errand.isMine = true;
  });
  ```
* Tapping **Complete Errand** modifies it again:
  ```dart
  setState(() {
    errand.status = ErrandStatus.done;
  });
  ```
* Because Dart passes objects by reference, modifying `errand` changes the actual instance in the master list. Returning to the board triggers `setState(() {})`, moving the errand to the correct tab.

### 4. Delete
* On `ErrandDetailPage`, tapping **Delete Errand** prompts an `AlertDialog`.
* If confirmed, `widget.onDelete()` calls the parent callback:
  ```dart
  setState(() {
    errands.remove(errand);
  });
  Navigator.pop(context);
  ```
* The errand is removed from the master list, and the detail screen closes.

---

## Verify the Complete Lifecycle

Restart your app (`R` in the terminal) and test the full cycle in order:

1. **[Create]**: Tap **+ Post Errand** and add *"Return library book"*, reward `15`. Verify it appears in **Open** and **Mine**.
2. **[Read]**: Open *"Return library book"* to read its full description and reward.
3. **[Update]**: Tap **Accept Errand** (status becomes ACCEPTED). Tap **Complete Errand** (status becomes DONE). Return to board and check the **Done** tab.
4. **[Delete]**: Open *"Return library book"* from the **Done** tab, tap **Delete Errand**, and confirm deletion. Verify it disappears from all tabs.

---

## What Just Happened?

You built and verified a complete CRUD mobile application using pure in-memory state:
* Data is stored cleanly in a central `List<Errand>`.
* Changes trigger predictable UI rebuilds using `setState()`.
* No third-party state libraries or network requests were required.

---

## Common Mistakes

### Expecting in-memory data to survive app restarts
* **Concept**: In-memory state lives in device RAM while the app runs. When you fully stop and relaunch the app, the list resets back to the initial sample errands. This is expected behavior for local state.

---

## Checkpoint

You can continue to Step 13 when:

- [ ] You can explain the four CRUD operations.
- [ ] You can locate where Create, Read, Update, and Delete happen in your code.
- [ ] You have verified the complete lifecycle from creation to deletion live on your device.

---

## What You Learned

* The meaning of CRUD and how it maps to app features.
* How Dart object references allow in-place data updates.
* How `setState()` propagates CRUD changes to the screen.

Next: [Step 13 — Final Project & Architecture](13-final-project.md)
