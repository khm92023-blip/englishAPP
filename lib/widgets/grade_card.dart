import 'package:flutter/material.dart';
import '../models/grade_model.dart';

class GradeCard extends StatelessWidget {
  final GradeModel grade;
  final VoidCallback onTap;

  const GradeCard({super.key, required this.grade, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: grade.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: grade.color.withOpacity(0.4), width: 2),
          ),
          child: Column(
            children: [
              Text(grade.emoji, style: const TextStyle(fontSize: 42)),
              const SizedBox(height: 8),
              Text(
                grade.nameAr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: grade.color,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                grade.descriptionAr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
