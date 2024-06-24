import 'dart:async';
import 'package:blinkgameno/circular_game.dart';
import 'package:blinkgameno/start.dart';
import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';

class WinnerScreen extends StatelessWidget {
  final String winner;

  WinnerScreen(this.winner);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Victory'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // Replace with your actual image path
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$winner has won!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CircularGame()),
                  );
                },
                child: Text('Play Again', style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255))),
              ),
            SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InstructionScreen()),
                  );
                },
                child: Text('Back Instruction', style: TextStyle(fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 255, 255, 255))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
