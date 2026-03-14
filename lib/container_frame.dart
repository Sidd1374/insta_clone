import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'views/home_page.dart';
import 'views/explore_page.dart';
import 'views/inbox_page.dart';
import 'views/profile_page.dart';
import 'views/reel_page.dart';

class ContainerFrame extends StatefulWidget {
  const ContainerFrame({super.key});

  @override
  State<ContainerFrame> createState() => _ContainerFrameState();
}

class _ContainerFrameState extends State<ContainerFrame> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePageFrame(),
    const ReelPageFrame(),
    const InboxPageFrame(),
    const ExplorePageFrame(),
    const ProfilePageFrame(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.black,
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          _navBarItem(
            context,
            'assets/icons/24x/home.svg',
            'assets/icons/24x/home_filled.svg',
            ' ',
          ),
          _navBarItem(
            context,
            'assets/icons/24x/reels_2026.svg',
            'assets/icons/24x/reels_2026_filled.svg',
            ' ',
          ),
          _navBarItem(
            context,
            'assets/icons/24x/share_2026.svg',
            'assets/icons/24x/share_2026_filled.svg',
            ' ',
          ),
          _navBarItem(
            context,
            'assets/icons/24x/search.svg',
            'assets/icons/24x/search_filled.svg',
            ' ',
          ),
          _navBarItem(
            context,
            'assets/icons/24x/profile.svg',
            'assets/icons/24x/profile_filled.svg',
            ' ',
          ),
        ],
      ),
    );
  }
}

BottomNavigationBarItem _navBarItem(
  BuildContext context,
  String iconOutline,
  String iconFilled,
  String label,
) {
  return BottomNavigationBarItem(
    icon: SvgPicture.asset(iconOutline, width: 28, height: 28),
    activeIcon: SvgPicture.asset(iconFilled, width: 28, height: 28),
    label: label,
  );
}
