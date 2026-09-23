# Step 08 — Build the Detail Page

## What We Are Building

In this step, you will build out the full visual layout of `ErrandDetailPage`. You will display the status badge using a `Chip`, add the full description, and learn how to use **conditional UI** to render action buttons based on the errand's current state.

---

## What You Will Learn

* How to structure screen layouts using `Column`, `SizedBox`, and `Spacer`
* How to use Flutter's built-in `Chip` widget for status badges
* How Dart's collection `if` syntax conditionally displays widgets inside widget trees
* Why UI should be a direct reflection of underlying data properties

---

## Starting Point

You should have `lib/pages/errand_detail_page.dart` receiving an `errand` and displaying its title and reward.

---

## What is Conditional UI?

In mobile development, the actions available on a screen should match what is logically possible for that item:
* If a task is **Open**, show an **"Accept Errand"** button.
* If a task is **Accepted** and belongs to you, show a **"Complete Errand"** button.
* If a task is **Done**, there are no further actions needed.

Dart allows you to write `if` statements directly inside a widget list:

```dart
if (errand.status == ErrandStatus.open)
  ElevatedButton(
    onPressed: () {},
    child: const Text('Accept Errand'),
  ),
```

If the condition evaluates to `true`, Flutter includes the widget. If `false`, Flutter omits it entirely.

---

## Step 1 — Update the Detail Page Layout

Open `lib/pages/errand_detail_page.dart`.

Replace the `build()` method with the complete layout:

```dart
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Errand Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Title
            Text(
              errand.title,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12.0),

            // 2. Reward
            Text(
              'Reward: ₹${errand.reward}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12.0),

            // 3. Status Indicator
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                Chip(
                  label: Text(
                    errand.status.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),

            // 4. Description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6.0),
            Text(
              errand.description,
              style: const TextStyle(fontSize: 16.0, height: 1.4),
            ),

            // 5. Spacer pushes action buttons to the bottom of the screen
            const Spacer(),

            // 6. Action Button: Accept Errand (Only visible if open)
            if (errand.status == ErrandStatus.open)
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () {
                    // We will wire state changes in Step 09
                    print('Accept pressed');
                  },
                  child: const Text(
                    'Accept Errand',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),

            // 7. Action Button: Complete Errand (Only visible if accepted and mine)
            if (errand.status == ErrandStatus.accepted && errand.isMine)
              SizedBox(
                width: double.infinity,
                height: 48.0,
                child: ElevatedButton(
                  onPressed: () {
                    // We will wire state changes in Step 09
                    print('Complete pressed');
                  },
                  child: const Text(
                    'Complete Errand',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
```

### What this code means
* `Padding(padding: EdgeInsets.all(20.0))`: Provides uniform spacing so content doesn't press against phone edges.
* `Chip`: A rounded Material pill widget. We format `errand.status.name.toUpperCase()` to display `"OPEN"`.
* `const Spacer()`: An expanding empty space that takes all leftover vertical room, pinning the buttons neatly to the bottom of the screen.
* `SizedBox(width: double.infinity, height: 48.0)`: Stretches the button across the entire width of the display for comfortable thumb tapping.
* **Collection `if`**: Because our sample errands currently have `status == ErrandStatus.open`, only the **Accept Errand** button is drawn.

---

## Run the App

Save `lib/pages/errand_detail_page.dart` and Hot Reload (`r`).

Tap any errand from the **Open** tab.

---

## What You Should See

* Large bold title at the top.
* Purple reward text: **Reward: ₹50**.
* A status chip reading **OPEN**.
* A Description header with the full instructions.
* A full-width purple **Accept Errand** button pinned to the bottom of the screen.
* The "Complete Errand" button is not visible because the task is not accepted yet.

---

## What Just Happened?

You constructed an adaptive screen:
* The layout uses `Spacer` to create a clean, responsive mobile interface.
* Dart's collection `if` automatically inspected the data model and displayed only the relevant button for this task's status.

In the next step, we will make these buttons actually update the data and rebuild the screen.

---

## Common Mistakes

### Wrapping collection `if` in curly braces
* **Error**: `Expected an element, but got a block.`
* **Fix**: Inside a widget list, write `if (condition) Widget()` directly without wrapping the widget in `{ ... }`.

### Buttons floating in the middle of the screen
* **Cause**: Missing `const Spacer()`.
* **Fix**: Ensure `const Spacer()` is placed right before your action buttons in the `Column`.

---

## Checkpoint

You can continue to Step 09 when:

- [ ] `lib/pages/errand_detail_page.dart` has zero errors.
- [ ] Tapping an errand shows its full title, reward, status chip, and description.
- [ ] The "Accept Errand" button appears pinned to the bottom.
- [ ] Tapping the button prints "Accept pressed" to your console.

---

## What You Learned

* How to use `Spacer` to position action controls at the bottom of a view.
* How to use `Chip` for status indicators.
* How to use Dart collection `if` to display widgets conditionally.

Next: [Step 09 — Add Errand Actions](09-add-errand-actions.md)
