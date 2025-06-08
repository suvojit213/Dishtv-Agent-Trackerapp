import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // यहाँ कंटेनर को हटा दिया गया है ताकि BottomNavigationBar सीधे थीम का उपयोग कर सके
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      // backgroundColor और unselectedItemColor को हटा दिया गया है
      // selectedItemColor को भी हटा सकते हैं क्योंकि यह अब थीम से आएगा
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          activeIcon: Icon(Icons.calendar_month),
          label: 'Monthly',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assessment_outlined),
          activeIcon: Icon(Icons.assessment),
          label: 'Reports',
        ),
      ],
    );
  }
}
