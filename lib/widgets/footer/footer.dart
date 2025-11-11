import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_reader/screens/home/home_screen.dart';
import 'package:smart_reader/screens/profile/profile_screen.dart';
import 'package:smart_reader/widgets/footer/footer_item.dart';

class CustomFooter extends StatefulWidget {
  final selectedIndex;
  final Function(int) onItemSelected;

  const CustomFooter({
    super.key,
    this.selectedIndex = 0,
    required this.onItemSelected,
  });

  @override
  State<CustomFooter> createState() => _CustomFooterState();
}

class _CustomFooterState extends State<CustomFooter> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onItemSelected(index);
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FooterItem(
            icon: Icons.home_outlined,
            label: 'Trang chủ',
            onTap: () => _onItemTapped(0),
            isSelected: _selectedIndex == 0,
          ),
          FooterItem(
            icon: Icons.search,
            label: 'Tìm kiếm',
            onTap: () => _onItemTapped(1),
            isSelected: _selectedIndex == 1,
          ),
          FooterItem(
            icon: Icons.favorite_border_outlined,
            label: 'Yêu thích',
            onTap: () => _onItemTapped(2),
            isSelected: _selectedIndex == 2,
          ),
          FooterItem(
            icon: Icons.person_outlined,
            label: 'Bạn đọc',
            onTap: () => _onItemTapped(3),
            isSelected: _selectedIndex == 3,
          ),
        ],
      ),
    );
  }
}
