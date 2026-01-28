import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AddressItemSkeleton extends StatelessWidget {
  const AddressItemSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          title: Row(
            children: [
              Bone.text(width: 120),
              const SizedBox(width: 8),
              Bone.text(width: 40),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Bone.icon(size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Bone.text(words: 4),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(width: 20), // Placeholder to match spacing
                    Bone.text(width: 50),
                    const SizedBox(width: 16),
                    Bone.text(width: 60),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
