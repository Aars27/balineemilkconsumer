
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class SplashController extends ChangeNotifier{
  Future<void> navigate(BuildContext context)async{
    await Future.delayed(Duration(seconds: 2));
    context.go('/onboarding');


  }



}