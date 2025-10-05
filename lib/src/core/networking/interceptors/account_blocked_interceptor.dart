// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/typedefs.dart';

// Endpoints
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';
import '../api_endpoint.dart';

class AccountBlockedInterceptor extends Interceptor {
  /// An instance of [Dio] for network requests
  final Dio _dio;

  AccountBlockedInterceptor({required Dio dioClient}) : _dio = dioClient;

  /// The name of the exception on which this interceptor is triggered.
  // ignore: non_constant_identifier_names
  String get AccountBlockedException => 'ACCOUNT_BLOCKED';

  ///
  @override
  Future<void> onError(
    DioError dioError,
    ErrorInterceptorHandler handler,
  ) async {
    if (dioError.response != null) {
      final responseData = dioError.response!.data;
      if (responseData != null) {
        // final headers = responseData['headers'] as JSON;
        if (responseData is! String && responseData.containsKey('code')) {
          // Check error type to be token expired error
          final code = responseData['code'] as String;

          if (code == AccountBlockedException) {
            final context = Get.context;
            if (context != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async {
                      return false;
                    },
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Dialog(
                        backgroundColor: AppColors.inputFillBackground,
                        insetPadding: EdgeInsets.all(
                          AppDimensions.paddingExtraLarge.w,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(
                                AppDimensions.paddingExtraLarge.w,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'account_blocked'.tr,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: AppFonts.secondaryFont,
                                      fontSize: 22.sp,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'account_blocked_description'.tr,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontSize: 16.sp,
                                      fontFamily: AppFonts.secondaryFont,
                                    ),
                                  ),
                                  SizedBox(height: 20.h),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.blue,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.w,
                                        vertical: 12.h,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      Uri smsUri = Uri(
                                        scheme: "tel",
                                        path: '+99300000000',
                                      );
                                      await launchUrl(smsUri);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.phone,
                                          color: AppColors.white,
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          'call_administrator'.tr,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 18.sp,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ), // Prevents dialog dismissal when tapping outside
                      ),
                    ),
                  );
                },
              );
            }
          }
        }
      }
    }

    // if not token expired error, forward it to try catch in dio_service
    return super.onError(dioError, handler);
  }
}
