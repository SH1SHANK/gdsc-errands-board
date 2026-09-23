// models/errand.dart
// Defines the data structure for an errand in the Errands Board app.

/// Represents the current progress of an errand.
enum ErrandStatus { open, accepted, done }

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
