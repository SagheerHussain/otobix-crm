import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminCarsListController extends GetxController {
  // search
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
}
