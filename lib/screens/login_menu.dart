import 'package:flutter/material.dart';

import 'package:isaac_test/core/app_assets.dart';
import 'package:isaac_test/core/app_text_styles.dart';
import 'package:isaac_test/widgets/game_app_bar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget dialogContents = Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("LOGIN", style: AppTextStyles.titleText),
          const SizedBox(height: 40),

          // Username Field
          _buildPixelTextField(label: "USERNAME:"),
          const SizedBox(height: 20),

          // Password Field
          _buildPixelTextField(label: "PASSWORD:", isObscure: true),
          const SizedBox(height: 40),

          // Confirm Button (Aligned to the Right)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Logic to authenticate
              },
              child: Text(
                "CONFIRM",
                style: AppTextStyles.buttonLabel.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black, // Match your background
      appBar: const MenuAppBar(), // Your existing custom AppBar
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(AppImages.menuBackgroundAlt, fit: BoxFit.cover),
          ),
          SafeArea(child: Center(child: dialogContents)),
        ],
      ),
    );
  }

  Widget _buildPixelTextField({required String label, bool isObscure = false}) {
    return Row(
      children: [
        SizedBox(child: Text(label, style: AppTextStyles.bodyText)),
        Expanded(
          child: TextField(
            obscureText: isObscure,
            style: AppTextStyles.bodyText,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.black,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.zero,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 3),
                borderRadius: BorderRadius.zero,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
