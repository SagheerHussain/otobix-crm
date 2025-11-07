import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/admin/admin_upload_policies_page.dart';
import 'package:otobix_crm/admin/admin_upload_terms_page.dart';
import 'package:otobix_crm/admin/admin_upload_user_guide_page.dart';

class AdminDesktopSettingsPage extends StatefulWidget {
  const AdminDesktopSettingsPage({super.key});

  @override
  State<AdminDesktopSettingsPage> createState() =>
      _AdminDesktopSettingsPageState();
}

class _AdminDesktopSettingsPageState extends State<AdminDesktopSettingsPage> {
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> _tabs = [
    {
      'title': 'Terms & Conditions',
      'description': 'Manage terms of service',
      'icon': Icons.description_outlined,
      'page': AdminUploadTermsPage(),
    },
    {
      'title': 'Privacy Policies',
      'description': 'Update privacy policies',
      'icon': Icons.privacy_tip_outlined,
      'page': AdminUploadPoliciesPage(),
    },
    {
      'title': 'User Guide',
      'description': 'Upload user documentation',
      'icon': Icons.help_outline,
      'page': AdminUploadUserGuidePage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _buildDesktopLayout();
  }

  // Desktop Layout
  Widget _buildDesktopLayout() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 1200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.arrow_back, color: Colors.grey[600]),
                  ),
                ),
                SizedBox(width: 32),

                // Left Side - Tabs Navigation
                _buildTabsSection(),

                SizedBox(width: 32),

                // Right Side - Content
                Expanded(
                  child: _buildContentSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabsSection() {
    return Container(
      width: 350,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Document Settings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Manage your application content',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ..._tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = _selectedTabIndex == index;

            return _buildTabItem(
              icon: tab['icon'],
              title: tab['title'],
              description: tab['description'],
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required IconData icon,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color:
            isSelected ? AppColors.green.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.green : Colors.transparent,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.green : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? Colors.white : AppColors.green,
                    size: 24,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected ? AppColors.green : Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              isSelected ? AppColors.green : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.green,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _tabs[_selectedTabIndex]['title'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _tabs[_selectedTabIndex]['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              // _buildActionButtons(),
            ],
          ),

          SizedBox(height: 24),
          Divider(),
          SizedBox(height: 24),

          // Content Area
          Expanded(
            child: _buildDesktopPageContainer(_tabs[_selectedTabIndex]['page']),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        OutlinedButton.icon(
          icon: Icon(Icons.download_outlined, size: 18),
          label: Text('Export'),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Add export functionality
          },
        ),
        SizedBox(width: 12),
        ElevatedButton.icon(
          icon: Icon(Icons.upload_outlined, size: 18),
          label: Text('Upload New'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.green,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            // Add upload functionality
          },
        ),
      ],
    );
  }

  Widget _buildDesktopPageContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}
