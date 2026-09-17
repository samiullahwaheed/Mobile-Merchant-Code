





import 'package:flutter/material.dart';
import 'package:get/get.dart';



class NavigationScreenController extends GetxController {

  RxInt selectedIndex = RxInt(0);
  bool isExpanded = false;

  final ScrollController scrollController = ScrollController();

  void toggleExpansion() {
    isExpanded = !isExpanded;
    update(); // Notifies GetBuilder to rebuild
  }

  changeIndex(int index) {
    selectedIndex.value = index;
  }








}

