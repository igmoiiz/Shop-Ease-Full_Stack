import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  const CategoryTile({
    super.key,
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      spacing: 5,
      children: [
        Container(
          height: height * 0.07,
          width: width * 0.15,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(icon, color: Colors.yellow.shade800),
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: height * 0.012,
            fontFamily: GoogleFonts.urbanist().fontFamily,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
    ;
  }
}
