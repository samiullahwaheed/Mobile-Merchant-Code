class NotificationModel {
  bool? success;
  String? message;
  Pagination? pagination;
  NotificationData? data;

  NotificationModel({this.success, this.message, this.pagination, this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    data = json['data'] != null
        ? NotificationData.fromJson(json['data'])
        : null;
  }
}

class Pagination {
  int? total;
  int? limit;
  int? page;
  int? totalPage;

  Pagination({this.total, this.limit, this.page, this.totalPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    limit = json['limit'];
    page = json['page'];
    totalPage = json['totalPage'];
  }
}

class NotificationData {
  List<Notifications>? notifications;
  int? unreadCount;

  NotificationData({this.notifications, this.unreadCount});

  NotificationData.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
    unreadCount = json['unreadCount'];
  }
}

class Notifications {
  String? sId;
  String? userId;
  String? title;
  String? body;
  String? type;
  bool? isRead;
  List<dynamic>? attachments;
  Channel? channel;
  int? iV;
  String? createdAt;
  String? updatedAt;
  String? timeAgo;

  Notifications({
    this.sId,
    this.userId,
    this.title,
    this.body,
    this.type,
    this.isRead,
    this.attachments,
    this.channel,
    this.iV,
    this.createdAt,
    this.updatedAt,
    this.timeAgo,
  });

  Notifications.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    isRead = json['isRead'];
    if (json['attachments'] != null) {
      attachments = <dynamic>[];
      json['attachments'].forEach((v) {
        attachments!.add(v);
      });
    }
    channel = json['channel'] != null
        ? Channel.fromJson(json['channel'])
        : null;
    iV = json['__v'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    timeAgo = json['timeAgo'];
  }
}

class Channel {
  bool? socket;
  bool? push;

  Channel({this.socket, this.push});

  Channel.fromJson(Map<String, dynamic> json) {
    socket = json['socket'];
    push = json['push'];
  }
}
