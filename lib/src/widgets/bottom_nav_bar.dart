import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senagat_mobile/src/utils/constants/app_assets.dart';
import 'package:senagat_mobile/src/utils/theme/constants/app_colors.dart';

class BottomNavBarItem {
  final String icon;

  BottomNavBarItem({
    required this.icon,
  });
}

class BottomNavBar extends StatefulWidget {
  final List<BottomNavBarItem> children;
  int currentIndex;
  final Color? backgroundColor;
  Function(int)? onTap;

  BottomNavBar(
      {super.key,
      required this.children,
      required this.currentIndex,
      this.backgroundColor,
      required this.onTap});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
        border: Border.all(color: const Color(0xffE0E5FE), width: 1.w),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          widget.children.length,
          (index) => NavBarItem(
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

  NavBarItem({
    super.key,
    required this.item,
    this.selected = false,
    required this.onTap,
    this.backgroundColor,
    required this.index,
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
      child: SizedBox(
        width: 80.w,
        height: 66.h,
        child: Column(
          mainAxisAlignment: widget.selected
              ? MainAxisAlignment.end
              : MainAxisAlignment.center,
          children: [
            SvgPicture.asset(widget.item.icon,
                color:
                    widget.selected ? AppColors.blue : AppColors.blueInactive),
            if (widget.selected) ...[
              SizedBox(
                height: 4.h,
              ),
              // SvgPicture.asset(AppAssets.navIndicator)
            ]
          ],
        ),
      ),
    );
  }
}
