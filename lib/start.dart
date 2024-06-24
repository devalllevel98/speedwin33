import 'package:flutter/material.dart';
import 'package:blinkgameno/circular_game.dart'; // Make sure to provide the correct path to circular_game.dart
import 'package:random_color/random_color.dart';

class InstructionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'How to Play',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to Circular Tapping Game! The objective is simple: tap the button when the circular icon aligns perfectly with the indicated position. Each correct tap earns you points. The game concludes after completing 10 rounds.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20),
              Text(
                'Instructions:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                '1. Tap the "Start Game" button below to begin.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                '2. Watch as the circular icon rotates around the screen.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                '3. When the circular icon reaches the designated position, tap the "Stop" button at the right time.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                '4. Each correct tap increases your score. ',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CircularGame()),
                  );
                },
                child: Text('Start Game'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
