import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchent/screen/sell_details_screen/model/sell_details_model.dart';
import 'package:merchent/service/repository/sell_details_repository.dart';
import 'package:merchent/widget/app_log/app_print.dart' show AppPrint;

class SellDetailsController extends GetxController {
  final SellDetailsRepository _repository = SellDetailsRepository();

  var selectedOption = "All Time".obs;
  int nextPage = 1;
  final int limit = 10;
  ScrollController scrollController = ScrollController();

  var customerList = <SellDetailsData>[].obs;

  String searchTerm = '';

  Timer? _searchDebounce;

  var isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasReachedEnd = false.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateSortOption(selectedOption.value);
    scrollController.addListener(_onScroll);
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    final pos = scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 48) {
      loadMoreData();
    }
  }

  String? _getPeriodFromOption(String value) {
    if (value == 'Today') return 'day';
    if (value == 'Last 7 days') return 'week';
    if (value == 'Last 30 days') return 'month';
    if (value == 'All Time') return '';
    return null;
  }

  Future<void> refreshList() async {
    await fetchSellDetails(
      period: _getPeriodFromOption(selectedOption.value),
      searchTerm: searchTerm.isEmpty ? null : searchTerm,
      isRefresh: true,
    );
  }

  void updateSortOption(String value) {
    selectedOption.value = value;
    final period = _getPeriodFromOption(value);
    AppPrint.apiResponse(period, title: "period");

    fetchSellDetails(
      period: period,
      searchTerm: searchTerm.isEmpty ? null : searchTerm,
    );
  }

  void onSearchChanged(String value) {
    _searchDebounce?.cancel();
    searchTerm = value.trim();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      final period = _getPeriodFromOption(selectedOption.value);
      fetchSellDetails(
        period: period,
        searchTerm: searchTerm.isEmpty ? null : searchTerm,
      );
    });
  }

  Future<void> fetchSellDetails({
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
      errorMessage.value = '';

      final response = await _repository.getSellDetails(
        page: requestedPage,
        limit: limit,
        period: period,
        searchTerm: searchTerm,
      );

      if (response != null && response.success) {
        final items = response.data;
        if (loadMore) {
          customerList.addAll(items);
        } else {
          customerList.assignAll(items);
        }
        _applyPaginationState(response, items, requestedPage);
        if (!hasReachedEnd.value) {
          nextPage = requestedPage + 1;
        }
      } else {
        if (!loadMore) {
          errorMessage.value =
              _repository.errorMessage ?? 'Failed to load data';
        }
      }
    } catch (e) {
      if (!loadMore) {
        errorMessage.value = 'An error occurred: $e';
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void _applyPaginationState(
    SellDetailsResponse response,
    List<SellDetailsData> items,
    int requestedPage,
  ) {
    final p = response.pagination;
    if (p.totalPage > 0) {
      final current = p.page > 0 ? p.page : requestedPage;
      hasReachedEnd.value = current >= p.totalPage;
    } else {
      hasReachedEnd.value = items.length < limit;
    }
  }

  void loadMoreData() {
    fetchSellDetails(
      period: _getPeriodFromOption(selectedOption.value),
      searchTerm: searchTerm.isEmpty ? null : searchTerm,
      loadMore: true,
    );
  }
}
