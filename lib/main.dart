import 'package:flutter/material.dart';
import 'screens/aboutus_screen.dart';
import 'screens/login_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Code Shield',
      theme: ThemeData(
        fontFamily: 'Pixelify',
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
          brightness: Brightness.dark,
        ),
      ),
      

      home: const MainNav(),
    );
  }
}

class MainNav extends StatelessWidget {
  const MainNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // Background Image
          SizedBox.expand(
            child: Image.asset(
              "assets/images/CodeShieldBackground.png",
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Center(
                    child: Image.asset(
                      "assets/images/CodeShieldTitle.png",
                      width: 800,
                    ),
                  ),

                  const SizedBox(height: 80),

                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            TextButton(
                              onPressed: () {},
                              child: const Text("PLAY", 
                                style: 
                                TextStyle(fontSize: 30, color: Colors.white),
                                ),
                            ),

                            const SizedBox(height: 20),

                            TextButton(
                              onPressed: () {},
                              child: const Text("HOW TO PLAY",
                                  style: TextStyle(fontSize: 30, color: Colors.white)),
                            ),

                            const SizedBox(height: 20),

                            TextButton(
                              onPressed: () {},
                              child: const Text("ENEMY DESCRIPTION",
                                  style: TextStyle(fontSize: 30, color: Colors.white)),
                            ),

                            const SizedBox(height: 20),

                            TextButton(
                              onPressed: () {},
                              child: const Text("ABOUT",
                                  style: TextStyle(fontSize: 30, color: Colors.white)),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const SizedBox(height: 125),
                            
                            Row(
                              children: [
                            const Text("GUEST",
                                    style: TextStyle(fontSize: 30)),
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {},
                                    )
                                  ],
                                ),

                            const SizedBox(height: 20),

                            const Text(
                              "HIGHSCORE: ",
                              style: TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}