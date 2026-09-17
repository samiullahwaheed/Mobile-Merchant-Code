class SellDetailsResponse {
  final bool success;
  final List<SellDetailsData> data;
  final SellDetailsPagination pagination;

  SellDetailsResponse({
    required this.success,
    required this.data,
    required this.pagination,
  });

  factory SellDetailsResponse.fromJson(Map<String, dynamic> json) {
    return SellDetailsResponse(
      success: json['success'] ?? false,
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    SellDetailsData.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      pagination: SellDetailsPagination.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class SellDetailsData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profile;
  final int totalTransactions;
  final double totalPointsEarned;
  final double totalPointsRedeemed;
  final double totalBilled;
  final double finalBilled;
  final String cardIds;
  final String status;

  SellDetailsData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profile,
    required this.totalTransactions,
    required this.totalPointsEarned,
    required this.totalPointsRedeemed,
    required this.totalBilled,
    required this.finalBilled,
    required this.cardIds,
    required this.status,
  });

  factory SellDetailsData.fromJson(Map<String, dynamic> json) {
    return SellDetailsData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profile: json['profile'] ?? '',
      totalTransactions: json['totalTransactions'] ?? 0,
      totalPointsEarned: (json['totalPointsEarned'] ?? 0).toDouble(),
      totalPointsRedeemed: (json['totalPointsRedeemed'] ?? 0).toDouble(),
      totalBilled: (json['totalBilled'] ?? 0).toDouble(),
      finalBilled: (json['finalBilled'] ?? 0).toDouble(),
      cardIds: json['cardIds'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile': profile,
      'totalTransactions': totalTransactions,
      'totalPointsEarned': totalPointsEarned,
      'totalPointsRedeemed': totalPointsRedeemed,
      'totalBilled': totalBilled,
      'finalBilled': finalBilled,
      'cardIds': cardIds,
      'status': status,
    };
  }
}

class SellDetailsPagination {
  final int total;
  final int limit;
  final int page;
  final int totalPage;

  SellDetailsPagination({
    required this.total,
    required this.limit,
    required this.page,
    required this.totalPage,
  });

  factory SellDetailsPagination.fromJson(Map<String, dynamic> json) {
    return SellDetailsPagination(
      total: json['total'] ?? 0,
      limit: json['limit'] ?? 10,
      page: json['page'] ?? 1,
      totalPage: json['totalPage'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'page': page,
      'totalPage': totalPage,
    };
  }
}
