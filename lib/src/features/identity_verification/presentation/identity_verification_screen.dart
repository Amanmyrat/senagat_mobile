import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:senagat_mobile/src/features/identity_verification/controller/identity_verification_controller.dart';
import 'package:senagat_mobile/src/features/identity_verification/repository/profile_repository.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/widgets/custom_app_bar.dart';
import '../../../core/globals.dart';
import '../../../core/states/stateful_data.dart';
import '../../../utils/theme/constants/app_colors.dart';
import '../../../utils/theme/constants/app_dimensions.dart';
import '../../../widgets/elevated_button_with_state.dart';

class IdentityVerificationScreen extends StatefulWidget {
  static const route = '/identity/verification';

  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<IdentityVerificationController>(
          init: IdentityVerificationController(
            ProfileRepository(apiService: ApiServices.apiService),
            _formKey,
          ),
          builder: (controller) {
            return Column(
              children: [
                CustomAppBar(),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingExtraLarge.w,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TITLE
                        Text(
                          'identity_verification'.tr,
                          style: TextStyle(
                            fontSize: 24.sp,
                            color: AppColors.blackText,
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // FORM FIELDS
                        ListView.builder(
                          itemCount: controller.controllers.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final ctrl = controller.controllers[index];
                            final title = controller.textFieldTitle[index];

                            // 1. PASSPORT NUMBER + PREFIX FIELDS
                            if (ctrl == controller.passportNumberController) {
                              return _passportNumberRow(controller);
                            }

                            // 2. DATE FIELDS (Birthdate, Issue Date)
                            if (ctrl == controller.dateOfBirthController ||
                                ctrl == controller.dateIssueController) {
                              return _datePickerField(
                                controller: controller,
                                title: title.tr,
                                ctrl: ctrl,
                              );
                            }

                            if (ctrl == controller.homePhoneController) {
                              return _homePhoneRow(controller, title, ctrl);
                            }

                            // 3. DEFAULT TEXT FIELDS
                            return _defaultField(
                              controller: controller,
                              title: title.tr,
                              ctrl: ctrl,
                            );
                          },
                        ),

                        // PDF UPLOAD
                        SizedBox(height: 16.h),
                        _pdfUpload(controller),
                      ],
                    ),
                  ),
                ),

                // SUBMIT BUTTON
                Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                  child: Opacity(
                    opacity: controller.continueEnabled ? 1.0 : 0.5,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButtonWithState(
                        isLoading: controller.status == Status.loading,
                        isError: controller.status == Status.error,
                        onPressed: controller.continueEnabled
                            ? () => controller.createOrUpdateProfile()
                            : null,
                        child: Text(
                          'confirm'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // COMPONENTS
  // --------------------------------------------------------------------------

  Widget _defaultField({
    required IdentityVerificationController controller,
    required String title,
    required TextEditingController ctrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, color: AppColors.blackText),
        ),
        SizedBox(height: AppDimensions.paddingMedium.h),
        TextFormField(
          textInputAction: TextInputAction.next,
          controller: ctrl,
          style: TextStyle(fontSize: 14.sp),
          onChanged: controller.onTextIsNotEmpty,
          decoration: _inputDecoration(controller, title),
        ),
        SizedBox(height: 22.h),
      ],
    );
  }

  // DATE FIELD WITH PICKER
  Widget _datePickerField({
    required IdentityVerificationController controller,
    required String title,
    required TextEditingController ctrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14.sp, color: AppColors.blackText),
        ),
        SizedBox(height: AppDimensions.paddingMedium.h),

        GestureDetector(
          onTap: () => controller.pickDate(context, ctrl),
          child: AbsorbPointer(
            child: TextFormField(
              controller: ctrl,
              readOnly: true,
              style: TextStyle(fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: title,
                border: const OutlineInputBorder(),
                counterText: '',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusMedium,
                  ),
                  borderSide: BorderSide(
                    color: controller.status == Status.error
                        ? AppColors.redDark
                        : AppColors.green,
                    width: 1.w,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusMedium,
                  ),
                  borderSide: BorderSide(
                    color: controller.status == Status.error
                        ? AppColors.redDark
                        : AppColors.transparent,
                  ),
                ),
                suffixIconConstraints: BoxConstraints(
                  maxWidth: 40.w,
                  maxHeight: 40.h,
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: SvgPicture.asset(AppAssets.date, width: 18.w),
                ),
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingExtraLarge.h,
                  horizontal: AppDimensions.paddingLarge.w,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 22.h),
      ],
    );
  }

  // PASSPORT NUMBER + DROPDOWNS
  Widget _passportNumberRow(IdentityVerificationController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller
                .textFieldTitle[controller.controllers.indexOf(
                  controller.passportNumberController,
                )]
                .tr,
            style: TextStyle(fontSize: 14.sp, color: AppColors.blackText),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),

          Row(
            children: [
              _dropdown(
                controller,
                items: controller.number,
                hint: 'I',
                value: controller.selectedRoman,
                onChange: (v) {
                  controller.selectedRoman = v!;
                  controller.onTextIsNotEmpty(v);
                  controller.update();
                },
              ),
              SizedBox(width: 4.w),

              _dropdown(
                controller,
                items: controller.citySelection,
                hint: 'AŞ',
                value: controller.selectedCity,
                onChange: (v) {
                  controller.selectedCity = v!;
                  controller.onTextIsNotEmpty(v);
                  controller.update();
                },
              ),
              SizedBox(width: 4.w),

              // PASSPORT NUMBER FIELD
              Expanded(
                child: TextFormField(
                  controller: controller.passportNumberController,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  onChanged: controller.onTextIsNotEmpty,
                  style: TextStyle(fontSize: 14.sp),
                  decoration: _inputDecoration(
                    controller,
                    'passport_number'.tr,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _homePhoneRow(
    IdentityVerificationController controller,
    String title,
    TextEditingController ctrl,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 22.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
           'home_phone'
                .tr,
            style: TextStyle(fontSize: 14.sp, color: AppColors.blackText),
          ),
          SizedBox(height: AppDimensions.paddingMedium.h),

          Row(
            children: [
              Container(
                padding: EdgeInsets.all(AppDimensions.paddingExtraLarge.w),
                decoration: BoxDecoration(
                  color: AppColors.inputFillBackground,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.borderRadiusMedium,
                  ),
                  border: Border.all(color: controller.status == Status.error ? AppColors.redDark :AppColors.transparent)
                ),
                child: Text('+993', style: TextStyle(fontSize: 14.sp)),
              ),
              SizedBox(width: AppDimensions.paddingSmall.w),

              Expanded(
                child: TextFormField(
                  controller: controller.homePhoneController,
                  inputFormatters: [controller.defaultMask],
                  keyboardType: TextInputType.number,
                  onChanged: controller.onTextIsNotEmpty,
                  style: TextStyle(fontSize: 14.sp),
                  decoration: _inputDecoration(
                    controller,
                    'home_phone'.tr,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
    IdentityVerificationController controller, {
    required List<String> items,
    required Function(String?) onChange,
    required String hint,
    required String? value,
  }) {
    return SizedBox(
      width: 72.w,
      child: Theme(
        data: Theme.of(
          context,
        ).copyWith(canvasColor: AppColors.inputFillBackground),
        child: DropdownButtonFormField2<String>(
          hint: Text(hint.tr, style: TextStyle(fontSize: 14.sp)),
          value: value,
          onChanged: onChange,
          items: items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: TextStyle(fontSize: 14.sp)),
                ),
              )
              .toList(),
          dropdownStyleData: DropdownStyleData(
            width: 72.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: SvgPicture.asset(AppAssets.caretDownIcon, width: 18.w),
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 17.h,
              horizontal: AppDimensions.paddingLarge.w,
            ),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  // PDF UPLOAD BUTTON
  Widget _pdfUpload(IdentityVerificationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'passport_scan'.tr,
          style: TextStyle(fontSize: 14.sp, color: AppColors.blackText),
        ),
        SizedBox(height: AppDimensions.paddingMedium.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButtonWithState(
            isLoading: false,
            isError: controller.status == Status.error,
            customStyle: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              side: BorderSide(
                color: controller.status == Status.error
                    ? AppColors.redDark
                    : AppColors.dividerColor,
              ),
              shadowColor: Colors.transparent,
            ),
            onPressed: controller.pickPdf,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'passport_scan'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.greyInactive,
                  ),
                ),
                SizedBox(width: AppDimensions.paddingMedium.w),
                if(controller.status == Status.error)...[
                  SvgPicture.asset(
                    AppAssets.X,
                    width: 24.w,
                    color:  AppColors.redDark,
                  ),
                ]else...[
                  SvgPicture.asset(
                  controller.pdfFile == null
                      ? AppAssets.pdfIcon
                      : AppAssets.checkIcon,
                  width: 24.w,
                  color: controller.pdfFile == null
                      ? AppColors.grey
                      : AppColors.green,
                ),],

              ],
            ),
          ),
        ),
      ],
    );
  }

  // INPUT DECORATION
  InputDecoration _inputDecoration(
    IdentityVerificationController controller,
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
      border: const OutlineInputBorder(),
      counterText: '',
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        borderSide: BorderSide(
          color: controller.status == Status.error
              ? AppColors.redDark
              : AppColors.green,
          width: 1.w,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        borderSide: BorderSide(
          color: controller.status == Status.error
              ? AppColors.redDark
              : AppColors.transparent,
        ),
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: AppDimensions.paddingExtraLarge.h,
        horizontal: AppDimensions.paddingLarge.w,
      ),
    );
  }
}
