import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final List<_NavIcon> icons = [
      _NavIcon(
        label: 'Home',
        icon: Icons.home,
        onClick: () {},
      ),
      _NavIcon(
        label: 'Chat',
        icon: Icons.email,
        onClick: () {},
      ),
      _NavIcon(
        label: '',
        icon: Icons.add,
        onClick: () {},
      ),
      _NavIcon(
        label: 'Bantubeat',
        icon: Icons.abc,
        onClick: () {},
      ),
      _NavIcon(
        label: 'profil',
        icon: Icons.person,
        onClick: () {},
      ),
      _NavIcon(
        label: 'music',
        icon: Icons.music_note,
        onClick: () {},
      ),
      _NavIcon(
        label: 'beat',
        icon: Icons.speaker_group,
        onClick: () {},
      ),
      _NavIcon(label: 'settings', icon: Icons.settings, onClick: () {}),
      _NavIcon(
        label: 'featlink',
        icon: Icons.abc,
        onClick: () {},
      ),
      _NavIcon(
        label: 'log out',
        icon: Icons.login,
        onClick: () {},
        isBlur: false,
      ),
    ];

    Widget buildIcon(BuildContext context, _NavIcon item) {
      return Icon(item.icon, color: Colors.white60, size: 36);
    }

    return Stack(
      children: [
        Positioned(
          bottom: 0,
          child: Container(
            width: screenWidth,
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            decoration: const BoxDecoration(color: Colors.black),
            child: Wrap(
              runSpacing: 16,
              children: List.generate(isExpanded ? icons.length : 5, (index) {
                final item = icons[index];
                return InkWell(
                  onTap: item.onClick,
                  child: SizedBox(
                    width: screenWidth / 5,
                    child: Column(
                      children: [
                        buildIcon(context, item),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: (item.isBlur)
                                ? Colors.white60.withValues(alpha: 0.2)
                                : Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: isExpanded ? 132.5 : 65, // Adjust bottom value as needed
          child: Align(
            child: GestureDetector(
              onTap: () => {
                setState(() {
                  isExpanded = !isExpanded;
                }),
              },
              onVerticalDragStart: (DragStartDetails details) => {
                setState(() {
                  isExpanded = !isExpanded;
                }),
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFFEBEBEB),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEBEBEB),
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavIcon {
  final String label;
  final IconData icon;
  final bool isBlur;
  final VoidCallback onClick;

  _NavIcon({
    required this.label,
    required this.icon,
    required this.onClick,
    this.isBlur = false,
  });
}
