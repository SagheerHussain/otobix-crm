import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:otobix_crm/models/cars_list_model.dart';
import 'package:otobix_crm/utils/app_colors.dart';
import 'package:otobix_crm/widgets/button_widget.dart';
import 'package:otobix_crm/widgets/toast_widget.dart';
import 'package:otobix_crm/admin/controller/admin_car_auction_timer_controller.dart';

class AdminCarAuctionTimerPage extends StatelessWidget {
  const AdminCarAuctionTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminCarAuctionTimerController());

    return Scaffold(
      backgroundColor: AppColors.grayWithOpacity1,
      appBar: AppBar(
        title: const Text(
          'Set Auction Timers',
          style: TextStyle(fontSize: 16, color: AppColors.white),
        ),
        backgroundColor: AppColors.green,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.cars.isEmpty) {
          return const Center(child: Text("No cars found."));
        }

        return ListView.builder(
          itemCount: controller.cars.length,
          itemBuilder: (context, index) {
            final car = controller.cars[index];

            return _buildCarCard(
              context: context,
              car: car,
              controller: controller,
            );
          },
        );
      }),
    );
  }

  Widget _buildCarCard({
    required BuildContext context,
    required CarsListModel car,
    required AdminCarAuctionTimerController controller,
  }) {
    return Card(
      elevation: 5,
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    car.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.green,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, _, __) => Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${car.make} ${car.model} ${car.variant}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Odometer: ${NumberFormat.decimalPattern('en_IN').format(car.odometerReadingInKms)} km',
                      ),
                      Text('Fuel: ${car.fuelType}'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            GetBuilder<AdminCarAuctionTimerController>(
              builder: (controller) {
                return Text(
                  'Auction Start Time: ${car.auctionStartTime != null ? DateFormat('yyyy-MM-dd hh:mm a').format(car.auctionStartTime!.toLocal()) : 'Not set'}',
                );
              },
            ),
            GetBuilder<AdminCarAuctionTimerController>(
              builder: (controller) {
                return Text(
                  'Auction End Time: ${car.auctionEndTime != null ? DateFormat('yyyy-MM-dd hh:mm a').format(car.auctionEndTime!.toLocal()) : 'Not set'}',
                );
              },
            ),
            GetBuilder<AdminCarAuctionTimerController>(
              builder: (controller) {
                return Text('Auction Duration: ${car.auctionDuration} hours');
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ButtonWidget(
                    text: 'Change Start Time',
                    isLoading: false.obs,
                    height: 30,
                    elevation: 5,
                    fontSize: 10,
                    backgroundColor: AppColors.grey,
                    onTap: () async {
                      final now = DateTime.now();
                      final initialAuctionDate = car.auctionStartTime != null &&
                              !car.auctionStartTime!.isBefore(now)
                          ? car.auctionStartTime!
                          : now;

                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate:
                            DateTime.now(), // only allow today or past dates
                      );

                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        );

                        if (pickedTime != null) {
                          final newStart = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );

                          if (newStart.isAfter(DateTime.now())) {
                            ToastWidget.show(
                              context: Get.context!,
                              title: 'Cannot select a future time',
                              type: ToastType.error,
                            );
                            return;
                          }

                          await controller.updateAuctionTime(
                            carId: car.id,
                            newStartTime: newStart,
                          );
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: ButtonWidget(
                    text: 'Change Duration',
                    isLoading: false.obs,
                    height: 30,
                    elevation: 5,
                    fontSize: 10,
                    onTap: () {
                      final durationController = TextEditingController(
                        text: car.auctionDuration.toString(),
                      );
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text(
                            "Change Auction Duration",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Form(
                            key: controller.formKey,
                            autovalidateMode: AutovalidateMode.always,
                            child: TextFormField(
                              controller: durationController,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                hintText: "Duration in hours",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Duration is required';
                                }
                                if (int.tryParse(value) == null) {
                                  return 'Duration must be a number';
                                }
                                return null;
                              },
                            ),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  child: ButtonWidget(
                                    text: 'Cancel',
                                    isLoading: false.obs,
                                    height: 30,
                                    elevation: 5,
                                    fontSize: 10,
                                    backgroundColor: AppColors.red,
                                    onTap: () => Get.back(),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: ButtonWidget(
                                    text: 'Save',
                                    isLoading: false.obs,
                                    height: 30,
                                    elevation: 5,
                                    fontSize: 10,
                                    onTap: () async {
                                      if (controller.formKey.currentState!
                                          .validate()) {
                                        final newDuration = int.tryParse(
                                          durationController.text.trim(),
                                        );
                                        if (newDuration != null) {
                                          await controller.updateAuctionTime(
                                            carId: car.id,
                                            newDuration: newDuration,
                                          );
                                        }
                                        Get.back();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // const SizedBox(width: 10),
                // Flexible(
                //   child: ElevatedButton.icon(
                //     onPressed: () async {
                //       final now = DateTime.now();
                //       final initialAuctionDate =
                //           car.auctionStartTime != null &&
                //                   !car.auctionStartTime!.isBefore(now)
                //               ? car.auctionStartTime!
                //               : now;

                //       final pickedDate = await showDatePicker(
                //         context: context,
                //         initialDate: DateTime.now(),
                //         firstDate: DateTime(2000),
                //         lastDate:
                //             DateTime.now(), // only allow today or past dates
                //       );

                //       if (pickedDate != null) {
                //         final pickedTime = await showTimePicker(
                //           context: context,
                //           initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                //         );

                //         if (pickedTime != null) {
                //           final newStart = DateTime(
                //             pickedDate.year,
                //             pickedDate.month,
                //             pickedDate.day,
                //             pickedTime.hour,
                //             pickedTime.minute,
                //           );

                //           if (newStart.isAfter(DateTime.now())) {
                //             ToastWidget.show(
                //               context: Get.context!,
                //               title: 'Cannot select a future time',
                //               type: ToastType.error,
                //             );
                //             return;
                //           }

                //           await controller.updateAuctionTime(
                //             carId: car.id,
                //             newStartTime: newStart.toLocal(),
                //           );
                //         }
                //       }
                //     },

                //     icon: const Icon(Icons.access_time),
                //     label: const Text(
                //       'Change Start',
                //       style: TextStyle(fontSize: 10),
                //     ),
                //   ),
                // ),
                // // const SizedBox(width: 10),
                // Flexible(
                //   child: ElevatedButton.icon(
                //     onPressed: () {
                //       final durationController = TextEditingController(
                //         text: car.auctionDuration.toString(),
                //       );
                //       showDialog(
                //         context: context,
                //         builder:
                //             (_) => AlertDialog(
                //               title: const Text("Change Auction Duration"),
                //               content: TextField(
                //                 controller: durationController,
                //                 keyboardType: TextInputType.number,
                //                 decoration: const InputDecoration(
                //                   hintText: "Duration in hours",
                //                 ),
                //               ),
                //               actions: [
                //                 TextButton(
                //                   onPressed: () async {
                //                     final newDuration = int.tryParse(
                //                       durationController.text.trim(),
                //                     );
                //                     if (newDuration != null) {
                //                       await controller.updateAuctionTime(
                //                         carId: car.id,
                //                         newDuration: newDuration,
                //                       );
                //                     }
                //                     Get.back();
                //                   },
                //                   child: const Text("Save"),
                //                 ),
                //               ],
                //             ),
                //       );
                //     },

                //     icon: const Icon(Icons.edit),
                //     label: const Text(
                //       'Change Duration',
                //       style: TextStyle(fontSize: 10),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
