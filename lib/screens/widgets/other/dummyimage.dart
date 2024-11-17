import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class DummyImage extends StatelessWidget {
  const DummyImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity, color: apptheme.colorScheme.primary);
  }
}
