import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/admin_desktop_home_page.dart';
import 'package:otobix_crm/admin/admin_desktop_profile_page.dart';
import 'package:otobix_crm/admin/admin_kam_page.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/admin/admin_home.dart';
import 'package:otobix_crm/admin/admin_profile_page.dart';
import 'package:otobix_crm/utils/responsive_layout.dart';
import 'package:otobix_crm/utils/shared_prefs_helper.dart';

class AdminDesktopDashboard extends StatefulWidget {
  const AdminDesktopDashboard({super.key});
  @override
  State<AdminDesktopDashboard> createState() => _AdminDesktopDashboardState();
}

class _AdminDesktopDashboardState extends State<AdminDesktopDashboard> {
  RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    ResponsiveLayout(mobile: AdminHome(), desktop: AdminDesktopHomePage()),
    ResponsiveLayout(
        mobile: AdminProfilePage(), desktop: AdminDesktopProfilePage()),
    ResponsiveLayout(mobile: AdminKamPage(), desktop: AdminKamPage()),
  ];

  // Navigation items for desktop sidebar
  final List<NavigationItem> navItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: "Home",
      index: 0,
    ),
    NavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person,
      label: "Profile",
      index: 1,
    ),
    NavigationItem(
      icon: Icons.manage_accounts_outlined,
      activeIcon: Icons.manage_accounts,
      label: "KAM Management",
      index: 2,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _buildDesktopLayout();
  }

  // Desktop Layout with Sidebar
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Row(
        children: [
          // Sidebar Navigation
          _buildSidebar(),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top App Bar
                // _buildAppBar(),

                // Main Content
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                      ),
                    ),
                    child: Obx(() => pages[currentIndex.value]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Sidebar Widget for Desktop
  Widget _buildSidebar() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey[200]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo and App Name
          _buildSidebarHeader(),

          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 20),
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                return _buildNavItem(item);
              },
            ),
          ),

          // User Profile Section
          _buildUserSection(),
        ],
      ),
    );
  }

  // Sidebar Header with Logo
  Widget _buildSidebarHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.green, AppColors.blue],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                Icon(Icons.admin_panel_settings, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "OtoBix CRM",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                "Admin Panel",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Navigation Item for Desktop
  Widget _buildNavItem(NavigationItem item) {
    return Obx(() {
      final isActive = currentIndex.value == item.index;
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color:
              isActive ? AppColors.green.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          leading: Icon(
            isActive ? item.activeIcon : item.icon,
            color: isActive ? AppColors.green : Colors.grey[600],
            size: 22,
          ),
          title: Text(
            item.label,
            style: TextStyle(
              color: isActive ? AppColors.green : Colors.grey[700],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          // trailing: isActive
          //     ? Container(
          //         width: 4,
          //         height: 4,
          //         decoration: BoxDecoration(
          //           color: AppColors.green,
          //           shape: BoxShape.circle,
          //         ),
          //       )
          //     : null,
          onTap: () {
            currentIndex.value = item.index;
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    });
  }

  // User Section at Bottom of Sidebar
  Widget _buildUserSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: FutureBuilder(
          future: _getUserImageUrl(),
          builder: (context, snapshot) {
            final String userImageUrl = snapshot.data ?? "";
            return Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.blue.withOpacity(0.1),
                    border: Border.all(color: AppColors.blue, width: 1),
                  ),
                  child: userImageUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            userImageUrl,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.person,
                                  color: AppColors.blue, size: 20);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        )
                      : Icon(Icons.person, color: AppColors.blue, size: 20),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Admin User",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      Text(
                        "Administrator",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.logout, color: Colors.grey[500], size: 20),
                //   onPressed: () {
                //     // Add logout functionality
                //   },
                // ),
              ],
            );
          }),
    );
  }

  // Top App Bar for Desktop
  Widget _buildAppBar() {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          // Page Title
          Obx(() {
            final currentItem = navItems.firstWhere(
              (item) => item.index == currentIndex.value,
              orElse: () => navItems[0],
            );
            return Text(
              currentItem.label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            );
          }),

          Spacer(),

          // Search Bar
          // Container(
          //   width: 300,
          //   height: 40,
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: "Search...",
          //       prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          //       filled: true,
          //       fillColor: Colors.grey[50],
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(8),
          //         borderSide: BorderSide.none,
          //       ),
          //       contentPadding: EdgeInsets.symmetric(vertical: 0),
          //     ),
          //   ),
          // ),

          // SizedBox(width: 16),

          // // Notifications
          // IconButton(
          //   icon: Stack(
          //     children: [
          //       Icon(Icons.notifications_outlined, color: Colors.grey[600]),
          //       Positioned(
          //         right: 0,
          //         top: 0,
          //         child: Container(
          //           width: 8,
          //           height: 8,
          //           decoration: BoxDecoration(
          //             color: Colors.red,
          //             shape: BoxShape.circle,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          //   onPressed: () {},
          // ),

          // SizedBox(width: 16),

          // // Settings
          // IconButton(
          //   icon: Icon(Icons.settings_outlined, color: Colors.grey[600]),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }

  Future<String> _getUserImageUrl() async {
    return await SharedPrefsHelper.getString(
            SharedPrefsHelper.userImageUrlKey) ??
        "";
  }
}

// Navigation Item Model for Desktop
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
  });
}
