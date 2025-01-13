import 'package:flutter/material.dart';
import 'package:gaavkarikatta/Views/Auth/Profile.dart';
import 'package:gaavkarikatta/Views/Billpage.dart';
import 'package:gaavkarikatta/Views/Menu.dart';
import 'package:get/get.dart';
import '../Controllers/Bottombar.dart';

class HomeScreen extends StatelessWidget {
  final BottomBarController controller = Get.put(BottomBarController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () {
            // Show the appropriate page based on selected index
            switch (controller.selectedIndex.value) {
              case 0:
                return MenuPage();
              case 1:
                return BillsPage();
              case 2:
                return ProfilePage(); // Show BillsPage for index 2
              default:
                return MenuPage();
            }
          },
        ),
        bottomNavigationBar: Obx(
          () {
            return BottomNavigationBar(
              currentIndex: controller.selectedIndex.value,
              onTap: controller.changeTab,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt),
                  label: 'Bills',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person), // Icon for Bills
                  label: 'Profils',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
