import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_dimensions.dart';

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
      height: 68,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
        border: Border.all(color: AppColors.dividerColor, width: 2.w),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium.r)
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16.w,),
            decoration: BoxDecoration(
              color: widget.selected ? AppColors.lightGrey : Colors.transparent,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              children: [
                SvgPicture.asset(widget.item.icon, width: 20, color: widget.selected ? AppColors.green : AppColors.greyInactive,),
                SizedBox(width: 4.w,),
                Text(
                  widget.selected ? widget.label : '',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400, color: widget.selected ? AppColors.green : AppColors.greyInactive,),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
