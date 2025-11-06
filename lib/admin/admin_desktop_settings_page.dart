import 'package:flutter/material.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/widgets/tab_bar_widget.dart';
import 'package:otobix_crm/admin/admin_upload_policies_page.dart';
import 'package:otobix_crm/admin/admin_upload_terms_page.dart';
import 'package:otobix_crm/admin/admin_upload_user_guide_page.dart';

class AdminDesktopSettingsPage extends StatelessWidget {
  const AdminDesktopSettingsPage({super.key});

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildDesktopHeader(),

            SizedBox(height: 32),

            // Main Content
            Expanded(
              child: Container(
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
                  children: [
                    // Desktop Tabs
                    _buildDesktopTabs(),

                    // Tab Content
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: _buildDesktopTabContent(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Document Management",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Upload and manage terms, policies, and user guides",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTabs() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          _buildDesktopTab(
            icon: Icons.description_outlined,
            title: "Terms & Conditions",
            description: "Manage terms of service",
            index: 0,
          ),
          SizedBox(width: 24),
          _buildDesktopTab(
            icon: Icons.privacy_tip_outlined,
            title: "Privacy Policies",
            description: "Update privacy policies",
            index: 1,
          ),
          SizedBox(width: 24),
          _buildDesktopTab(
            icon: Icons.help_outline,
            title: "User Guide",
            description: "Upload user documentation",
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTab({
    required IconData icon,
    required String title,
    required String description,
    required int index,
  }) {
    return Expanded(
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // You might want to add tab switching logic here
            },
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: AppColors.green,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTabContent() {
    // Since TabBarWidget might not work well in desktop layout,
    // you can create a custom desktop version or use IndexedStack
    return IndexedStack(
      index: 0, // You'll need to manage this state
      children: [
        // Wrap your pages in desktop-friendly containers
        _buildDesktopPageContainer(AdminUploadTermsPage()),
        _buildDesktopPageContainer(AdminUploadPoliciesPage()),
        _buildDesktopPageContainer(AdminUploadUserGuidePage()),
      ],
    );
  }

  Widget _buildDesktopPageContainer(Widget child) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
