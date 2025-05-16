import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late IO.Socket socket;
  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchInitialImage();
    initSocket();
  }

  void initSocket() {
    socket = IO.io('http://192.168.1.112:3000', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.on('connect', (_) {
      print('✅ Connected to socket server');
    });

    socket.on('new_image', (data) {
      print('📸 New image received: $data');
      setState(() {
        imageUrl = data['url'];
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('📸 New image received!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    });

    socket.on('disconnect', (_) {
      print('🔌 Disconnected from socket');
    });
  }

  Future<void> fetchInitialImage() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.112:3000/api/images'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          setState(() {
            imageUrl = data[0]['url'];
          });
        }
      } else {
        print('❌ Failed to fetch image: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error: $e');
    }
  }

  Future<void> captureImage() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.100/capture'),
      );

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('📷 Capture command sent to ESP32-CAM!'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '❌ Failed to capture. Status: ${response.statusCode}',
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Image Upload'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black87,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child:
                  imageUrl.isEmpty
                      ? const CircularProgressIndicator()
                      : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) => const Text(
                                '⚠️ Failed to load image',
                                style: TextStyle(color: Colors.white),
                              ),
                        ),
                      ),
            ),
          ),
          if (imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FullscreenImagePage(url: imageUrl),
                        ),
                      );
                    },
                    icon: const Icon(Icons.fullscreen),
                    label: const Text('View Fullscreen'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: captureImage,
                    icon: const Icon(Icons.camera),
                    label: const Text('Capture'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: fetchInitialImage,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh Image'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class FullscreenImagePage extends StatelessWidget {
  final String url;
  const FullscreenImagePage({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Full Image View'),
      ),
      body: Center(child: InteractiveViewer(child: Image.network(url))),
    );
  }
}
