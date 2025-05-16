import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MonitoringFeedPage extends StatefulWidget {
  const MonitoringFeedPage({super.key});

  @override
  _MonitoringFeedPageState createState() => _MonitoringFeedPageState();
}

class _MonitoringFeedPageState extends State<MonitoringFeedPage> {
  List<Map<String, String>> feedItems = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchFeedItems();
  }

  Future<void> _fetchFeedItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.22.85:3000/api/images'),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() {
          feedItems =
              data.map<Map<String, String>>((item) {
                return {
                  'image': item['url'] as String,
                  'capturedOn': item['createdAt'] as String? ?? 'Unknown time',
                };
              }).toList();
          isLoading = false;
          errorMessage = null;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch images: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch images: $e';
        isLoading = false;
      });
    }
  }

  String _formatCapturedTime(String? isoTime) {
    if (isoTime == null || isoTime.isEmpty) return 'Unknown time';
    try {
      final dateTime = DateTime.parse(isoTime).toLocal();
      return '${_formatDate(dateTime)} at ${_formatTime(dateTime)}';
    } catch (_) {
      return 'Unknown time';
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${_monthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Monitoring Feed',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Container(
            margin: const EdgeInsets.only(left: 8, right: 150),
            height: 3,
            color: Colors.lightGreenAccent,
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
              ? Center(
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.center,
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: feedItems.length,
                itemBuilder: (context, index) {
                  final item = feedItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            item['image']!,
                            width: 160,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  width: 160,
                                  height: 100,
                                  color: Colors.grey,
                                  child: const Icon(
                                    Icons.broken_image,
                                    color: Colors.white70,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[850],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Captured on: ${_formatCapturedTime(item['capturedOn'])}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
