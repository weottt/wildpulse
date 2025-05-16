import 'package:flutter/material.dart';
import 'device_location_page.dart';
import 'notification.dart';
import 'monitoring.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<Map<String, String>> featuredAnimals = [
    {
      'image': 'assets/visayan_spotted_deer.jpg',
      'label': 'Visayan Spotted Deer',
    },
    {'image': 'assets/philippine_hornbill.jpg', 'label': 'Philippine Hornbill'},
    {'image': 'assets/visayan_warty_pig.jpg', 'label': 'Visayan Warty Pig'},
  ];

  final List<Map<String, String>> conservationList = [
    {
      'image': 'assets/philippine_hornbill.jpg',
      'title': 'Philippine Hornbill (Buceros hydrocorax)',
      'category': 'Bird',
      'status': 'Endangered',
    },
    {
      'image': 'assets/visayan_spotted_deer.jpg',
      'title': 'Visayan Spotted Deer (Rusa alfredi)',
      'category': 'Mammal',
      'status': 'Endangered',
    },
    {
      'image': 'assets/visayan_warty_pig.jpg',
      'title': 'Visayan Warty Pig (Sus cebifrons)',
      'category': 'Mammal',
      'status': 'Near Threatened',
    },
  ];

  void _onNavBarTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildHomePageContent() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: featuredAnimals.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        featuredAnimals[index]['image']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        color: Colors.black54,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: Text(
                          featuredAnimals[index]['label']!.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(featuredAnimals.length, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      _currentPage == index
                          ? Colors.greenAccent[400]
                          : Colors.grey,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: 'Animal Monitoring',
              fillColor: Colors.grey[850],
              filled: true,
              prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Animal Conservation List',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                'Show All',
                style: TextStyle(
                  color: Colors.greenAccent[400],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: conservationList.length,
              itemBuilder: (context, index) {
                final animal = conservationList[index];
                return Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        animal['image']!,
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(
                      animal['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${animal['category']} • ${animal['status']}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            children: const [
              Icon(Icons.pets, color: Colors.white),
              SizedBox(width: 10),
              Text(
                'Wild Pulse Dashboard',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.black87,
        body: _buildHomePageContent(),
      ),
      const DeviceLocationPage(),
      NotificationPage(),
      MonitoringFeedPage(),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // disable swipe if you want
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color.fromARGB(255, 243, 219, 7),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentPage,
        onTap: _onNavBarTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(
            icon: Icon(Icons.compass_calibration_sharp),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
