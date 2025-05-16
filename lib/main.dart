import 'package:flutter/material.dart';
import 'package:wildpulse_prototype_app/pages/homepage.dart';
import 'welcome_page.dart';
import 'admin_login_page.dart';
import 'pages/notification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return _createRoute(const WelcomePage());
          case '/admin':
            return _createRoute(
              const AdminLoginPage(),
            ); // Fixed: admin route to AdminLoginPage
          case '/home':
            return _createRoute(
              const HomePage(),
            ); // Added /home route for after login
          case '/notification':
            return _createRoute(
              const NotificationPage(),
            ); // Assuming you have this page
          default:
            return null;
        }
      },
    );
  }

  // Smooth fade transition for all routes
  PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

class WebSocketPage extends StatelessWidget {
  final WebSocketChannel channel = IOWebSocketChannel.connect(
    'ws:// 192.168.22.85:3000', // Replace with your actual IP and port
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Image Notifier')),
      body: StreamBuilder(
        stream: channel.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data.toString();
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "📷 New image received!",
                    style: TextStyle(fontSize: 20),
                  ),
                  if (data.startsWith('http')) Image.network(data),
                  const SizedBox(height: 10),
                  Text(data, style: TextStyle(fontSize: 12)),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Waiting for images...'));
          }
        },
      ),
    );
  }
}
