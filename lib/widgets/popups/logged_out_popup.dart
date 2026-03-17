import 'package:flutter/material.dart';

import 'package:codeshield/core/app_assets.dart';
import 'package:codeshield/core/app_routes.dart';
import 'package:codeshield/core/app_text_styles.dart';

void showLoggedOutPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      Widget rowActionButtons = Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.login);
            },
            child: Text(
              "LOGIN",
              style: AppTextStyles.buttonLabel.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "REGISTER",
              style: AppTextStyles.buttonLabel.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      );

      Widget dialogTitleBox = SizedBox(
        height: 80,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Image.asset(
                  AppIcons.close,
                  width: 64,
                  filterQuality: FilterQuality.none,
                ),
                padding: EdgeInsets.zero,
              ),
            ),
            Center(child: Text("LOGGED OUT", style: AppTextStyles.buttonLabel)),
          ],
        ),
      );

      Widget dialogContents = Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.white, width: 4),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            dialogTitleBox,
            const SizedBox(height: 30),
            rowActionButtons,
          ],
        ),
      );

      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: Colors.transparent,
        child: dialogContents,
      );
    },
  );
}
