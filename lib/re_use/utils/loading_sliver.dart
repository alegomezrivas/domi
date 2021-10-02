import 'package:flutter/material.dart';

class LoadingSliver extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      );
  }
}
