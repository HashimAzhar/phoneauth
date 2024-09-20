import 'package:flutter/material.dart';

class roundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const roundButton(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepPurple,
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: const TextStyle(color: Colors.white),
                ),
        ),
      ),
    );
  }
}
