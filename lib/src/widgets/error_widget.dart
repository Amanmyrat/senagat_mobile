import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/theme/constants/app_dimensions.dart';

class CustomErrorWidget extends StatelessWidget {
  final VoidCallback? onError;
  const CustomErrorWidget({Key? key, this.onError}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingExtraLarge * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'network_error'.tr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: AppDimensions.paddingSmall,
              ),
              Text(
                'error_getting_info'.tr,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: AppDimensions.paddingLarge,
              ),
              ElevatedButton(
                onPressed: onError ?? () {},
                child: Text('retry'.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
