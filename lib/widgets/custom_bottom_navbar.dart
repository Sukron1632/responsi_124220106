import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[500],
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.list_alt_rounded),
                  SizedBox(height: 4),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 3,
                    width: currentIndex == 0 ? 20 : 0,
                    decoration: BoxDecoration(
                      color: currentIndex == 0 ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            label: 'List Skins',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border),
                  SizedBox(height: 4),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    height: 3,
                    width: currentIndex == 1 ? 20 : 0,
                    decoration: BoxDecoration(
                      color: currentIndex == 1 ? Colors.blue : Colors.transparent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            label: 'Favorit',
          ),
        ],
      ),
    );
  }
}