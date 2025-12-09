
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'OrderHistoryController.dart';
import 'OrderHistoryScreen.dart';

class Orderhistoryscreen extends StatelessWidget {
  const Orderhistoryscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderHistoryController(),
      child: const OrderHistoryView(),
    );
  }
}