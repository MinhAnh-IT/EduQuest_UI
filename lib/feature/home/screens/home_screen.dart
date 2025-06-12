import 'package:flutter/material.dart';
import '../../auth/screens/login_screen.dart'; // Keep for ProfileTab logout
import '../../../shared/widgets/bottom_navigation_bar.dart'; // Import the new widget
import 'profile_screen.dart'; // Import the new ProfileScreen

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeTab(),
    ProfileScreen(), // Use ProfileScreen
  ];

  void _showJoinClassDialog(BuildContext context) {
    final TextEditingController classCodeController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tham gia lớp học'),
          content: TextField(
            controller: classCodeController,
            decoration: InputDecoration(hintText: 'Nhập mã lớp'),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Tham gia'),
              onPressed: () {
                // Handle join class logic here
                String classCode = classCodeController.text;
                print('Class code entered: $classCode'); // Placeholder
                Navigator.of(context).pop();
                // You can add logic to actually join the class here
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showJoinClassDialog(context);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan, // Or your preferred color
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Standard position
      bottomNavigationBar: BottomNavigationBarWidget( // Use the new widget
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<Map<String, String>> _allClasses = [
    {
      'name': 'C5 HK2B NH24-25 Mần...',
      'instructor': 'Anh Nguyen Dinh',
    },
    {
      'name': 'Lý Thuyết: PTTRKHT Sáng 3',
      'instructor': 'Nguyen Tien Trung',
    },
    {
      'name': '2A_24_25_CSDLNC_CHI...',
      'instructor': 'Nguyen Van Danh',
    },
    {
      'name': '22DTHC6-22DTHC5 - C...',
      'instructor': 'Pham Buu Tai',
    },
    {
      'name': '[WIN-SÁNG-THỨ 6] - N...',
      'instructor': 'Hung Tran',
    },
  ];
  List<Map<String, String>> _filteredClasses = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredClasses = _allClasses;
    _searchController.addListener(_filterClasses);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterClasses);
    _searchController.dispose();
    super.dispose();
  }

  void _filterClasses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredClasses = _allClasses;
      } else {
        _filteredClasses = _allClasses.where((classData) {
          final nameLower = classData['name']!.toLowerCase();
          final instructorLower = classData['instructor']!.toLowerCase();
          return nameLower.contains(query) || instructorLower.contains(query);
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear(); // Clears text and triggers _filterClasses
      }
      // Focus will be handled by autofocus property of TextField
    });
  }

  Color _getCardColor(int index) {
    const List<Color> colors = [
      Color(0xFF4285F4), // Blue
      Color(0xFF34A853), // Green
      Color(0xFFFBBC05), // Yellow
      Color(0xFFEA4335), // Red
      Color(0xFF6D4C41), // Brown
    ];
    // To make color assignment more stable with filtering,
    // you might want to assign colors based on a unique ID or original index
    // For now, it cycles through the filtered list.
    return colors[index % colors.length].withOpacity(0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('EduQuest'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm lớp học...',
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[600]),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(color: Colors.cyan, width: 1.5),
                  ),
                ),
              ),
            ),
          Expanded(
            child: SafeArea(
              top: !_isSearching, // Only apply top SafeArea padding if search bar is not visible
              bottom: true,
              left: true,
              right: true,
              child: _filteredClasses.isEmpty && _searchController.text.isNotEmpty
                  ? Center(
                child: Text(
                  'Không tìm thấy kết quả nào.',
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                itemCount: _filteredClasses.length,
                itemBuilder: (context, index) {
                  final classData = _filteredClasses[index];
                  return Card(
                    color: _getCardColor(index),
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                      leading: Icon(Icons.class_, color: Colors.white, size: 30),
                      title: Text(
                        classData['name']!,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        classData['instructor']!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(Icons.more_vert, color: Colors.white),
                      onTap: () {
                        // Handle class item tap
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}