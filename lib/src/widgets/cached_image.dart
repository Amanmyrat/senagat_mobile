import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CachingImage extends StatelessWidget {
  final String? imageUrl;
  final BoxFit? fit;
  final Color? color;

  const CachingImage(this.imageUrl, {Key? key, this.fit, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // const assetLogo =
    //     // ignore: dead_code
    //     true ? AppAssets.lightModeLogo : 'assets/images/dark_mode_logo.png';
    return imageUrl == null
        ? Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              color: Colors.grey,
            ),
          )
        : CachedNetworkImage(
            fit: fit ?? BoxFit.contain,
            imageUrl: imageUrl!,
            width: double.infinity,
            color: color,
            errorWidget: (context, _, __) => Padding(
              padding: EdgeInsets.all(10.w),
              child: Container(
                color: Colors.grey,
              ),
            ),
            progressIndicatorBuilder: (context, _, progress) => Padding(
              padding: EdgeInsets.all(10.w),
              child: Center(
                child: Container(
                  color: Colors.grey,
                ),
              ),
            ),
          );
  }
}
