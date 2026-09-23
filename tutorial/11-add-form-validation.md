# Step 11 — Add Form Validation

## What We Are Building

In this step, you will add validation rules to your form. You will ensure that blank fields and invalid rewards are stopped before submission. Once valid, the form will construct a new `Errand` object and return it back to the Errands Board using `Navigator.pop(context, newErrand)`.

---

## What You Will Learn

* How `GlobalKey<FormState>` validates all fields with a single call to `.validate()`
* How to write `validator:` functions for `TextFormField`
* How `int.tryParse()` safely converts user-typed text to numbers without crashing
* How to return data back to a previous screen using `Navigator.pop(context, result)`
* How the receiving screen receives and incorporates the returned data

---

## Starting Point

You should have `lib/pages/add_errand_page.dart` rendering the three form inputs and the Post button.

---

## What is Form Validation?

Validation checks that user input meets your requirements before your code attempts to process it:
* If the user leaves the title blank, the app stops them and displays: *"Please enter a title"*.
* If the user enters `"0"` or text in the reward field, the app rejects it: *"Reward must be greater than 0"*.
* Only when all fields are valid does the app create the errand.

In Flutter, a validator function returns:
* A `String` containing an error message if the input is **invalid**.
* `null` if the input is **valid**.

---

## Step 1 — Add Validators to the Inputs

Open `lib/pages/add_errand_page.dart`.

Add the `validator:` property to all three `TextFormField` widgets:

### 1. Title Input
```dart
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'e.g., Collect parcel from gate',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null; // Returning null means valid!
                },
              ),
```

### 2. Description Input
```dart
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'e.g., Pick up package from main gate before 5 PM',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
```

### 3. Reward Input
```dart
              TextFormField(
                controller: _rewardController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Reward (₹)',
                  hintText: 'e.g., 50',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a reward amount';
                  }
                  final parsedNumber = int.tryParse(value.trim());
                  if (parsedNumber == null || parsedNumber <= 0) {
                    return 'Reward must be greater than 0';
                  }
                  return null;
                },
              ),
```

### Why `int.tryParse()`?
The user types text (`String`), but `Errand.reward` requires a number (`int`).
* `int.tryParse("50")` returns `50`.
* `int.tryParse("xyz")` safely returns `null` instead of throwing a runtime error.

---

## Step 2 — Run Validation and Pop the New Errand

In `lib/pages/add_errand_page.dart`, replace the `_submitForm()` method with:

```dart
  void _submitForm() {
    // 1. Run all validators across the Form
    if (_formKey.currentState!.validate()) {
      // 2. Construct the new Errand object
      final newErrand = Errand(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        reward: int.parse(_rewardController.text.trim()),
        status: ErrandStatus.open,
        isMine: true, // You posted it, so it is yours!
      );

      // 3. Return the new errand back to the board and close this screen
      Navigator.pop(context, newErrand);
    }
  }
```

### What `Navigator.pop(context, newErrand)` does
`Navigator.pop(context)` closes the current screen. By passing `newErrand` as a second argument, Flutter delivers that object back to the screen that pushed this route!

---

## Step 3 — Receive the Errand in `errands_board_page.dart`

Open `lib/pages/errands_board_page.dart`.

Update `_openAddErrand()` to:
1. Make the method `async`.
2. Add `await` and `<Errand>` to `Navigator.push<Errand>`.
3. Check `if (newErrand != null)` and append it to `errands` inside `setState()`:

```dart
  // Navigates to the Add Errand page and adds the result to the list
  void _openAddErrand() async {
    final newErrand = await Navigator.push<Errand>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddErrandPage(),
      ),
    );

    // If the user submitted a valid errand, add it and rebuild the UI
    if (newErrand != null) {
      setState(() {
        errands.add(newErrand);
      });
    }
  }
```

---

## Run the App

Save both files and Hot Reload (`r`).

Let's test our validation:
1. Tap **+ Post Errand**.
2. Leave all fields completely blank and tap **Post Errand**.
   * Red error messages appear under all three fields.
3. Type a title and description, but enter `0` for Reward.
   * The reward field shows: *"Reward must be greater than 0"*.
4. Enter valid data:
   * Title: `Buy stationery`
   * Description: `Get 2 blue gel pens from the campus shop`
   * Reward: `25`
5. Tap **Post Errand**:
   * The form closes and returns to the board.
   * **Buy stationery** immediately appears on the **Open** tab.
   * Switch to the **Mine** tab: it appears there too because `isMine == true`!

---

## What Just Happened?

You completed the data creation pipeline:
* `_formKey.currentState!.validate()` checked every field simultaneously.
* `Navigator.pop(context, newErrand)` handed the new object back to the board.
* The board added it to `errands` and called `setState()`, updating both the Open and Mine tabs.

---

## Common Mistakes

### Forgetting to return `null` when valid
* **Symptom**: Field shows an error even when typed correctly.
* **Fix**: In a validator function, returning `null` means the input is valid.

### Form doesn't validate on submit
* **Cause**: Forgetting `if (_formKey.currentState!.validate())`.
* **Fix**: Ensure `_formKey` is attached to `Form(key: _formKey)` and called in `_submitForm()`.

---

## Checkpoint

You can continue to Step 12 when:

- [ ] Leaving fields blank displays red validation errors.
- [ ] Entering `0` or negative rewards displays "Reward must be greater than 0".
- [ ] Submitting a valid errand closes the form and returns to the board.
- [ ] The newly created errand appears in both the **Open** and **Mine** tabs.

---

## What You Learned

* How `GlobalKey<FormState>` coordinates form validation.
* How to write `validator:` functions for `TextFormField`.
* How `int.tryParse()` safely parses strings.
* How to return data using `Navigator.pop(context, result)`.

Next: [Step 12 — Complete CRUD](12-complete-crud.md)
