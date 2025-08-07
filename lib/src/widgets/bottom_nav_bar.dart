import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';

class BottomNavBarItem {
  final String icon;
  final String label;

  BottomNavBarItem({required this.icon, required this.label});
}

class BottomNavBar extends StatefulWidget {
  final List<BottomNavBarItem> children;
  int currentIndex;
  final Color? backgroundColor;
  Function(int)? onTap;

  BottomNavBar({
    super.key,
    required this.children,
    required this.currentIndex,
    this.backgroundColor,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
        border: Border.all(color: const Color(0xffEEF2ED), width: 1.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          widget.children.length,
          (index) => NavBarItem(
            label: widget.children[index].label,
            index: index,
            item: widget.children[index],
            selected: widget.currentIndex == index,
            onTap: () {
              setState(() {
                widget.currentIndex = index;
                widget.onTap!(widget.currentIndex);
              });
            },
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final BottomNavBarItem item;
  final int index;
  bool selected;
  final Function onTap;
  final Color? backgroundColor;
  final String label;
  NavBarItem({
    super.key,
    required this.item,
    this.selected = false,
    required this.onTap,
    this.backgroundColor,
    required this.index,
    required this.label,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(
              widget.item.icon,
              color: widget.selected ? AppColors.black : AppColors.greyInactive,
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(height: 5.h),
            Text(
              widget.label,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
