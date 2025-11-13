import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otobix_crm/models/cars_list_model.dart';

class AdminCarsListController extends GetxController {
  // search
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  // Search car
  List<CarsListModel> searchCar({required List<CarsListModel> carsList}) {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return carsList;

    return carsList.where((car) {
      final appointmentId = car.appointmentId.toString().toLowerCase();

      return appointmentId.contains(query);
    }).toList();
  }
}
