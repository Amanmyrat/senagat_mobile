import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:senagat_mobile/src/utils/services/bank_service/bank_services.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final ResendCodeRequest? resendCodeRequest;
  final BankService? bankService;

  const PaymentConfirmationScreen({
    Key? key,
    this.resendCodeRequest,
    this.bankService,
  }) : super(key: key);

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  TextEditingController confirmationTextController = TextEditingController();
  String confirmText = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop('');
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          title: Text(r'payment_confirmation'.tr),
          backgroundColor: AppColors.green,
          foregroundColor: AppColors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop('');
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          r'short_term_code'.tr,
                          style: TextStyle(
                            color: AppColors.blackText,
                            fontSize: 23.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        r'enter_code_to_continue'.tr,
                        style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                PinCodeTextField(
                  length: 5,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  cursorColor: AppColors.green,
                  cursorWidth: 3,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10.w),
                    fieldHeight: 50.w,
                    fieldWidth: 50.w,
                    selectedFillColor: AppColors.white,
                    selectedColor: AppColors.green,
                    activeColor: AppColors.green,
                    activeFillColor: AppColors.green,
                    inactiveColor: AppColors.lightGrey,
                    inactiveFillColor: AppColors.lightGrey,
                  ),
                  textStyle: TextStyle(
                    color: AppColors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  controller: confirmationTextController,
                  appContext: context,
                  autoDisposeControllers: false,
                  onChanged: (value) {
                    setState(() {
                      confirmText = value;
                    });
                  },
                ),
                Container(
                  height: 45.h,
                  width: double.infinity,
                  margin: EdgeInsets.only(top: 15.h),
                  child: ElevatedButton(
                    onPressed: (confirmText.length != 5 || isLoading)
                        ? null
                        : () => {
                              Navigator.of(context).pop(confirmationTextController.text)
                            },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        (confirmText.length == 5 && !isLoading) 
                            ? AppColors.green 
                            : AppColors.lightGrey,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.w),
                        ),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              color: AppColors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            r'continue'.tr,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 30.h),
                // Uncomment if you want to add resend functionality
                // Container(
                //   height: 45.h,
                //   width: double.infinity,
                //   margin: EdgeInsets.symmetric(vertical: 15.h),
                //   child: ElevatedButton(
                //     onPressed: isLoading ? null : () => _reSendVerification(),
                //     style: ButtonStyle(
                //       backgroundColor: MaterialStateProperty.all<Color>(AppColors.lightGrey),
                //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                //         RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(13.w),
                //         ),
                //       ),
                //     ),
                //     child: Text(
                //       r'resend'.tr,
                //       style: TextStyle(
                //         color: AppColors.darkText,
                //         fontSize: 15.sp,
                //         fontWeight: FontWeight.w700,
                //       ),
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      r'enter_code'.tr,
                      style: TextStyle(
                        color: AppColors.blackText,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Uncomment if you want to add resend functionality
  // void _reSendVerification() async {
  //   if (widget.resendCodeRequest == null || widget.bankService == null) return;
  //   
  //   setState(() {
  //     isLoading = true;
  //   });
  //   
  //   try {
  //     final resentCodeRes = await widget.bankService!.step3ResendCode(widget.resendCodeRequest!);
  //     
  //     if (resentCodeRes.resendAttemptsLeft > 0) {
  //       setState(() {
  //         confirmText = '';
  //         confirmationTextController.text = '';
  //       });
  //       
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           duration: const Duration(seconds: 2),
  //           backgroundColor: AppColors.primary,
  //           content: Text(r'code_resent'.tr),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           duration: const Duration(seconds: 2),
  //           backgroundColor: Colors.red,
  //           content: Text(r'error_occurred'.tr),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         duration: const Duration(seconds: 2),
  //         backgroundColor: Colors.red,
  //         content: Text(r'error_occurred'.tr),
  //       ),
  //     );
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

  @override
  void dispose() {
    confirmationTextController.dispose();
    super.dispose();
  }
}
