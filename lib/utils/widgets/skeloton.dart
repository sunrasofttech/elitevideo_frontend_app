import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkelotonWidget extends StatelessWidget {
  final bool loading;
  const SkelotonWidget({
    super.key,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      effect: const ShimmerEffect(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Title $index'),
                  subtitle: const Text('This is a subtitle'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Title $index'),
                  subtitle: const Text('This is a subtitle'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
