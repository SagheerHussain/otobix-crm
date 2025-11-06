import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/models/user_model.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/empty_data_widget.dart';
import 'package:otobix_crm/widgets/shimmer_widget.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';
import 'package:otobix_crm/admin/controller/admin_pending_users_list_controller.dart';
import 'package:otobix_crm/admin/controller/admin_rejected_users_list_controller.dart';

class AdminPendingUsersListPage extends StatelessWidget {
  final RxString searchQuery;
  final RxList<String> selectedRoles;
  AdminPendingUsersListPage({
    super.key,
    required this.searchQuery,
    required this.selectedRoles,
  });

  final getxController = Get.put(AdminPendingUsersListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (getxController.isLoading.value) {
          return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, __) => _buildShimmerCard(),
          );
        }

        // search + role filter
        final filteredUsers = getxController.filteredUsersList.where((user) {
          final query = (searchQuery.value).toLowerCase().trim();

          // Safe strings
          final name = (user.userName).toLowerCase();
          final email = (user.email).toLowerCase();
          final role = user.userRole;

          // Role filter: if 'All' is selected, everything passes
          final roles = selectedRoles; // RxList<String>
          final matchesRole =
              roles.contains('All') ? true : roles.contains(role);

          // Text search (empty query passes)
          final matchesSearch =
              query.isEmpty || name.contains(query) || email.contains(query);

          return matchesRole && matchesSearch;
        }).toList();

        if (filteredUsers.isEmpty) {
          return Center(
            child: EmptyDataWidget(message: "No pending users found."),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(15),
          itemCount: filteredUsers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return _buildUserCard(user, context);
          },
        );
      }),
    );
  }

  Widget _buildUserCard(UserModel user, BuildContext context) {
    return InkWell(
      onTap: () => _buildUserDetailsBottomSheet(user),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.green.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.green.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Row → Avatar, name, location
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Avatar
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade50,
                  child: Text(
                    user.userName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                /// Name & email
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(color: AppColors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    user.userRole,
                    style: TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    // user.entityType!,
                    'Individual',
                    style: TextStyle(
                      color: AppColors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.location_on, size: 15, color: AppColors.blue),
                const SizedBox(width: 4),
                Text(
                  user.location,
                  style: TextStyle(
                    color: AppColors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Divider(color: Colors.grey.shade200, thickness: 1),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: 'Approve',
                    isLoading: false.obs,
                    height: 35,
                    fontSize: 12,
                    elevation: 3,
                    onTap: () async {
                      getxController.approveUser(user.id);

                      //Temp for now
                      // await Get.find<AdminApprovedUsersListController>()
                      //     .fetchApprovedUsersList();
                      //////////////
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ButtonWidget(
                    text: 'Reject',
                    isLoading: false.obs,
                    height: 35,
                    fontSize: 12,
                    backgroundColor: AppColors.red,
                    textColor: AppColors.white,
                    elevation: 3,
                    onTap: () => showRejectDialog(context, user.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showRejectDialog(BuildContext context, String userId) {
    final TextEditingController commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            "Reject User",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Please enter a comment or reason for rejecting this user.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Type comment here...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final comment = commentController.text.trim();

                if (comment.isEmpty) {
                  ToastWidget.show(
                    context: Get.context!,
                    title: "Validation",
                    subtitle: "Comment cannot be empty.",
                    type: ToastType.error,
                  );
                  return;
                }

                Navigator.pop(context);
                getxController.updateUserStatus(
                  userId: userId,
                  approvalStatus: "Rejected",
                  comment: comment,
                );

                //Temp for now
                await Get.find<AdminRejectedUserListController>()
                    .fetchRejectedUsersList();
                //////////////
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text(
                "Reject",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Row → Avatar, name, location
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ShimmerWidget(width: 56, height: 56, borderRadius: 50),
              const SizedBox(width: 12),

              /// Name & email shimmer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget(width: 120, height: 14),
                    SizedBox(height: 8),
                    ShimmerWidget(width: 100, height: 12),
                  ],
                ),
              ),

              /// Location shimmer
              const SizedBox(width: 8),
              const ShimmerWidget(width: 80, height: 14),
            ],
          ),

          const SizedBox(height: 16),

          /// Role & Entity shimmer tags
          Row(
            children: const [
              ShimmerWidget(width: 60, height: 20, borderRadius: 30),
              SizedBox(width: 8),
              ShimmerWidget(width: 70, height: 20, borderRadius: 30),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade200, thickness: 1),
          const SizedBox(height: 16),

          /// Approve & Reject buttons shimmer
          Row(
            children: const [
              Expanded(child: ShimmerWidget(height: 42, borderRadius: 12)),
              SizedBox(width: 12),
              Expanded(child: ShimmerWidget(height: 42, borderRadius: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _buildUserDetailsBottomSheet(UserModel user) {
    showModalBottomSheet(
      context: Get.context!,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(maxWidth: Get.width * 0.9),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.95,
          minChildSize: 0.4,
          initialChildSize: 0.8,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          user.image != null && user.image!.isNotEmpty
                              ? NetworkImage(user.image!)
                              : null,
                      child: user.image == null || user.image!.isEmpty
                          ? Text(
                              user.userName.substring(0, 1).toUpperCase(),
                              style: const TextStyle(fontSize: 28),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: Text(
                      user.userName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Center(
                    child: Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  const Divider(height: 30),

                  _infoTile("Role", user.userRole),
                  _infoTile("User Name", user.userName),
                  // _infoTile("Password", user.password),
                  _infoTile("Phone", user.phoneNumber),
                  _infoTile("Location", user.location),
                  if (user.dealershipName != null &&
                      user.dealershipName!.isNotEmpty)
                    _infoTile("Dealership", user.dealershipName!),
                  if (user.entityType != null && user.entityType!.isNotEmpty)
                    _infoTile("Entity Type", user.entityType!),
                  if (user.primaryContactPerson != null &&
                      user.primaryContactPerson!.isNotEmpty)
                    _infoTile("Primary Contact", user.primaryContactPerson!),
                  if (user.primaryContactNumber != null &&
                      user.primaryContactNumber!.isNotEmpty)
                    _infoTile("Primary Number", user.primaryContactNumber!),
                  if (user.secondaryContactPerson != null &&
                      user.secondaryContactPerson!.isNotEmpty)
                    _infoTile(
                      "Secondary Contact",
                      user.secondaryContactPerson!,
                    ),
                  if (user.secondaryContactNumber != null &&
                      user.secondaryContactNumber!.isNotEmpty)
                    _infoTile("Secondary Number", user.secondaryContactNumber!),
                  if (user.createdAt != null)
                    _infoTile(
                      "Approved On",
                      DateFormat('dd MMM yyyy').format(user.createdAt!),
                    ),
                  if (user.addressList.isNotEmpty)
                    _infoTile("Addresses", user.addressList.join(", ")),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _infoTile(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$title:",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
