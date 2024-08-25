import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:encore2_gamesheet/constants/box_colors.dart';
import 'package:encore2_gamesheet/constants/card_points.dart';
import 'package:encore2_gamesheet/constants/row_bonus.dart';
import 'package:encore2_gamesheet/constants/settings.dart';
import 'package:encore2_gamesheet/custom_icons_icons.dart';
import 'package:encore2_gamesheet/models/box_color.dart';
import 'package:encore2_gamesheet/models/game_state.dart';
import 'package:encore2_gamesheet/pages/settings_page.dart';
import 'package:encore2_gamesheet/painters/cross_painter.dart';
import 'package:encore2_gamesheet/painters/slash_painter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/field_letters.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  // UI Settings
  var showScore = true;
  var darkMode = true;
  var highscore = true;
  var sounds = false;

  // State
  var gameState = GameState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode
          ? const Color.fromARGB(255, 30, 30, 30)
          : const Color.fromARGB(255, 240, 240, 240),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            showLeftColumn(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                showHeadRow(),
                showPlayField(),
                showScoreRow(),
              ],
            ),
            showRightLetters(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Column(
                      children: [
                        Column(
                          children: [
                            for (int i = 0; i < gameState.maxBonus; i = i + 2)
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 4, 0, 0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      showBonusField(i),
                                      showBonusField(i + 1)
                                    ]),
                              ),
                          ],
                        ),
                        Container(height: 10),
                        Column(
                          children: [
                            for (int i = 0; i < gameState.maxHearts; i = i + 2)
                              Container(
                                margin: const EdgeInsets.fromLTRB(10, 4, 0, 0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      showHeartField(i),
                                      if (i + 1 < gameState.maxHearts)
                                        showHeartField(i + 1)
                                    ]),
                              ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        showClosedScoreRow(BoxColors.greenBox),
                        showClosedScoreRow(BoxColors.yellowBox),
                        showClosedScoreRow(BoxColors.blueBox),
                        showClosedScoreRow(BoxColors.pinkBox),
                        showClosedScoreRow(BoxColors.orangeBox),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [for (var i = 0; i < 5; i++) showBoxField(i)],
                    ),
                    Row(
                      children: [for (var i = 5; i < 9; i++) showBoxField(i)],
                    )
                  ],
                ),
                Row(
                  children: [showScoreBoard()],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget showScoreBoard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 1),
      child: Row(
        children: [
          showScoreBoardRow(null, "", "=", gameState.getTotalPoints(), true),
          showSettingsButton(),
        ],
      ),
    );
  }

  Widget showScoreBoardRow(IconData? iconPrefix, textPrefix, text, number,
      [large = false]) {
    var children = [];
    if (iconPrefix != null) {
      children.add(Container(
        margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Icon(iconPrefix,
            color: darkMode ? Colors.white : Colors.black, size: 20),
      ));
    }

    if (textPrefix != "") {
      children.add(Container(
        margin: EdgeInsets.fromLTRB(children.isEmpty ? 10 : 5, 0, 0, 0),
        child: Text(
          textPrefix,
          style: TextStyle(
            color: darkMode ? Colors.white : Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 11,
          ),
        ),
      ));
    }

    var optionalElements = [];
    if (children.isNotEmpty) {
      optionalElements.add(SizedBox(
        width: 70,
        height: 32,
        child: Row(
          children: [
            ...children,
          ],
        ),
      ));
    } else {
      optionalElements.add(const SizedBox(width: 0, height: 20));
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
      child: Column(
        children: [
          ...optionalElements,
          Container(
            width: large ? 90 : 55,
            height: large ? 28 : 22,
            decoration: BoxDecoration(
              border: Border.all(
                  color: darkMode ? Colors.white : Colors.black,
                  width: large ? 2 : 1),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: darkMode
                  ? const Color.fromARGB(225, 30, 30, 30)
                  : const Color.fromARGB(225, 255, 255, 255),
            ),
            child: Row(children: [
              Container(
                margin: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                width: 12,
                child: Text(
                  text,
                  style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: large ? 14 : 11,
                  ),
                ),
              ),
              SizedBox(
                width: large ? 55 : 25,
                child: Text(
                  showScore ? number.toString() : "?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: darkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: large ? 16 : 14,
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget showSettingsButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
      width: 35,
      height: 22,
      child: IconButton(
        icon: Icon(
          Icons.settings,
          color: darkMode ? Colors.white : Colors.black,
        ),
        onPressed: () {
          Navigator.push<List<String>>(
            context,
            MaterialPageRoute(
                builder: (context) => SettingsPage(key: GlobalKey())),
          ).then((value) => {
                if (value!.isNotEmpty && value[0] != "resume")
                  {
                    setState(() {
                      gameState.singlePlayerMode =
                          value[1] == "single" ? true : false;
                      resetGame(value[0]);
                    }),
                  },

                // Always load the new settings (can be changed without starting a new game)
                loadSettings(),
              });
        },
      ),
    );
  }

  Widget showClosedScoreRow(BoxColor color) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 1, 0, 0),
      child: Row(
        children: [
          showColoredBox(color,
              checked: gameState.isBoxColorManualClosed(color),
              circle: gameState.isBoxColorClosed(color, true),
              text: "5", onTap: () {
            setState(() {
              if (gameState.singlePlayerMode) return;

              playClickSound();
              if (gameState.isBoxColorManualClosed(color)) {
                gameState.manualClosedColors.remove(color);
              } else {
                gameState.manualClosedColors.add(color);
              }
            });
          }),
          showColoredBox(color,
              circle: gameState.manualClosedColors.contains(color) &&
                  gameState.isBoxColorClosed(color),
              text: "3")
        ],
      ),
    );
  }

  Widget showBonusField(int bonusNr) {
    return GestureDetector(
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(
                color: darkMode ? Colors.white : Colors.black, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          child: Center(
            child: Icon(
              bonusNr < gameState.bonusUsed ? Icons.close : Icons.priority_high,
              size: 20,
              color: darkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        onTap: () {
          playClickSound();

          setState(() {
            if (bonusNr <= gameState.bonusUsed - 1) {
              gameState.bonusUsed--;
            } else {
              if (gameState.bonusUsed == gameState.maxBonus) {
                return;
              } else {
                gameState.bonusUsed++;
              }
            }
          });
        });
  }

  Widget showHeartField(int heartNr) {
    return GestureDetector(
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(
                color: darkMode ? Colors.white : Colors.black, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          child: Center(
            child: Icon(
              heartNr < gameState.heartsActivated
                  ? Icons.favorite
                  : Icons.favorite_border,
              size: 20,
              color: darkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        onTap: () {
          playClickSound();

          setState(() {
            if (heartNr <= gameState.heartsActivated - 1) {
              gameState.heartsActivated--;
            } else {
              if (gameState.heartsActivated == gameState.maxBonus) {
                return;
              } else {
                gameState.heartsActivated++;
              }
            }
          });
        });
  }

  Widget showBoxField(int boxNr) {
    return GestureDetector(
        child: Stack(children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(
                  color: darkMode ? Colors.white : Colors.black, width: 1),
              borderRadius: const BorderRadius.all(Radius.circular(50)),
            ),
            child: Center(
              child: Icon(
                boxNr < gameState.getActivatedBoxes()
                    ? CustomIcons.diceD6
                    : null,
                size: 20,
                color: darkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          if (boxNr < gameState.boxesUsed)
            CustomPaint(
                size: const Size(30, 30),
                painter: CrossPainter(
                    color: darkMode ? Colors.white : Colors.black)),
        ]),
        onTap: () {
          playClickSound();

          setState(() {
            if (boxNr <= gameState.boxesUsed - 1) {
              gameState.boxesUsed--;
            } else {
              if (gameState.boxesUsed == gameState.maxBoxes ||
                  gameState.boxesUsed == gameState.getActivatedBoxes()) {
                return;
              } else {
                gameState.boxesUsed++;
              }
            }
          });
        });
  }

  Widget showLeftColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < RowBonus.bonusIcons.length; i++)
          Row(children: [
            showTextBox(
              "5",
              false,
              gameState.isRowFinished(i),
              false,
            ),
            showIconBox(
                RowBonus.bonusIcons[i],
                false,
                gameState.isRowFinished(i, true),
                gameState.partlyClosedColumns.contains(i),
                gameState.isRowManualClosed(i)),
          ]),
      ],
    );
  }

  Widget showRightLetters() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < FieldLetters.rowletters.length; i++)
          showTextBox(
              FieldLetters.rowletters[i],
              false,
              !gameState.isRowManualClosed(i) && gameState.isRowFinished(i),
              gameState.partlyClosedColumns.contains(i),
              gameState.isRowManualClosed(i), () {
            setState(() {
              if (!gameState.singlePlayerMode && gameState.isRowFinished(i)) {
                return;
              }

              playClickSound();

              if (gameState.singlePlayerMode) {
                if (!gameState.partlyClosedColumns.contains(i)) {
                  gameState.partlyClosedColumns.add(i);
                } else if (!gameState.isRowManualClosed(i)) {
                  gameState.closeRow(i);

                  if (gameState.isGameFinished()) {
                    gameFinished();
                  }
                } else {
                  gameState.partlyClosedColumns.remove(i);
                  gameState.reopenRow(i);
                }
              } else {
                if (gameState.isRowManualClosed(i)) {
                  gameState.reopenRow(i);
                } else if (!gameState.singlePlayerMode) {
                  gameState.closeRow(i);
                }
              }
            });
          })
      ],
    );
  }

  Widget showHeadRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < FieldLetters.columnLetters.length; i++)
          showTextBox(
              FieldLetters.columnLetters[i],
              FieldLetters.columnLetters[i] == "H",
              gameState.isColumnFinished(i, true),
              gameState.partlyClosedColumns.contains(i),
              gameState.isColumnManualClosed(i), () {
            setState(() {
              if (!gameState.singlePlayerMode &&
                  gameState.isColumnFinished(i)) {
                return;
              }

              playClickSound();

              if (gameState.singlePlayerMode) {
                if (!gameState.partlyClosedColumns.contains(i)) {
                  gameState.partlyClosedColumns.add(i);
                } else if (!gameState.isColumnManualClosed(i)) {
                  gameState.closeColumn(i);

                  if (gameState.isGameFinished()) {
                    gameFinished();
                  }
                } else {
                  gameState.partlyClosedColumns.remove(i);
                  gameState.reopenColumn(i);
                }
              } else {
                if (gameState.isColumnManualClosed(i)) {
                  gameState.reopenColumn(i);
                } else if (!gameState.singlePlayerMode) {
                  gameState.closeColumn(i);
                }
              }
            });
          })
      ],
    );
  }

  Widget showPlayField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (var i = 0; i < gameState.card.length; i++)
          Row(
            children: [
              for (var j = 0; j < gameState.card[i].length; j++)
                showColoredBox(gameState.card[i][j].color,
                    highlight: j == 7,
                    showStar: gameState.card[i][j].star,
                    showBox: gameState.card[i][j].box,
                    checked: gameState.card[i][j].checked, onTap: () {
                  setState(() {
                    // Flip boolean
                    gameState.flip(i, j);

                    playClickSound();

                    if (gameState.isGameFinished()) {
                      gameFinished();
                    }
                  });
                }),
            ],
          ),
      ],
    );
  }

  Widget showScoreRow() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          children: [
            for (var i = 0; i < CardPoints.first.length; i++)
              Stack(children: [
                showTextBox(
                    // Show always the first row in single player mode
                    (gameState.isColumnManualClosed(i) &&
                                !gameState.singlePlayerMode
                            ? CardPoints.second[i]
                            : CardPoints.first[i])
                        .toString(),
                    false,
                    gameState.isColumnFinished(i)),
              ]),
          ],
        ),
        Positioned(
          top: -15,
          right: -15,
          child: Row(
            children: [
              for (var i = 0; i < CardPoints.first.length; i++)
                Container(
                  margin: const EdgeInsets.fromLTRB(1.5, 1.5, 1.5, 1.5),
                  width: getDefaultBoxSize() - 3,
                  height: getDefaultBoxSize() - 3,
                  child: gameState.isColumnFinished(i)
                      ? Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                              const Icon(
                                Icons.favorite,
                                color: Colors.white,
                                size: 25,
                              ),
                              Text(
                                gameState.heartsBonusPoints
                                    .firstWhere(
                                        (element) => element.columnNr == i)
                                    .bonusPoints
                                    .toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ])
                      : null,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget showBox(Widget itemBox,
      [bool highlight = false,
      circle = false,
      slashed = false,
      checked = false,
      onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(1.5, 1.5, 1.5, 1.5),
        width: getDefaultBoxSize() - 3,
        height: getDefaultBoxSize() - 3,
        decoration: BoxDecoration(
          border: Border.all(
              color: darkMode ? Colors.white : Colors.black, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(5)),
          color: darkMode
              ? const Color.fromARGB(225, 30, 30, 30)
              : const Color.fromARGB(225, 255, 255, 255),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              circle
                  ? const Icon(
                      Icons.circle_outlined,
                      size: 30,
                      color:
                          Colors.red, //darkMode ? Colors.white : Colors.black,
                    )
                  : const Text(""),
              itemBox,
              checked || slashed
                  ? CustomPaint(
                      size: Size(
                          getDefaultBoxSize() - 3, getDefaultBoxSize() - 3),
                      painter: checked
                          ? CrossPainter(
                              color: darkMode ? Colors.white : Colors.black)
                          : SlashPainter(
                              color: darkMode ? Colors.white : Colors.black),
                    )
                  : const Text(""),
            ],
          ),
        ),
      ),
    );
  }

  Widget showTextBox(String text,
      [bool highlight = false,
      circle = false,
      slashed = false,
      checked = false,
      onTap]) {
    var textBox = Text(
      text,
      style: TextStyle(
        color: highlight
            ? Colors.red
            : darkMode
                ? Colors.white
                : Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: circle ? 16 : 20,
      ),
    );

    return showBox(textBox, highlight, circle, slashed, checked, onTap);
  }

  Widget showIconBox(IconData icon,
      [bool highlight = false,
      circle = false,
      slashed = false,
      checked = false,
      onTap]) {
    var iconBox = Icon(
      icon,
      color: highlight
          ? Colors.red
          : darkMode
              ? Colors.white
              : Colors.black,
      size: circle ? 16 : 20,
    );

    return showBox(iconBox, highlight, circle, slashed, checked, onTap);
  }

  Widget showColoredBox(BoxColor color,
      {bool highlight = false,
      bool showStar = false,
      bool showBox = false,
      bool checked = false,
      bool circle = false,
      String text = "",
      onTap}) {
    Widget content = Opacity(
      opacity: 0.3,
      child: Text(
        text,
        style: TextStyle(
          color: darkMode && !circle ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: circle ? 14 : 20,
        ),
      ),
    );

    if (showStar) {
      content = Opacity(
        opacity: 0.8,
        child: Icon(
          Icons.star,
          color: color.colorText,
        ),
      );
    }

    if (showBox) {
      content = Opacity(
        opacity: 0.8,
        child: Icon(
          CustomIcons.diceD6,
          color: color.colorText,
        ),
      );
    }

    if (checked) {
      var opWidget = Opacity(
        opacity: 0.8,
        child: CustomPaint(
          size: Size(getDefaultBoxSize() - 3, getDefaultBoxSize() - 3),
          painter: CrossPainter(color: Colors.black),
        ),
      );
      if (showStar || showBox) {
        content =
            Stack(alignment: Alignment.center, children: [content, opWidget]);
      } else {
        content = opWidget;
      }
    }

    if (circle) {
      content = Stack(alignment: Alignment.center, children: [
        const Icon(
          Icons.circle_outlined,
          color: Colors.black,
        ),
        content
      ]);
    }

    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: getDefaultBoxSize(),
          height: getDefaultBoxSize(),
          decoration: BoxDecoration(
            border: Border.all(
                color: highlight ? Colors.white : Colors.black, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            color: darkMode ? color.dmColor : color.color,
          ),
          child: Center(
            child: content,
          ),
        ));
  }

  double getDefaultBoxSize() {
    var maxWidth = (MediaQuery.of(context).size.width - 200) / 18;
    var maxHeight = MediaQuery.of(context).size.height / 11;
    return maxHeight > maxWidth ? maxWidth : maxHeight;
  }

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      showScore = prefs.getBool(Settings.showCurrentPoints) ?? true;
      darkMode = prefs.getBool(Settings.darkMode) ?? true;
      highscore = prefs.getBool(Settings.highscore) ?? true;
      sounds = prefs.getBool(Settings.sounds) ?? false;

      // currentHighscore = prefs.getInt(CURRENT_HIGHSCORE);
    });
  }

  void gameFinished() {
    playWinSound();

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Finished!'),
        content: Text(
            'You finished the game with ${gameState.getTotalPoints()} points!'),
        actions: <Widget>[
          TextButton(
            onPressed: () => {Navigator.pop(context, "Cancel")},
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                {resetGame(gameState.level), Navigator.pop(context, "Ok")},
            child: const Text('Start new game'),
          ),
        ],
      ),
    );
  }

  void resetGame(String lvl) {
    setState(() {
      gameState.reset(lvl);
    });
  }

  void playWinSound() {
    if (!sounds) return;
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/audios/win.wav"),
      autoStart: true,
      showNotification: false,
    );
  }

  void playClickSound() {
    if (!sounds) return;
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/audios/click.wav"),
      autoStart: true,
      showNotification: false,
    );
  }
}
