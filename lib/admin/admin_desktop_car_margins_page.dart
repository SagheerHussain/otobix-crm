import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/admin/controller/admin_car_margins_controller.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';

class AdminDesktopCarMarginsPage extends StatelessWidget {
  AdminDesktopCarMarginsPage({super.key});

  final AdminCarMarginsController controller =
      Get.put(AdminCarMarginsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.marginsList.isEmpty) {
          return Center(
            child: Text(
              'No margin data found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          );
        }

        final marginData = controller.marginsList[0];
        final fixedMargin = controller.fixedMargin.value;
        final variableRanges = controller.variableRanges;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildScreenTitle(),
                  FloatingActionButton.extended(
                    onPressed: () {
                      _showUpdateDialog(context);
                    },
                    icon: const Icon(Icons.edit, size: 20),
                    label: const Text('Update Margins'),
                    backgroundColor: AppColors.green.withOpacity(0.8),
                    foregroundColor: AppColors.white,
                    elevation: 2,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Info Card
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blue.shade100, width: 1),
                ),
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: Colors.blue[700], size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Fixed margin is applied to all vehicles. Variable margins are applied based on the vehicle price discovery range.',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Fixed Margin Card
              SizedBox(
                width: 600,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.percent,
                                color: Colors.blue[700], size: 25),
                            const SizedBox(width: 12),
                            Text(
                              'Fixed Margin',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${fixedMargin.toStringAsFixed(2)}%',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Padding(
                          padding: const EdgeInsets.only(left: 35),
                          child: Text(
                            'This margin is applied to all vehicle prices regardless of their value.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Variable Margins Section
              Text(
                'Variable Margins by Price Discovery Range',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Different margin percentages applied based on vehicle price discoveries',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10),

              // Variable Margins Grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: variableRanges.length,
                  itemBuilder: (context, index) {
                    final range = variableRanges[index];
                    final min = range['min']?.toDouble() ?? 0;
                    final max = range['max']?.toDouble() ?? 0;
                    final margin = range['margin']?.toDouble() ?? 0;

                    return _buildMarginRangeCard(
                      minPrice: min,
                      maxPrice: max,
                      margin: margin,
                      index: index,
                    );
                  },
                ),
              ),

              // Last Updated Info
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.update, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Last updated: ${_formatDate(marginData['updatedAt'] ?? '')}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown date';
    }
  }

  void _showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UpdateMarginsDialog(
        fixedMargin: controller.fixedMargin.value,
        variableRanges: List.from(controller.variableRanges),
      ),
    );
  }

  // Title
  Widget _buildScreenTitle() {
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Car Pricing Margins",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Manage car pricing margins",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildMarginRangeCard({
  required double minPrice,
  required double maxPrice,
  required double margin,
  required int index,
}) {
  final colors = [
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.orange.shade50,
    Colors.purple.shade50,
    Colors.red.shade50,
    Colors.teal.shade50,
  ];

  final borderColors = [
    Colors.blue.shade300,
    Colors.green.shade300,
    Colors.orange.shade300,
    Colors.purple.shade300,
    Colors.red.shade300,
    Colors.teal.shade300,
  ];

  final colorIndex = index % colors.length;

  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: borderColors[colorIndex], width: 2),
    ),
    child: Container(
      decoration: BoxDecoration(
        color: colors[colorIndex],
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Range ${index + 1}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: borderColors[colorIndex].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${margin.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: borderColors[colorIndex],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Price Range',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Center(
                    child: Text(
                      maxPrice == 999999
                          ? '${minPrice.toStringAsFixed(0)}+ Lacs'
                          : '${minPrice.toStringAsFixed(0)} - ${maxPrice.toStringAsFixed(0)} Lacs',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: margin / 20, // Assuming max margin is 20%
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(borderColors[colorIndex]),
            minHeight: 6,
            borderRadius: BorderRadius.circular(3),
          ),
        ],
      ),
    ),
  );
}

class UpdateMarginsDialog extends StatefulWidget {
  final double fixedMargin;
  final List<Map<String, dynamic>> variableRanges;

  const UpdateMarginsDialog({
    super.key,
    required this.fixedMargin,
    required this.variableRanges,
  });

  @override
  State<UpdateMarginsDialog> createState() => _UpdateMarginsDialogState();
}

class _UpdateMarginsDialogState extends State<UpdateMarginsDialog> {
  late TextEditingController _fixedMarginController;
  late List<Map<String, TextEditingController>> _rangeControllers;
  final AdminCarMarginsController _controller =
      Get.find<AdminCarMarginsController>();
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fixedMarginController = TextEditingController(
      text: widget.fixedMargin.toStringAsFixed(2),
    );

    // Only load existing ranges, NO empty ranges initially
    _rangeControllers = widget.variableRanges.map((range) {
      return {
        'min': TextEditingController(text: (range['min'] ?? 0).toString()),
        'max': TextEditingController(text: (range['max'] ?? 0).toString()),
        'margin':
            TextEditingController(text: (range['margin'] ?? 0).toString()),
      };
    }).toList();
  }

  @override
  void dispose() {
    _fixedMarginController.dispose();
    _scrollController.dispose();
    for (var controllers in _rangeControllers) {
      controllers['min']?.dispose();
      controllers['max']?.dispose();
      controllers['margin']?.dispose();
    }
    super.dispose();
  }

  void _addEmptyRange() {
    final lastRange =
        _rangeControllers.isNotEmpty ? _rangeControllers.last : null;
    final lastMax =
        lastRange != null ? double.tryParse(lastRange['max']!.text) : null;

    setState(() {
      _rangeControllers.add({
        'min': TextEditingController(text: lastMax?.toStringAsFixed(0) ?? '0'),
        'max': TextEditingController(),
        'margin': TextEditingController(),
      });
    });

    // Scroll to bottom after adding new range
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeLastEmptyRange() {
    // Only remove if there's at least one empty range (beyond existing ranges)
    if (_rangeControllers.length > widget.variableRanges.length) {
      setState(() {
        final lastControllers = _rangeControllers.removeLast();
        lastControllers['min']?.dispose();
        lastControllers['max']?.dispose();
        lastControllers['margin']?.dispose();
      });
    }
  }

  List<Map<String, TextEditingController>> _getNonEmptyRanges() {
    return _rangeControllers.where((controllers) {
      final minText = controllers['min']?.text ?? '';
      final maxText = controllers['max']?.text ?? '';
      final marginText = controllers['margin']?.text ?? '';
      return minText.isNotEmpty && maxText.isNotEmpty && marginText.isNotEmpty;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Obx(() {
        return Container(
          width: 800,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.edit,
                    color: AppColors.green,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Update Car Margins',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 24),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),

              // Fixed Margin Section
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fixed Margin (%)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _fixedMarginController,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: 'Enter fixed margin percentage',
                          prefixIcon: const Icon(Icons.percent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter fixed margin';
                          }
                          final val = double.tryParse(value);
                          if (val == null || val < 0) {
                            return 'Please enter a valid positive number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Applied to all vehicles regardless of price',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Variable Margins Section
              Text(
                'Variable Margins by Price Range',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 10),

              // Scrollable Variable Margins
              Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 10,
                              childAspectRatio: 2.5,
                            ),
                            itemCount: _rangeControllers.length,
                            itemBuilder: (context, index) {
                              final controllers = _rangeControllers[index];
                              final isExistingRange =
                                  index < widget.variableRanges.length;

                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: isExistingRange
                                        ? Colors.green.shade300
                                        : Colors.blue.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isExistingRange
                                                  ? Colors.green.shade100
                                                  : Colors.blue.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              'Range ${index + 1}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: isExistingRange
                                                    ? Colors.green[800]
                                                    : Colors.blue[800],
                                              ),
                                            ),
                                          ),
                                          if (isExistingRange)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.green[50],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color:
                                                        Colors.green.shade200),
                                              ),
                                              child: Text(
                                                'Existing',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.green[700],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          if (!isExistingRange)
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.blue[50],
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color:
                                                        Colors.blue.shade200),
                                              ),
                                              child: Text(
                                                'New',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.blue[700],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              controller: controllers['min'],
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              enabled: index > 0 ? false : true,
                                              decoration: InputDecoration(
                                                labelText: 'Min (Lacs)',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Required';
                                                }
                                                final val =
                                                    double.tryParse(value);
                                                if (val == null || val < 0) {
                                                  return 'Invalid';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: TextFormField(
                                              controller: controllers['max'],
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              decoration: InputDecoration(
                                                labelText: 'Max (Lacs)',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Required';
                                                }
                                                final val =
                                                    double.tryParse(value);
                                                if (val == null || val < 0) {
                                                  return 'Invalid';
                                                }
                                                final minVal = double.tryParse(
                                                    controllers['min']?.text ??
                                                        '0');
                                                if (minVal != null &&
                                                    val <= minVal) {
                                                  return '> Min';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: TextFormField(
                                              controller: controllers['margin'],
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              decoration: InputDecoration(
                                                labelText: 'Margin (%)',
                                                suffixText: '%',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Required';
                                                }
                                                final val =
                                                    double.tryParse(value);
                                                if (val == null || val < 0) {
                                                  return 'Invalid';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                          // Add/Remove Buttons
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _addEmptyRange,
                                  icon: const Icon(Icons.add, size: 18),
                                  label: const Text('Add New Range'),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side:
                                        BorderSide(color: Colors.blue.shade300),
                                  ),
                                ),
                                if (_rangeControllers.length >
                                    widget.variableRanges.length)
                                  const SizedBox(width: 16),
                                if (_rangeControllers.length >
                                    widget.variableRanges.length)
                                  OutlinedButton.icon(
                                    onPressed: _removeLastEmptyRange,
                                    icon: const Icon(Icons.remove, size: 18),
                                    label: const Text('Remove Last'),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      side: BorderSide(
                                          color: Colors.red.shade300),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _controller.isUpdating.value
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              final nonEmptyRanges = _getNonEmptyRanges();
                              if (nonEmptyRanges.isEmpty) {
                                ToastWidget.show(
                                  context: context,
                                  title: 'Error',
                                  subtitle:
                                      'Please add at least one variable range',
                                  type: ToastType.error,
                                );
                                return;
                              }

                              _controller.processUpdate(
                                fixedMarginController: _fixedMarginController,
                                rangeControllers: nonEmptyRanges,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _controller.isUpdating.value
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Update Margins',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
