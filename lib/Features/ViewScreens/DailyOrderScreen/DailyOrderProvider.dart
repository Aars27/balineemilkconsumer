
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DailyController.dart';
import 'DailyOrderScreen.dart';

class Dailyorderscreen extends StatelessWidget {
  const Dailyorderscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DailyOrderController(),
      child: const DailyOrderView(),
    );
  }
}
