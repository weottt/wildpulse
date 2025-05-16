import 'package:flutter/material.dart';
import 'admin_login_page.dart'; // Adjust path if needed

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // Logo (replace with your asset if needed)
                Center(
                  child: Image.asset(
                    'assets/wildpulse.png', // make sure this path is correct and included in pubspec.yaml
                    height: 120,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 40),

                // Welcome Text
                const Text(
                  'Welcome to',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),

                const Text(
                  'WILD PULSE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Monitoring Nature with Intelligence.',
                  style: TextStyle(color: Colors.grey[300], fontSize: 14),
                ),

                const Spacer(flex: 3),
              ],
            ),

            // Page indicators & Enter button
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Page indicators
                    Row(
                      children: [
                        _Dot(active: true),
                        SizedBox(width: 6),
                        _Dot(),
                        SizedBox(width: 6),
                        _Dot(),
                      ],
                    ),

                    // Enter button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminLoginPage(),
                          ),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        elevation: 6,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            "Enter",
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.greenAccent[400],
                            child: const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final bool active;

  const _Dot({this.active = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? Colors.greenAccent[400] : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
