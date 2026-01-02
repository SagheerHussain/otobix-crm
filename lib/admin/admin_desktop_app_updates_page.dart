import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/controller/admin_app_updates_controller.dart';
import 'package:otobix_crm/models/app_updates_model.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/utils/app_constants.dart';

class AdminDesktopAppUpdatesPage extends StatelessWidget {
  AdminDesktopAppUpdatesPage({super.key});

  final AdminAppUpdatesController appUpdatesController =
      Get.put(AdminAppUpdatesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, appUpdatesController),
            const SizedBox(height: 24),
            Expanded(child: _buildBody(context, appUpdatesController)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, AdminAppUpdatesController controller) {
    return Row(
      children: [
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
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.arrow_back, color: Colors.grey[600]),
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.system_update_alt_rounded,
              size: 28, color: AppColors.green),
        ),
        const SizedBox(width: 16),
        const Text(
          "App Updates Manager",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: controller.fetchAppUpdates,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: const BorderSide(color: AppColors.blue),
          ),
          child: const Row(
            children: [
              Icon(Icons.refresh_rounded, size: 18),
              SizedBox(width: 8),
              Text("Refresh",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: AppColors.blue)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () => _openAddEditDialog(
            context: context, // ✅ use real context
            controller: controller,
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: AppColors.green,
            foregroundColor: Colors.white,
          ),
          child: const Row(
            children: [
              Icon(Icons.add_rounded, size: 18),
              SizedBox(width: 8),
              Text("Add App", style: TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody(
      BuildContext context, AdminAppUpdatesController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                "Loading app updates...",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        );
      }

      if (controller.appUpdatesList.isEmpty) {
        return _emptyState(context, controller);
      }

      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.4,
        ),
        itemCount: controller.appUpdatesList.length,
        itemBuilder: (context, index) {
          final doc = controller.appUpdatesList[index];
          return _appConfigCard(
              context: context, controller: controller, doc: doc);
        },
      );
    });
  }

  Widget _emptyState(
      BuildContext context, AdminAppUpdatesController controller) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.apps_outlined, size: 80, color: AppColors.green),
            const SizedBox(height: 24),
            const Text(
              "No App Configurations",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Add your first app configuration to manage updates",
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => _openAddEditDialog(
                context: context, // ✅ use real context
                controller: controller,
              ),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                "Add App Configuration",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appConfigCard({
    required BuildContext context,
    required AdminAppUpdatesController controller,
    required AppUpdatesModel doc,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: doc.enabled
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: doc.enabled
                            ? Colors.green.shade200
                            : Colors.red.shade200,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          doc.enabled
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          size: 14,
                          color: doc.enabled ? Colors.green : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          doc.enabled ? "Active" : "Inactive",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: doc.enabled
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      doc.appKey.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline_rounded, size: 18),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _openAddEditDialog(
                          context: context, // ✅ use real context
                          controller: controller,
                          existing: doc,
                        );
                      } else if (value == 'delete') {
                        _confirmDelete(controller, doc);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.more_vert_rounded, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: _platformSection(
                        platform: "Android",
                        icon: Icons.android_rounded,
                        color: AppColors.green,
                        data: doc.android,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _platformSection(
                        platform: "iOS",
                        icon: Icons.apple_rounded,
                        color: AppColors.green,
                        data: doc.ios,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _platformSection({
    required String platform,
    required IconData icon,
    required Color color,
    required PlatformType data,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                platform,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow("Package:", data.packageName),
                const SizedBox(height: 8),
                _infoRow("Latest:", data.latestVersion),
                const SizedBox(height: 8),
                _infoRow("Minimum:", data.minSupportedVersion),
                if (data.storeUrl.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _infoRow("Store URL:", data.storeUrl, isUrl: true),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isUrl = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value.isNotEmpty ? value : "-",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isUrl ? Colors.blue.shade700 : Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _confirmDelete(
      AdminAppUpdatesController controller, AppUpdatesModel doc) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Configuration"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
                "Are you sure you want to delete this app configuration?"),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_rounded, color: Colors.red.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "App: ${doc.appKey.toUpperCase()}",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child:
                const Text("Cancel", style: TextStyle(color: AppColors.blue)),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await controller.deleteAppUpdates(doc.id!);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red.withOpacity(0.8),
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _openAddEditDialog({
    required BuildContext context,
    required AdminAppUpdatesController controller,
    AppUpdatesModel? existing,
  }) {
    List<String> appKeys = [
      AppConstants.appNames.dealer,
      AppConstants.appNames.customer,
      AppConstants.appNames.inspection,
    ];

    final isEdit = existing != null;

    // final appKeyC =
    //     TextEditingController(text: existing?.appKey ?? appKeys.first);

    final selectedAppKey = (existing?.appKey ?? appKeys.first).obs;

    final enabled = (existing?.enabled ?? true).obs;

    final aPackageC = TextEditingController(
        text: existing?.android.packageName ?? "com.otobix.");
    final aLatestC =
        TextEditingController(text: existing?.android.latestVersion ?? "1.0.0");
    final aMinC = TextEditingController(
        text: existing?.android.minSupportedVersion ?? "1.0.0");
    final aStoreC =
        TextEditingController(text: existing?.android.storeUrl ?? "");
    final aNotesC =
        TextEditingController(text: existing?.android.releaseNotes ?? "");

    final iPackageC =
        TextEditingController(text: existing?.ios.packageName ?? "com.otobix.");
    final iLatestC =
        TextEditingController(text: existing?.ios.latestVersion ?? "1.0.0");
    final iMinC = TextEditingController(
        text: existing?.ios.minSupportedVersion ?? "1.0.0");
    final iStoreC = TextEditingController(text: existing?.ios.storeUrl ?? "");
    final iNotesC =
        TextEditingController(text: existing?.ios.releaseNotes ?? "");

    void disposeAll() {
      // appKeyC.dispose();
      aPackageC.dispose();
      aLatestC.dispose();
      aMinC.dispose();
      aStoreC.dispose();
      aNotesC.dispose();
      iPackageC.dispose();
      iLatestC.dispose();
      iMinC.dispose();
      iStoreC.dispose();
      iNotesC.dispose();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        final size = MediaQuery.of(dialogCtx).size;

        // ✅ responsive: never force minWidth 600 (causes layout crash on small window)
        final maxW = (size.width * 0.92).clamp(320.0, 900.0);
        final maxH = (size.height * 0.90).clamp(320.0, 720.0);

        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW, maxHeight: maxH),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isEdit ? Icons.edit_rounded : Icons.add_rounded,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isEdit ? "Edit App Configuration" : "Add New App",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            disposeAll();
                            Navigator.of(dialogCtx).pop();
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Expanded(
                          //   child: TextField(
                          //     controller: appKeyC,
                          //     decoration: const InputDecoration(
                          //       labelText: "App Key *",
                          //       hintText: "customer, dealer, etc.",
                          //       border: OutlineInputBorder(),
                          //       filled: true,
                          //       fillColor: Colors.white,
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                            child: Obx(() => DropdownButtonFormField<String>(
                                  value: selectedAppKey.value,
                                  isExpanded: true,
                                  decoration: const InputDecoration(
                                    labelText: "App Key *",
                                    border: OutlineInputBorder(),
                                    filled: true,
                                    fillColor: Colors.white,
                                  ),
                                  items: appKeys
                                      .map((k) => DropdownMenuItem(
                                          value: k, child: Text(k)))
                                      .toList(),
                                  onChanged: (v) {
                                    if (v != null) selectedAppKey.value = v;
                                  },
                                )),
                          ),

                          const SizedBox(width: 20),

                          // ✅ FIX: SwitchListTile must NOT be unbounded in Row
                          SizedBox(
                            width: 220, // <- IMPORTANT
                            child: Obx(() => SwitchListTile.adaptive(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: AppColors.green,
                                  title: const Text(
                                    "Enable Update Dialog",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  value: enabled.value,
                                  onChanged: (v) => enabled.value = v,
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Platform Configurations",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (ctx, constraints) {
                        final isNarrow = constraints.maxWidth < 740;

                        final androidForm = _platformFormSection(
                          title: "Android",
                          icon: Icons.android_rounded,
                          color: AppColors.green,
                          packageC: aPackageC,
                          latestC: aLatestC,
                          minC: aMinC,
                          storeC: aStoreC,
                          notesC: aNotesC,
                        );

                        final iosForm = _platformFormSection(
                          title: "iOS",
                          icon: Icons.apple_rounded,
                          color: AppColors.green,
                          packageC: iPackageC,
                          latestC: iLatestC,
                          minC: iMinC,
                          storeC: iStoreC,
                          notesC: iNotesC,
                        );

                        if (isNarrow) {
                          return Column(
                            children: [
                              androidForm,
                              const SizedBox(height: 20),
                              iosForm,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: androidForm),
                            const SizedBox(width: 20),
                            Expanded(child: iosForm),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            disposeAll();
                            Navigator.of(dialogCtx).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            // ✅ validation
                            if (selectedAppKey.value.trim().isEmpty ||
                                aPackageC.text.trim().isEmpty ||
                                aLatestC.text.trim().isEmpty ||
                                aMinC.text.trim().isEmpty ||
                                iPackageC.text.trim().isEmpty ||
                                iLatestC.text.trim().isEmpty ||
                                iMinC.text.trim().isEmpty) {
                              Get.snackbar(
                                "Missing Fields",
                                "Please fill all required fields",
                                backgroundColor: Colors.orange.shade100,
                                colorText: Colors.black87,
                              );
                              return;
                            }

                            final payload = AppUpdatesModel(
                              id: existing?.id,
                              appKey: selectedAppKey.value.trim(),
                              enabled: enabled.value,
                              android: PlatformType(
                                packageName: aPackageC.text.trim(),
                                latestVersion: aLatestC.text.trim(),
                                minSupportedVersion: aMinC.text.trim(),
                                storeUrl: aStoreC.text.trim(),
                                releaseNotes: aNotesC.text.trim(),
                              ),
                              ios: PlatformType(
                                packageName: iPackageC.text.trim(),
                                latestVersion: iLatestC.text.trim(),
                                minSupportedVersion: iMinC.text.trim(),
                                storeUrl: iStoreC.text.trim(),
                                releaseNotes: iNotesC.text.trim(),
                              ),
                              updatedAt: existing?.updatedAt,
                            );

                            // ✅ IMPORTANT: your controller methods need payload
                            if (isEdit) {
                              await controller.updateAppUpdates(
                                  existing!.id!, payload);
                            } else {
                              await controller.addAppUpdates(payload);
                            }

                            disposeAll();
                            Navigator.of(dialogCtx).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                  isEdit
                                      ? Icons.save_rounded
                                      : Icons.add_rounded,
                                  size: 18),
                              const SizedBox(width: 8),
                              Text(isEdit ? "Save Changes" : "Create App"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _platformFormSection({
    required String title,
    required IconData icon,
    required Color color,
    required TextEditingController packageC,
    required TextEditingController latestC,
    required TextEditingController minC,
    required TextEditingController storeC,
    required TextEditingController notesC,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: packageC,
            decoration: const InputDecoration(
              labelText: "Package Name *",
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: latestC,
                  decoration: const InputDecoration(
                    labelText: "Latest Version *",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: minC,
                  decoration: const InputDecoration(
                    labelText: "Min Version *",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: storeC,
            decoration: const InputDecoration(
              labelText: "Store URL",
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: notesC,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: "Release Notes",
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
