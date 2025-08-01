import 'package:flutter/material.dart';
import '../../../utils/theme/constants/app_colors.dart';

class BlankScreen extends StatefulWidget {
  static const route = r'/blank';

  const BlankScreen({super.key});

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: AppColors.blue,
              height: MediaQuery.of(context).size.height,
            ),
          ],
        ),
      ),
    );
  }
}
