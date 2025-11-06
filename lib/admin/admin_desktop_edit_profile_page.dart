import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/controller/admin_profile_controller.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/app_constants.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(AdminProfileController());

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 768;

    if (isDesktop) {
      return _buildDesktopLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  // Mobile Layout (your existing code)
  Widget _buildMobileLayout() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.grey.withValues(alpha: .1),
          iconTheme: const IconThemeData(color: AppColors.green),
          title: const Text(
            'Edit My Profile',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.updateProfile();
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() {
                      final imageUrl = controller.imageUrl.value;
                      final imageFile = controller.imageFile.value;

                      return CircleAvatar(
                        radius: 55,
                        backgroundImage: imageFile != null
                            ? FileImage(imageFile) as ImageProvider
                            : (imageUrl.isNotEmpty
                                ? NetworkImage(
                                    imageUrl.startsWith('http')
                                        ? imageUrl
                                        : imageUrl,
                                  )
                                : null),
                        child: imageFile == null && imageUrl.isEmpty
                            ? const Icon(Icons.person, size: 55)
                            : null,
                      );
                    }),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: InkWell(
                        onTap: () {
                          controller.pickImageFromDevice();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.redAccent),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.redAccent,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildTextField('Email', controller.userEmail),
                _buildTextField('Location', controller.location),
                if (controller.userRole.value == 'Dealer') ...[
                  _buildTextField('Dealership Name', controller.dealershipName),
                  _buildTextField(
                    'Primary Contact Person',
                    controller.primaryContactPerson,
                  ),
                  _buildTextField(
                    'Primary Contact Number',
                    controller.primaryContactNumber,
                  ),
                  _buildTextField(
                    'Secondary Contact Person',
                    controller.secondaryContactPerson,
                  ),
                  _buildTextField(
                    'Secondary Contact Number',
                    controller.secondaryContactNumber,
                  ),
                ],
                if ([
                  AppConstants.roles.dealer,
                  AppConstants.roles.customer,
                  AppConstants.roles.salesManager,
                ].contains(controller.userRole.value))
                  _buildAddressList(controller),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      );
    });
  }

  // Desktop Layout
  Widget _buildDesktopLayout() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side - Profile Picture
                  _buildProfileSection(),

                  SizedBox(width: 32),

                  // Right Side - Form
                  Expanded(
                    child: _buildFormSection(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildProfileSection() {
    return Container(
      width: 300,
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
        children: [
          Text(
            'Profile Picture',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Obx(() {
                final imageUrl = controller.imageUrl.value;
                final imageFile = controller.imageFile.value;

                return Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.green, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: imageFile != null
                        ? FileImage(imageFile) as ImageProvider
                        : (imageUrl.isNotEmpty
                            ? NetworkImage(
                                imageUrl.startsWith('http')
                                    ? imageUrl
                                    : imageUrl,
                              )
                            : null),
                    child: imageFile == null && imageUrl.isEmpty
                        ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                        : null,
                  ),
                );
              }),
              Positioned(
                bottom: 8,
                right: 8,
                child: InkWell(
                  onTap: () {
                    controller.pickImageFromDevice();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.green,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Text(
            'Click the camera icon to update your profile picture',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
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
              Text(
                'Edit Profile Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.save, size: 18),
                label: Text('Save Changes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  controller.updateProfile();
                },
              ),
            ],
          ),

          SizedBox(height: 8),
          Text(
            'Update your personal and business information',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),

          SizedBox(height: 32),

          // Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Basic Information Section
                _buildSectionHeader('Basic Information'),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: _buildDesktopTextField(
                            'Email', controller.userEmail)),
                    SizedBox(width: 16),
                    Expanded(
                        child: _buildDesktopTextField(
                            'Location', controller.location)),
                  ],
                ),

                // Dealer Specific Fields
                if (controller.userRole.value == 'Dealer') ...[
                  SizedBox(height: 32),
                  _buildSectionHeader('Dealership Information'),
                  SizedBox(height: 16),
                  _buildDesktopTextField(
                      'Dealership Name', controller.dealershipName),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDesktopTextField(
                              'Primary Contact Person',
                              controller.primaryContactPerson)),
                      SizedBox(width: 16),
                      Expanded(
                          child: _buildDesktopTextField(
                              'Primary Contact Number',
                              controller.primaryContactNumber)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                          child: _buildDesktopTextField(
                              'Secondary Contact Person',
                              controller.secondaryContactPerson)),
                      SizedBox(width: 16),
                      Expanded(
                          child: _buildDesktopTextField(
                              'Secondary Contact Number',
                              controller.secondaryContactNumber)),
                    ],
                  ),
                ],

                // Address Section
                if ([
                  AppConstants.roles.dealer,
                  AppConstants.roles.customer,
                  AppConstants.roles.salesManager,
                ].contains(controller.userRole.value))
                  _buildDesktopAddressList(controller),

                SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          height: 24,
          width: 4,
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopTextField(
      String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.blue,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(fontSize: 14),
          decoration: InputDecoration(
            enabled: false,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.blue),
            ),
            fillColor: Colors.grey.shade50,
            filled: true,
          ),
          validator: (value) =>
              value == null || value.isEmpty ? 'Required' : null,
        ),
      ],
    );
  }

  Widget _buildDesktopAddressList(AdminProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 32),
        _buildSectionHeader('Addresses'),
        SizedBox(height: 16),
        ...controller.addressList.asMap().entries.map(
              (entry) => Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: _buildDesktopTextField(
                  'Address ${entry.key + 1}',
                  TextEditingController(text: entry.value)
                    ..addListener(() {
                      controller.addressList[entry.key] = entry.value;
                    }),
                ),
              ),
            ),
      ],
    );
  }

  // Mobile version methods (keep your existing ones)
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.blue,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              enabled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.blue),
              ),
              fillColor: Colors.grey.shade100,
              filled: true,
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Required' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressList(AdminProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Addresses',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.blue,
          ),
        ),
        ...controller.addressList.map(
          (addr) => _buildTextField(
            'Address ${controller.addressList.indexOf(addr) + 1}',
            TextEditingController(text: addr)
              ..addListener(() {
                controller.addressList[controller.addressList.indexOf(addr)] =
                    addr;
              }),
          ),
        ),
      ],
    );
  }
}
