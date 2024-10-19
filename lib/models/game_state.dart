import 'package:encore2_gamesheet/cards/level_1.dart';
import 'package:encore2_gamesheet/models/bonus_point.dart';

import '../constants/box_colors.dart';
import '../constants/card_points.dart';
import 'box_color.dart';

class GameState {
  var card = Level1Card().getCard();
  var level = "1";

  var singlePlayerMode = false;

  var _manualClosedColumns = [];
  var _manualClosedRows = [];
  var manualClosedColors = [];

  // Gameplay variables
  var maxBonus = 6;
  var bonusUsed = 0;

  var maxHearts = 5;
  var heartsActivated = 0;
  List<BonusPoint> heartsBonusPoints = [];

  var maxBoxes = 9;
  var boxesUsed = 0;

  // Single player mode variables
  var turnCount = 0;
  var partlyClosedColumns = [];

  bool isColumnFinished(int column, [bool removeManualClosed = false]) {
    if (removeManualClosed && isColumnManualClosed(column)) return false;

    return card.every((row) => row[column].checked);
  }

  bool isColumnManualClosed(int column) {
    return _manualClosedColumns.contains(column);
  }

  bool isAllColumnsManualClosed() {
    return _manualClosedColumns.length == 15;
  }

  /// Manually close column
  void closeColumn(int column) {
    _manualClosedColumns.add(column);
  }

  /// Manually open column
  void reopenColumn(int column) {
    _manualClosedColumns.remove(column);
  }

  bool isRowFinished(int row, [bool removeManualClosed = false]) {
    if (removeManualClosed && isRowManualClosed(row)) return false;

    return card[row].every((element) => element.checked);
  }

  bool isRowManualClosed(int row) {
    return _manualClosedRows.contains(row);
  }

  /// Manually close row
  void closeRow(int row) {
    _manualClosedRows.add(row);
  }

  /// Manually open row
  void reopenRow(int row) {
    _manualClosedRows.remove(row);
  }

  /// Reset the entire game to the level given
  void reset(String lvl) {
    partlyClosedColumns = [];
    manualClosedColors = [];
    _manualClosedColumns = [];
    _manualClosedRows = [];
    heartsBonusPoints = [];

    bonusUsed = 0;
    boxesUsed = 0;
    heartsActivated = 0;

    level = lvl;
    
    // Load the card from the given level
    switch (lvl) {
      case "1":
        card = Level1Card().getCard();
        break;
    }
  }

  int _calcBonusPoints() {
    return maxBonus - bonusUsed;
  }

  int _calcStarPoints() {
    var points = card
            .expand((element) => element)
            .where((element) => element.star && !element.checked)
            .length *
        2;
    return points;
  }

  int getActivatedBoxes() {
    return card
            .expand((element) => element)
            .where((element) => element.box && element.checked)
            .length +
        1 // Default box
        +
        (isRowFinished(0, true) ? 1 : 0) // First row closed
        +
        (isRowFinished(4, true) ? 1 : 0) // 5th row closed
        +
        (isColumnFinished(7) ? 1 : 0); // H column
  }

  int _calcActivatedBoxesPoints() {
    var x = (getActivatedBoxes() - boxesUsed) * 2;
    return x;
  }

  int _calcClosedRowsPoints() {
    var points =
        card.where((row) => row.every((element) => element.checked)).length * 5;

    return points;
  }

  int _calcHeartsPoints() {
    var points = heartsBonusPoints.fold(
        0, (int previousValue, element) => previousValue + element.bonusPoints);
    return points;
  }

  bool isBoxColorManualClosed(BoxColor color) {
    return manualClosedColors.contains(color);
  }

  bool isBoxColorClosed(BoxColor color,
      [bool removeManualClosedColors = false]) {
    if (removeManualClosedColors && isBoxColorManualClosed(color)) return false;

    return card.every((row) => row
        .where((element) => element.color == color)
        .every((element) => element.checked));
  }

  int _calcClosedColorsPoints() {
    var points = 0;

    if (isBoxColorClosed(BoxColors.greenBox)) {
      points += manualClosedColors.contains(BoxColors.greenBox) ? 3 : 5;
    }
    if (isBoxColorClosed(BoxColors.yellowBox)) {
      points += manualClosedColors.contains(BoxColors.yellowBox) ? 3 : 5;
    }
    if (isBoxColorClosed(BoxColors.blueBox)) {
      points += manualClosedColors.contains(BoxColors.blueBox) ? 3 : 5;
    }
    if (isBoxColorClosed(BoxColors.pinkBox)) {
      points += manualClosedColors.contains(BoxColors.pinkBox) ? 3 : 5;
    }
    if (isBoxColorClosed(BoxColors.orangeBox)) {
      points += manualClosedColors.contains(BoxColors.orangeBox) ? 3 : 5;
    }

    return points;
  }

  int _calcClosedColumnsPoints() {
    var points = 0;

    for (int i = 0; i < CardPoints.first.length; i++) {
      if (!card.every((row) => row[i].checked)) continue;

      if (isColumnManualClosed(i) && !singlePlayerMode) {
        points += CardPoints.second[i];
      } else {
        // Use also these points in single player mode
        points += CardPoints.first[i];
      }
    }

    return points;
  }

  int getTotalPoints() {
    return _calcClosedColorsPoints() +
        _calcClosedColumnsPoints() +
        _calcClosedRowsPoints() +
        _calcHeartsPoints() +
        _calcActivatedBoxesPoints() +
        _calcBonusPoints() -
        _calcStarPoints();
  }

  bool isGameFinished() {
    if (singlePlayerMode) {
      return isAllColumnsManualClosed();
    }

    var closedCount = 0;
    if (isBoxColorClosed(BoxColors.greenBox)) closedCount++;
    if (isBoxColorClosed(BoxColors.yellowBox)) closedCount++;
    if (isBoxColorClosed(BoxColors.blueBox)) closedCount++;
    if (isBoxColorClosed(BoxColors.pinkBox)) closedCount++;
    if (isBoxColorClosed(BoxColors.orangeBox)) closedCount++;

    return closedCount >= 2;
  }

  void flip(int row, int column) {
    card[row][column].checked = !card[row][column].checked;

    if (isColumnFinished(column) && !isBonusPointsAssigned(column)) {
      setBonusPoints(column);
    }

    if (!isColumnFinished(column) && isBonusPointsAssigned(column)) {
      removeBonusPoints(column);
    }
  }

  bool isBonusPointsAssigned(int column) {
    return heartsBonusPoints
            .where((element) => element.columnNr == column)
            .length ==
        1;
  }

  void setBonusPoints(int column) {
    heartsBonusPoints.add(BonusPoint(column, heartsActivated));
  }

  void removeBonusPoints(int column) {
    heartsBonusPoints.remove(
        heartsBonusPoints.firstWhere((element) => element.columnNr == column));
  }
}
