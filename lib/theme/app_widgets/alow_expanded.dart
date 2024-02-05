import 'package:flutter/material.dart';

class AllowExpanded extends StatelessWidget {
  const AllowExpanded({super.key, this.colomn});
  final Column? colomn;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: colomn,
        )
      ],
    );
  }
}
