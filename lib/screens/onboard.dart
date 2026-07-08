import 'package:flutter/material.dart';
import 'package:quiz_app/utils/color.dart';
import 'package:quiz_app/screens/home.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/onboard.png", height: 250, width: 300, fit: BoxFit.cover),
            Text(
              'Welcome to the Quiz App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: MyColors.secondaryColor,
              ),
            ),
            Text(
              'Test your knowledge with fun quizzes!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: MyColors.textColor,
              ),
            ),


            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the next screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.secondaryColor,
              ),
              child: Text('Get Started', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
