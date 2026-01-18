import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:senagat_mobile/src/utils/services/bank_service/bank_services.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/widgets/elevated_button_with_state.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../utils/theme/constants/app_fonts.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final ResendCodeRequest? resendCodeRequest;
  final BankService? bankService;
  final String? phoneNumber;

  const PaymentConfirmationScreen({
    super.key,
    this.resendCodeRequest,
    this.bankService,
    this.phoneNumber,
  });

  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState
    extends State<PaymentConfirmationScreen> {
  final TextEditingController confirmationTextController =
  TextEditingController();

  String confirmText = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency, // ← critical
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop('');
          return false;
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              right: 24.w,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r'confirmation'.tr,
                    style: TextStyle(
                      fontSize: 23.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackText,
                    ),
                  ),
                  SizedBox(height: 8.h),

                  Text(
                    '${r'code_was_sent_to'.tr} ${widget.phoneNumber}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.greyInactive,
                      fontFamily: AppFonts.secondaryFont,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  PinCodeTextField(
                    length: 5,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    cursorColor: AppColors.green,
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    controller: confirmationTextController,
                    appContext: context,
                    onChanged: (value) {
                      setState(() => confirmText = value);
                    },
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius:
                      BorderRadius.circular(
                          AppDimensions.borderRadiusMedium.r),
                      activeColor: AppColors.green,
                      selectedColor: AppColors.green,
                      inactiveColor: AppColors.inputFillBackground,
                      activeFillColor:
                      AppColors.inputFillBackground,
                      selectedFillColor:
                      AppColors.inputFillBackground,
                      inactiveFillColor:
                      AppColors.inputFillBackground,
                    ),
                    textStyle: TextStyle(
                      color: AppColors.blackText,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    autoDisposeControllers: false,
                  ),

                  SizedBox(height: 24.h),

                  Opacity(
                    opacity:
                    confirmText.length != 5 || isLoading
                        ? 0.5
                        : 1,
                    child: SizedBox(
                      height: 64.h,
                      width: double.infinity,
                      child: ElevatedButtonWithState(
                        isLoading: isLoading,
                        isError: false,
                        onPressed:
                        confirmText.length != 5 || isLoading
                            ? null
                            : () {
                          Navigator.of(context).pop(
                            confirmationTextController.text,
                          );
                        },
                        child: Text(
                          r'confirmation'.tr,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    confirmationTextController.dispose();
    super.dispose();
  }
}

