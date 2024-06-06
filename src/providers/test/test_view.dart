import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'test_provider.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => TestProvider(),
      builder: (context, child) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final provider = context.read<TestProvider>();
    final state = provider.state;

    return Container();
  }
}