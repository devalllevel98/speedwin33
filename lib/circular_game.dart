import 'dart:async';
import 'package:blinkgameno/clipboard.dart';
import 'package:blinkgameno/win.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as vector;



class CircularGame extends StatefulWidget {
  @override
  _CircularGameState createState() => _CircularGameState();
}

class _CircularGameState extends State<CircularGame>
    with SingleTickerProviderStateMixin {
  late Color player1Color, player2Color, circularIconColor;
  late int k = 0, pKey, p1Score, p2Score, _speed, _pass;
  int roundCount = 0; // Biến đếm số lượt chơi
  Timer? timer;
  late bool playerType; // false for player1 and true for player2

  @override
  void initState() {
    super.initState();
    player1Color = RandomColor().randomColor();
    player2Color = RandomColor().randomColor();
    circularIconColor = player1Color;
    pKey = math.Random().nextInt(36) * 10;
    playerType = false;
    p1Score = 0;
    p2Score = 0;
    _speed = 80;
    _pass = 1;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            player1Panel(size),
            Expanded(
              flex: 50,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    left: 0,
                    child: ClipPath(
                      clipper: MyCustomClipper("LEFT"),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 12),
                        width: 110,
                        height: 200,
                        color: Colors.white24,
                        child: Text(
                          "$_pass",
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: getCircularWidget(),
                    ),
                  ),
                  IconButton(
                    onPressed: () {

                          if (roundCount >= 10) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WinnerScreen(p1Score > p2Score ? 'Player 1':p1Score < p2Score ? "Player 2":"Player 1 and Player 2"),
                              ),
                            );
                          }
                      print("dfededce");
                      if (timer == null) {
                        timer = Timer.periodic(
                            Duration(milliseconds: _speed), (timer) {
                          setState(() {
                            k += 10;
                          });
                        });
                      }
                    },
                    icon: Icon(
                      Icons.play_arrow,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: ClipPath(
                      clipper: MyCustomClipper("RIGHT"),
                      child: Container(
                        width: 110,
                        height: 200,
                        color: Colors.white24,
                        alignment: Alignment.centerRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_speed < 140) {
                                    _speed += 10;
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.add,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "$_speed",
                              style: TextStyle(color: Colors.white),
                            ),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (20 < _speed) {
                                    _speed -= 10;
                                  }
                                });
                              },
                              
                              icon: Icon(
                                Icons.remove,
                                size: 36,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            player2Panel(size),
          ],
        ),
      ),
    );
  }

  Expanded player2Panel(Size size) {
    return Expanded(
      flex: 25,
      child: Container(
        width: size.width,
        child: Card(
          margin: const EdgeInsets.all(8),
          color: player2Color,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 70,
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                        ),
                        trailing: Text(
                          "Player 2",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Text(
                        "SCORE",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        "$p2Score",
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:
                            playerType ? getPlayerChances() : getAllChances(),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 30,
                child: SizedBox.expand(
                  child: ElevatedButton(
                    onPressed: () {
                      if (playerType && pKey == k % 360) {
                        setState(() {
                          print(
                              "perfect2 value of pKey $pKey and value of k ${k % 360}");
                          p2Score += 10;
                          playerType = !playerType;
                          circularIconColor = player1Color;
                          pKey = math.Random().nextInt(36) * 10;
                          k = 0;
                          timer?.cancel();
                          timer = null;
                          _pass += 1;
                          // Check if the game has completed 10 rounds
                          roundCount++;
                          // if (roundCount >= 10) {
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => WinnerScreen(p1Score > p2Score ? 'Player 1':p1Score < p2Score ? "Player 2":"Player 1 and Player 2"),
                          //     ),
                          //   );
                          // }
                        });
                      } else {
                        print(
                            "miss player2 value of pKey $pKey and value of k ${k % 360}");
                      }
                    },
                    child:Text("STOP", style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight:FontWeight.bold),)
                    //  Icon(
                    //   Icons.close,
                    //   size: 36,
                    //   color: player2Color,
                    // ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded player1Panel(Size size) {
    return Expanded(
      flex: 25,
      child: Container(
        width: size.width,
        child: Card(
          margin: const EdgeInsets.all(8),
          color: player1Color,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 30,
                child: SizedBox.expand(
                  child: ElevatedButton(
                    onPressed: () {
                    // if (roundCount >= 10) {
                    //         Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => WinnerScreen('Player 1'),
                    //           ),
                    //         );
                    //       }
                      if (!playerType && pKey == k % 360) {
                        setState(() {
                          print(
                              "perfect1 value of pKey $pKey and value of k ${k % 360}");
                          playerType = !playerType;
                          p1Score += 10;
                          circularIconColor = player2Color;
                          pKey = math.Random().nextInt(36) * 10;
                          k = 0;
                          timer?.cancel();
                          timer = null;
                          _pass += 1;

                          // Check if the game has completed 10 rounds
                          roundCount++;

                        });
                      } else {
                        print(
                            "miss player1 value of pKey $pKey and value of k ${k % 360}");
                      }
                    },
         
                    child:Text("STOP", style: TextStyle(color: Colors.amber, fontSize: 18, fontWeight:FontWeight.bold),)

                    // Icon(
                    //   Icons.close,
                    //   size: 36,
                    //   color: player1Color,
                    // ),
                  ),
                ),
              ),
              Expanded(
                flex: 70,
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "Player 1",
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: CircleAvatar(
                            child: Icon(
                              Icons.person_2,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          "SCORE",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          "$p1Score",
                          style: TextStyle(fontSize: 22, color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              playerType ? getAllChances() : getPlayerChances(),
                        )
                      ],
                    ),
                  ),
                ),
              
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> getPlayerChances() {
    List<Widget> chanceList = [];
    int div = (k / 360).ceil();
    for (int c = 0; c <= 5; c++) {
      if (div <= c) {
        chanceList.add(Icon(
          Icons.track_changes,
          color: Colors.white,
          size: 16,
        ));
      } else {
        chanceList.add(Icon(
          Icons.close,
          color: Colors.white,
          size: 16,
        ));
      }
    }
    return chanceList;
  }

  List<Widget> getAllChances() {
    List<Widget> chanceList = [];
    for (int c = 0; c <= 5; c++) {
      chanceList.add(Icon(
        Icons.track_changes,
        color: Colors.white,
        size: 16,
      ));
    }
    return chanceList;
  }

  List<Widget> getCircularWidget() {
    List<Widget> tempWidget = [];
    double rad;
    int tempK = 0;

    if (k > 1800) {
      setState(() {
        pKey = math.Random().nextInt(36) * 10;
        k = 0;
        timer?.cancel();
        timer = null;
        playerType = !playerType;
        _pass += 1;

        // Check if the game has completed 10 rounds
        roundCount++;
        // if (roundCount >= 10) {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => WinnerScreen('Player 1'),
        //     ),
        //   );
        // }
      });
    } else {
      tempK = k % 360;
    }
    for (int i = 0; i <= 360; i += 10) {
      double d = i * 1.0;
      rad = vector.radians(d);
      tempWidget.add(Transform(
        transform: Matrix4.identity()
          ..translate(100 * math.cos(rad), 100 * math.sin(rad)),
        child: Icon(
          Icons.add_circle,
          color: playerType
              ? (tempK == i
                  ? Colors.black
                  : (pKey == i ? player2Color : Colors.white))
              : (tempK == i
                  ? Colors.black
                  : (pKey == i ? player1Color : Colors.white)),
          size: 20,
        ),
      ));
    }
    return tempWidget;
  }
}

