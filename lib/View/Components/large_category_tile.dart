// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class LargeCategoryTile extends StatelessWidget {
  final String backgroundImage;
  final String title;
  final VoidCallback onTap;

  const LargeCategoryTile({
    super.key,
    required this.backgroundImage,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, right: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: mediaQuery.height * 0.012,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade600,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
