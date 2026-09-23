# Step 01 — Create the Project

## What We Are Building

In this step, you will generate a new Flutter project using the terminal, explore the generated folder structure, and run the default starter app on your device or emulator.

---

## What You Will Learn

* How to generate a new Flutter project using `flutter create`
* What the `lib/` directory is and why all your Dart code goes there
* What `pubspec.yaml` does
* How to run your app on a device or emulator

---

## Starting Point

Before you start, open your terminal and verify that Flutter is accessible:

```bash
flutter --version
```

You should see Flutter 3.47.5 and Dart 3.13.4 (or similar stable versions).

---

## Step 1 — Run the Creation Command

Navigate to the folder on your computer where you want to keep your project, and run:

```bash
flutter create errands_app
```

Here is what each part of this command does:
* `flutter`: The Flutter command-line tool.
* `create`: Tells Flutter to generate a complete starter project.
* `errands_app`: The name of the new project folder. Flutter project names must be lowercase letters with underscores.

Once the command finishes, change into your new project directory:

```bash
cd errands_app
```

---

## Step 2 — Open the Project in Your Editor

Open the project folder in Visual Studio Code (or Android Studio).

From the terminal inside `errands_app`, you can type:

```bash
code .
```

Look at the left sidebar file explorer.

---

## Step 3 — Understand the Key Folders

Flutter generates several folders, but as an application developer, you only need to focus on two items:

1. **`lib/`**:
   This is short for "library". **Every Dart file you write will live inside this folder.** Flutter puts the initial entry file, `main.dart`, here.
2. **`pubspec.yaml`**:
   The configuration file for your Flutter project. It lists your app's name, version, supported SDKs, and any fonts or packages.

The other folders (`android/`, `ios/`, `macos/`, `web/`) are platform wrappers. Flutter manages them automatically.

---

## Run the App

Start your Android emulator, iOS simulator, or open Google Chrome. Then run:

```bash
flutter run
```

If multiple devices are connected, select your target from the prompt, or specify it directly:

```bash
flutter run -d macos    # macOS desktop
flutter run -d chrome   # Chrome browser
```

---

## What You Should See

After compiling, the default Flutter counter app will open:
* A top app bar titled "Flutter Demo Home Page"
* Text saying "You have pushed the button this many times:"
* A number counter showing "0"
* A circular plus button in the bottom right

Tapping the plus button increments the number.

---

## What Just Happened?

Flutter compiled `lib/main.dart` and launched it on your device. You now have a working local development environment ready for code changes.

---

## Common Mistakes

### "flutter: command not found"
* **Cause**: Flutter is not in your terminal's system PATH.
* **Fix**: Follow the workshop environment guide to add Flutter to your shell profile (`~/.zshrc` or `~/.bashrc`), then restart the terminal.

### "No connected devices found"
* **Cause**: No device or emulator is currently running.
* **Fix**: Launch an Android Virtual Device from Android Studio, start the iOS Simulator, or pass `-d chrome` to run in your browser.

---

## Checkpoint

You can continue to Step 02 when:

- [ ] `flutter create errands_app` completed successfully.
- [ ] You have opened `errands_app` in your editor.
- [ ] You can locate `lib/main.dart` and `pubspec.yaml`.
- [ ] The default counter app runs on your screen.

---

## What You Learned

* How to create a Flutter project using `flutter create`.
* That all your application code lives in `lib/`.
* That `pubspec.yaml` controls project configuration.
* How to launch the app using `flutter run`.

Next: [Step 02 — Build the App Shell](02-build-the-app-shell.md)
