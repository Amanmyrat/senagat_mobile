// ignore_for_file: constant_identifier_names
// DO NOT USE 'dartfmt' on this file for formatting

import 'package:flutter/material.dart';

import '../../core/globals.dart';

/// A utility class for getting paths for API endpoints.
/// This class has no constructor and all methods are `static`.
@immutable
class ApiEndpoint {
  const ApiEndpoint._();

  /// The base url of our REST API, to which all the requests will be sent.
  /// It is supplied at the time of building the apk or running the app:
  /// ```
  /// flutter build apk --debug --dart-define=BASE_URL=www.some_url.com
  /// ```
  /// OR
  /// ```
  /// flutter run --dart-define=BASE_URL=www.some_url.com
  /// ```
  static const baseUrl = Configs.baseUrl;

  /// Returns the path for an authentication [endpoint].
  static String auth(AuthEndpoint endpoint, {int? id, String? date}) {
    const path = '';
    switch (endpoint) {
      case AuthEndpoint.AUTHORIZE:
        return '$path/users/authorize';
      case AuthEndpoint.OTP:
        return '$path/users/otp/send';
      case AuthEndpoint.UPDATE_PROFILE:
        return '$path/users/profile/update';
      case AuthEndpoint.CHECK_CONTACTS:
        return '$path/users/check/contacts';
      case AuthEndpoint.CHANGE_ACCOUNT_TYPE:
        return '$path/users/assign/activity/services';
      case AuthEndpoint.DELETE_ACCOUNT:
        return '$path/users/delete';
      case AuthEndpoint.CHANGE_PHONE_NUMBER:
        return '$path/users/change/phone/number';
      case AuthEndpoint.CHECK_AVAILABILITY:
        return '$path/users/check/availability';
      case AuthEndpoint.CHANGE_EMAIL:
        return '$path/users/email/update';
      case AuthEndpoint.UPDATE_PROFILE_BIO:
        return '$path/users/profile/bio/update';
      case AuthEndpoint.UPDATE_PROFILE_SCHEDULE:
        return '$path/users/profile/schedule/update';
      case AuthEndpoint.GET_COUNTRIES:
        return '$path/countries';
      case AuthEndpoint.GET_CUSTOM_WORK_DAYS:
        return '$path/users/profile/custom-work-days';
      case AuthEndpoint.SET_CUSTOM_WORK_DAYS:
        return '$path/users/profile/custom-work-days';
      case AuthEndpoint.UPDATE_CUSTOM_WORK_DAYS:
        return '$path/users/profile/custom-work-days/$id';
      case AuthEndpoint.DELETE_CUSTOM_WORK_DAYS:
        return '$path/users/profile/custom-work-days/$date';
      case AuthEndpoint.QUIT_COMPANY:
        return '$path/users/profile/quit/company';
    }
  }

  /// Returns the path for an authentication [endpoint].
  static String auth2(AuthEndpoint2 endpoint, {int? id, String? date}) {
    const path = '';
    switch (endpoint) {
      case AuthEndpoint2.AUTHORIZE2:
        return '$path/users/login';
    }
  }

  static String service(ServiceEndpoint endpoint, {int? id}) {
    const path = '';
    switch (endpoint) {
      case ServiceEndpoint.CATALOG:
        return '$path/catalog';
      case ServiceEndpoint.CATALOG_SERVICES:
        return '$path/service/types/$id';
      case ServiceEndpoint.MASTER_SERVICES:
        return '$path/masters/$id/service/types';
      case ServiceEndpoint.SERVICE_MASTERS:
        return '$path/masters/services';
      case ServiceEndpoint.SERVICE_COMPANIES:
        return '$path/companies/services';
      case ServiceEndpoint.SERVICE_COMPANY_MASTERS:
        return '$path/companies/$id/services';
      case ServiceEndpoint.MASTER_FULL_DAYS:
        return '$path/masters/$id/full-days';
      case ServiceEndpoint.MASTER_AVAILABLE_SLOTS:
        return '$path/masters/$id/available-slots';
      case ServiceEndpoint.ACTIVITY_TYPES:
        return '$path/activity/types';
      case ServiceEndpoint.MY_ACTIVITY_TYPES:
        return '$path/activity/types/my';
      case ServiceEndpoint.ACTIVITY_TYPES_SERVICES:
        return '$path/activity/types/services';
      case ServiceEndpoint.MY_SERVICES:
        return '$path/service/my';
      case ServiceEndpoint.MY_MASTERS:
        return '$path/masters/my';
    }
  }

  static String booking(BookingEndpoint endpoint, {int? id, int? userId}) {
    const path = '';
    switch (endpoint) {
      case BookingEndpoint.BOOK_CREATE:
        return '$path/bookings';
      case BookingEndpoint.MY_BOOKINGS:
        return '$path/bookings/my';
      case BookingEndpoint.HISTORY:
        return '$path/bookings/history';
      case BookingEndpoint.DATE:
        return '$path/bookings/date';
      case BookingEndpoint.ACCEPT_BOOKING:
        return '$path/bookings/$id/accept';
      case BookingEndpoint.DONE_BOOKING:
        return '$path/bookings/$id/done';
      case BookingEndpoint.DECLINE_BOOKING:
        return '$path/bookings/$id/decline';
      case BookingEndpoint.RESCHEDULE_REQUEST_BOOKING:
        return '$path/bookings/$id/reschedule/request';
      case BookingEndpoint.RESCHEDULE_BOOKING:
        return '$path/bookings/$id/reschedule';
      case BookingEndpoint.DELETE_BOOKING:
        return '$path/bookings/$id/delete';
      case BookingEndpoint.SEND_REVIEW:
        return '$path/bookings/$id/reviews';
      case BookingEndpoint.GET_REVIEWS:
        return '$path/bookings/$userId/reviews';
    }
  }

  static String bookmark(BookmarkEndpoint endpoint, {int? id}) {
    const path = '';
    switch (endpoint) {
      case BookmarkEndpoint.BASE:
        return '$path/users/bookmarks';
    }
  }

  static String gallery(GalleryEndpoint endpoint, {int? id, int? userId}) {
    const path = '';
    switch (endpoint) {
      case GalleryEndpoint.UPLOAD:
        return '$path/gallery/upload';
      case GalleryEndpoint.GET:
        return '$path/gallery/$userId';
      case GalleryEndpoint.DELETE:
        return '$path/gallery/$id/delete';
    }
  }

  static String chat(ChatEndpoint endpoint, {int? id}) {
    const path = '';
    switch (endpoint) {
      case ChatEndpoint.LIST:
        return '$path/chat/list';
      case ChatEndpoint.CREATE:
        return '$path/chat/create';
      case ChatEndpoint.DELETE:
        return '$path/chat/$id/delete';
      case ChatEndpoint.TYPING:
        return '$path/chat/typing';
    }
  }

  static String messages(MessagesEndpoint endpoint, {int? id}) {
    const path = '';
    switch (endpoint) {
      case MessagesEndpoint.LIST:
        return '$path/chat/$id/messages';
      case MessagesEndpoint.CHAT_READ:
        return '$path/chat/$id/read';
      case MessagesEndpoint.SEND:
        return '$path/chat/send/message';
      case MessagesEndpoint.DELETE:
        return '$path/chat/messages/$id/delete';
      case MessagesEndpoint.MESSAGE_READ:
        return '$path/chat/messages/$id/read';
    }
  }

  static String invitations(InvitationEndpoint endpoint, {int? id}) {
    const path = '/invitations';
    switch (endpoint) {
      case InvitationEndpoint.CHECK_INVITATION:
        return '$path/check/$id/invitation';
      case InvitationEndpoint.MASTER_INVITE:
        return '$path/$id/invite';
      case InvitationEndpoint.MASTER_REMOVE:
        return '$path/$id/remove';
      case InvitationEndpoint.ACCEPT_INVITATION:
        return '$path/$id/accept';
      case InvitationEndpoint.DECLINE_INVITATION:
        return '$path/$id/decline';
    }
  }

  static String notification(NotificationEndpoint endpoint, {int? id}) {
    switch (endpoint) {
      case NotificationEndpoint.LIST:
        return '/notifications';
      case NotificationEndpoint.COUNT:
        return '/notifications/count';
    }
  }
}

/// A collection of endpoints used for authentication purposes.
enum AuthEndpoint {
  /// An endpoint for auth requests.
  AUTHORIZE,
  OTP,
  UPDATE_PROFILE,
  UPDATE_PROFILE_BIO,
  UPDATE_PROFILE_SCHEDULE,
  CHECK_CONTACTS,
  CHANGE_ACCOUNT_TYPE,
  DELETE_ACCOUNT,
  CHANGE_PHONE_NUMBER,
  CHANGE_EMAIL,
  CHECK_AVAILABILITY,
  GET_COUNTRIES,
  GET_CUSTOM_WORK_DAYS,
  SET_CUSTOM_WORK_DAYS,
  UPDATE_CUSTOM_WORK_DAYS,
  DELETE_CUSTOM_WORK_DAYS,
  QUIT_COMPANY,
}

enum AuthEndpoint2 {
  /// An endpoint for auth requests.
  AUTHORIZE2,
}

/// A collection of endpoints used for services purposes.
enum ServiceEndpoint {
  CATALOG,
  CATALOG_SERVICES,
  MASTER_SERVICES,
  SERVICE_MASTERS,
  MY_MASTERS,
  SERVICE_COMPANIES,
  SERVICE_COMPANY_MASTERS,
  MASTER_FULL_DAYS,
  MASTER_AVAILABLE_SLOTS,
  ACTIVITY_TYPES,
  MY_ACTIVITY_TYPES,
  MY_SERVICES,
  ACTIVITY_TYPES_SERVICES,
}

enum BookingEndpoint {
  BOOK_CREATE,
  MY_BOOKINGS,
  HISTORY,
  DATE,
  ACCEPT_BOOKING,
  DONE_BOOKING,
  DECLINE_BOOKING,
  RESCHEDULE_REQUEST_BOOKING,
  RESCHEDULE_BOOKING,
  DELETE_BOOKING,
  SEND_REVIEW,
  GET_REVIEWS,
}

enum BookmarkEndpoint {
  BASE,
}

enum GalleryEndpoint {
  UPLOAD,
  GET,
  DELETE,
}

enum ChatEndpoint {
  LIST,
  CREATE,
  DELETE,
  TYPING,
}

enum MessagesEndpoint {
  LIST,
  SEND,
  DELETE,
  CHAT_READ,
  MESSAGE_READ,
}

enum InvitationEndpoint {
  CHECK_INVITATION,
  MASTER_INVITE,
  MASTER_REMOVE,
  ACCEPT_INVITATION,
  DECLINE_INVITATION,
}

enum NotificationEndpoint {
  LIST,
  COUNT
}