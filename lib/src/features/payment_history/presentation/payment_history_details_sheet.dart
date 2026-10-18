import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/pay/model/paymet_history_model.dart';
import 'package:senagat_mobile/src/features/payment_history/payment_history_format.dart';
import 'package:senagat_mobile/src/features/payment_history/payment_invoice.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_fonts.dart';

Future<void> showPaymentHistoryDetails(PaymentHistoryModel item) {
  return showModalBottomSheet<void>(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (_) => PaymentHistoryDetailsSheet(item: item),
  );
}

class PaymentHistoryDetailsSheet extends StatefulWidget {
  final PaymentHistoryModel item;

  const PaymentHistoryDetailsSheet({super.key, required this.item});

  @override
  State<PaymentHistoryDetailsSheet> createState() =>
      _PaymentHistoryDetailsSheetState();
}

class _PaymentHistoryDetailsSheetState extends State<PaymentHistoryDetailsSheet> {
  bool _checking = true;
  bool _downloading = false;
  String? _location;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final location = await savedInvoiceLocation(widget.item);
    if (!mounted) return;
    setState(() {
      _location = location;
      _checking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final statusColor = _statusColor(item.status);
    final title = paymentHistoryTitle(item.type).tr;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewPaddingOf(context).bottom),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.dividerColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            SizedBox(height: 20.h),
            Image.asset(AppAssets.senagatIcon, width: 72.w, height: 72.w),
            SizedBox(height: 8.h),
            Text(
              r'senagat_bank'.tr,
              style: TextStyle(fontSize: 16.sp, color: AppColors.blackText),
            ),
            SizedBox(height: 20.h),
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(_statusIcon(item.status), color: statusColor, size: 36.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              _statusLabel(item.status),
              style: TextStyle(
                fontSize: 18.sp,
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${item.amount} TMT',
              style: TextStyle(fontSize: 28.sp, color: AppColors.blackText),
            ),
            SizedBox(height: 20.h),
            _detailRow(
              r'payment_service'.tr,
              title,
              trailing: SizedBox(
                width: 44.w,
                height: 44.w,
                child: Image.asset(
                  paymentHistoryIcon(item.type),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            _detailRow(r'payment_number'.tr, paymentHistoryTarget(item)),
            _detailRow(r'payment_date'.tr, item.createdAt),
            _detailRow(r'receipt_number'.tr, '${item.id}'),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight.h,
              child: ElevatedButton(
                onPressed: _checking || _downloading
                    ? null
                    : (_location == null ? _download : _view),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.green,
                  disabledBackgroundColor: AppColors.green.withValues(alpha: 0.6),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.borderRadiusMedium.r,
                    ),
                  ),
                ),
                child: _checking || _downloading
                    ? SizedBox(
                        width: 22.w,
                        height: 22.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _location == null
                            ? r'download_invoice'.tr
                            : r'view_invoice'.tr,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontFamily: AppFonts.primaryFont,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
            if (_location != null) ...[
              SizedBox(height: 10.h),
              Text(
                r'invoice_saved'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: AppColors.grey),
              ),
            ],
            if (_error != null) ...[
              SizedBox(height: 10.h),
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: AppColors.redDark),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _download() async {
    setState(() {
      _downloading = true;
      _error = null;
    });
    try {
      final location = await savePaymentInvoice(widget.item);
      if (!mounted) return;
      setState(() => _location = location);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = r'invoice_download_failed'.tr);
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  Future<void> _view() async {
    final location = _location;
    if (location == null) return;
    try {
      await openPaymentInvoice(location);
    } catch (_) {
      await forgetInvoice(widget.item.id);
      if (!mounted) return;
      setState(() {
        _location = null;
        _error = r'invoice_open_failed'.tr;
      });
    }
  }
}

Widget _detailRow(String label, String value, {Widget? trailing}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10.h),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12.sp, color: AppColors.grey),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(fontSize: 14.sp, color: AppColors.blackText),
              ),
            ],
          ),
        ),
        if (trailing != null) trailing,
      ],
    ),
  );
}

String _statusLabel(String status) {
  if (status == 'confirmed') return 'payment_approved'.tr;
  return status.tr;
}

Color _statusColor(String status) {
  switch (status) {
    case 'confirmed':
      return AppColors.green;
    case 'pending':
      return AppColors.orange;
    case 'failed':
      return AppColors.redDark;
    default:
      return AppColors.grey;
  }
}

IconData _statusIcon(String status) {
  switch (status) {
    case 'confirmed':
      return Icons.check_rounded;
    case 'pending':
      return Icons.schedule_rounded;
    case 'failed':
      return Icons.close_rounded;
    default:
      return Icons.info_outline_rounded;
  }
}
