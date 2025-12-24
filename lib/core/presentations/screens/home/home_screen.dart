import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sbms_apps/core/config/app_routes/app_routes.dart';
import 'package:sbms_apps/core/presentations/screens/home/sales_list_screen.dart';

import '../../../../global/custom_assets/assets.gen.dart';
import '../../../constants/app_colors.dart';
import '../../../helpers/auth_helper.dart';
import '../profile/view_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    _HomeContent(logoutCallback: () => _handleLogout()),
    const SalesListScreen(),
    ViewProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Order List'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'),
        ],
      ),
    );
  }

  void _handleLogout() async {
    // Show confirmation dialog
    bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    ) ?? false;

    if (confirmed) {
      await AuthHelper.logout();
      // Navigate back to login screen using GoRouter
      if (mounted) {
        GoRouter.of(context).goNamed(AppRoutes.logInScreen);
      }
    }
  }
}

// Extract the original home content to a separate widget
class _HomeContent extends StatelessWidget {
  final VoidCallback logoutCallback;

  const _HomeContent({required this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildAppDrawer(context),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Row(
          children: [
            const Text(
              "UAI-CONNECT",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Assets.images.logo4.image(
              width: 42.w,
              height: 42.h,
            ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTargetCard("Monthly Target", "00"),
                _buildTargetCard("Today Sales", "00"),
              ],
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMenuButton(
                  icon: Icons.list_alt,
                  title: "Product List",
                  onTap: () {
                    context.pushNamed(AppRoutes.productListScreen);

                  },
                ),
                _buildMenuButton(
                  icon: Icons.add_shopping_cart,
                  title: "Order List",
                  onTap: () {
                    context.pushNamed(AppRoutes.salesListScreen);

                  },
                ),

                _buildMenuButton(
                  icon: Icons.receipt_long,
                  title: "Order Create",
                  onTap: () {
                    context.pushNamed(AppRoutes.orderListScreen);
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMenuButton(
                  icon: Icons.comment_bank_outlined,
                  title: "Bank List",
                  onTap: () {
                    context.pushNamed(AppRoutes.bankReceiveListScreen);
                  },
                ),
                SizedBox(width: 20.w),
                _buildMenuButton(
                  icon: Icons.food_bank_outlined,
                  title: "Bank Create",
                  onTap: () {
                    context.pushNamed(AppRoutes.createScreen);
                  },
                ),
              ],
            )


          ],
        ),
      ),
    );
  }

  /// --- Drawer Widget ---
  Drawer _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.primaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// App Logo
                CircleAvatar(
                  radius: 35.r,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(6.r),
                    child:  Assets.images.logo4.image(
                      width: 42.w,
                      height: 42.h,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Welcome to UAI-CONNECT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          /// Drawer Items
          _buildDrawerItem(
            icon: Icons.home,
            text: "Home",
            onTap: () => Navigator.pop(context),
          ),
          _buildDrawerItem(
            icon: Icons.support_agent,
            text: "Support",
            onTap: () {

            },
          ),
          _buildDrawerItem(
            icon: Icons.policy,
            text: "Policy",
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.star_rate,
            text: "Rate Us",
            onTap: () {},
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            text: "Logout",
            onTap: logoutCallback,
          ),

        ],
      ),
    );
  }

  /// --- Drawer Item Widget ---
  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryColor),
      title: Text(
        text,
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
      ),
      onTap: onTap,
    );
  }

  /// --- Target Card Widget ---
  Widget _buildTargetCard(String title, String value) {
    return Container(
      width: 160.w,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// --- Menu Button Widget ---
  Widget _buildMenuButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 80.w,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28.sp, color: Colors.white),
            SizedBox(height: 10.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}