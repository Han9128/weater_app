import 'package:flutter/material.dart';

class AdditionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String measure;
  const AdditionalInfoItem({
    super.key,
    required this.icon,
    required this.label,
    required this.measure,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Icon(icon, size: 32), Text(label), Text(measure)],
      ),
    );
  }
}
