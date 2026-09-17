import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/customer_details_screen/model/customer_details_model.dart';
import 'package:merchent/service/repository/customer_details_repository.dart';
import 'package:merchent/widget/app_log/app_print.dart';

class CustomerDetailsController extends GetxController {
  final CustomerDetailsRepository _repository = CustomerDetailsRepository();

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasReachedEnd = false.obs;
  var customerList = <CustomerData>[].obs;
  var selectedOption = "All Time".obs;
  String searchTerm = '';
  int nextPage = 1;
  final int limit = 10;

  ScrollController scrollController = ScrollController();

  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    updateSortOption(selectedOption.value);
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final pos = scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 48) {
      loadMoreData();
    }
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  String? _getPeriodFromOption(String value) {
    if (value == 'Today') return 'day';
    if (value == 'Last 7 days') return 'week';
    if (value == 'Last 30 days') return 'month';
    if (value == 'All Time') return '';
    return null;
  }

  Future<void> refreshList() async {
    await fetchCustomerDetails(
      period: _getPeriodFromOption(selectedOption.value),
      searchTerm: searchTerm.isEmpty ? null : searchTerm,
      isRefresh: true,
    );
  }

  Future<void> fetchCustomerDetails({
    String? period,
    String? searchTerm,
    bool isRefresh = false,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (hasReachedEnd.value ||
          isLoadingMore.value ||
          isLoading.value ||
          customerList.isEmpty) {
        return;
      }
      isLoadingMore.value = true;
    } else {
      nextPage = 1;
      hasReachedEnd.value = false;
      if (!isRefresh) {
        isLoading.value = true;
      }
    }

    final int requestedPage = loadMore ? nextPage : 1;

    try {
      final response = await _repository.getCustomerDetails(
        period: period,
        searchTerm: searchTerm,
        page: requestedPage,
        limit: limit,
      );
      if (response != null && response.data != null) {
        AppPrint.apiResponse(response.data, title: "response");
        final items = response.data!;
        if (loadMore) {
          customerList.addAll(items);
        } else {
          customerList.assignAll(items);
        }
        _applyPaginationState(response, items, requestedPage);
        if (!hasReachedEnd.value) {
          nextPage = requestedPage + 1;
        }
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void _applyPaginationState(
    CustomerDetailsModel response,
    List<CustomerData> items,
    int requestedPage,
  ) {
    final p = response.pagination;
    if (p != null && p.totalPage != null && p.totalPage! > 0) {
      final current = p.page ?? requestedPage;
      hasReachedEnd.value = current >= p.totalPage!;
    } else {
      hasReachedEnd.value = items.length < limit;
    }
  }

  void onSearchChanged(String value) {
    _searchDebounce?.cancel();
    searchTerm = value.trim();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      final period = _getPeriodFromOption(selectedOption.value);
      fetchCustomerDetails(
        period: period,
        searchTerm: searchTerm.isEmpty ? null : searchTerm,
      );
    });
  }

  void updateSortOption(String value) {
    selectedOption.value = value;
    final period = _getPeriodFromOption(value);
    AppPrint.apiResponse(period, title: "period");

    fetchCustomerDetails(
      period: period,
      searchTerm: searchTerm.isEmpty ? null : searchTerm,
    );
  }

  void loadMoreData() {
    fetchCustomerDetails(
      period: _getPeriodFromOption(selectedOption.value),
      searchTerm: searchTerm.isEmpty ? null : searchTerm,
      loadMore: true,
    );
  }
}
