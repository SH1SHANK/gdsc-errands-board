# Step 06 — Add the Tabs

## What We Are Building

In this step, you will organize the Errands Board into three tabs: **Open**, **Mine**, and **Done**. You will learn how to filter a single master list into different views and display clean empty-state messages when a tab has no tasks.

---

## What You Will Learn

* How `DefaultTabController`, `TabBar`, and `TabBarView` create a tabbed interface
* How Dart's `.where()` method filters lists based on conditions
* Why tabs are different views of the **same list in memory**, not separate lists
* How to gracefully handle empty lists with fallback messages

---

## Starting Point

You should have `lib/pages/errands_board_page.dart` rendering your sample errands using `ErrandCard`.

---

## Filtering Lists in Dart with `.where()`

Dart collections have a built-in method called `.where()`. It loops through a list, tests each item against a condition, and keeps only the items that return `true`.

```dart
final openErrands = errands
    .where((errand) => errand.status == ErrandStatus.open)
    .toList();
```

Let's read this:
1. Examine each `errand` in the master `errands` list.
2. Check if `errand.status == ErrandStatus.open`.
3. If true, keep it. If false, omit it.
4. `.toList()` packages the matching items into a new list.

We filter the list three ways:
* **Open Tab**: `errand.status == ErrandStatus.open`
* **Mine Tab**: `errand.isMine` (errands you posted or accepted)
* **Done Tab**: `errand.status == ErrandStatus.done`

---

## Step 1 — Add the `_buildErrandList` Helper Method

Open `lib/pages/errands_board_page.dart`.

Inside `_ErrandsBoardPageState`, directly above the `build` method, add this helper:

```dart
  // Helper method to build a list or an empty-state message
  Widget _buildErrandList(List<Errand> filteredErrands, String emptyMessage) {
    if (filteredErrands.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: const TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredErrands.length,
      itemBuilder: (context, index) {
        final errand = filteredErrands[index];
        return ErrandCard(
          errand: errand,
          onTap: () {
            print('Tapped on: ${errand.title}');
          },
        );
      },
    );
  }
```

### What this helper does
Instead of copying `ListView.builder` three times, this helper checks if `filteredErrands.isEmpty`:
* If empty, it renders centered grey text displaying `emptyMessage`.
* If it contains items, it returns the scrollable `ListView.builder`.

---

## Step 2 — Update the `build()` Method with `DefaultTabController`

Replace the `build()` method in `lib/pages/errands_board_page.dart` with:

```dart
  @override
  Widget build(BuildContext context) {
    // 1. Filter open errands
    final openErrands = errands
        .where((errand) => errand.status == ErrandStatus.open)
        .toList();

    // 2. Filter user's errands (either posted by user or accepted by user)
    final myErrands = errands.where((errand) => errand.isMine).toList();

    // 3. Filter completed errands
    final doneErrands = errands
        .where((errand) => errand.status == ErrandStatus.done)
        .toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Errands Board'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Open'),
              Tab(text: 'Mine'),
              Tab(text: 'Done'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildErrandList(openErrands, 'No open errands yet.'),
            _buildErrandList(
              myErrands,
              "You haven't posted or accepted any errands yet.",
            ),
            _buildErrandList(doneErrands, 'No completed errands yet.'),
          ],
        ),
      ),
    );
  }
```

### What this code means
1. **`DefaultTabController(length: 3)`**:
   Manages tab state across the subtree. `length: 3` defines the total tab count.
2. **`bottom: const TabBar(...)`**:
   Positions clickable tab headers (**Open**, **Mine**, **Done**) directly below the app bar title.
3. **`body: TabBarView(...)`**:
   The swipeable container holding the content for each tab. The order of widgets in `children` matches the order in `TabBar` (Index 0 is Open, 1 is Mine, 2 is Done).

---

## Run the App

Save `lib/pages/errands_board_page.dart` and Hot Reload (`r`).

---

## What You Should See

* Three tabs appear directly below the app bar title: **Open**, **Mine**, and **Done**.
* **Open Tab**: Displays the 3 sample campus errands.
* Tap **Mine**: Displays *"You haven't posted or accepted any errands yet."*.
* Tap **Done**: Displays *"No completed errands yet."*.
* You can swipe horizontally between tabs.

---

## What Just Happened?

You implemented dynamic data views without duplicating data:
* `errands` remains the **single source of truth** in memory.
* Every time the screen renders, it filters that single list into three slices.
* As an errand's status changes in later steps, it will automatically shift into the correct tab.

---

## Common Mistakes

### "Controller's length property (3) does not match the number of tabs (2)"
* **Cause**: Mismatch between `length` in `DefaultTabController` and the number of `Tab` widgets.
* **Fix**: Ensure `length: 3` matches both the 3 `Tab` headers and the 3 children in `TabBarView`.

### "A value of type 'Iterable<Errand>' can't be assigned to 'List<Errand>'"
* **Cause**: Omitting `.toList()` after `.where(...)`.
* **Fix**: `.where(...)` returns an `Iterable`. Always append `.toList()` to convert it back into a concrete `List`.

---

## Checkpoint

You can continue to Step 07 when:

- [ ] Three tabs (**Open**, **Mine**, **Done**) are visible in the AppBar.
- [ ] Swiping and tapping switches between tabs.
- [ ] The Open tab shows all 3 sample errands.
- [ ] The Mine and Done tabs show their respective empty-state messages.

---

## What You Learned

* How `DefaultTabController`, `TabBar`, and `TabBarView` coordinate tabs.
* How to filter collections with `.where()` and `.toList()`.
* How to present fallback messages for empty data lists.
* Why keeping a single source of truth prevents data synchronization bugs.

Next: [Step 07 — Add Navigation](07-add-navigation.md)
