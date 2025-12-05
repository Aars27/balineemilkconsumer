import 'package:consumerbalinee/Core/Constant/app_colors.dart';
import 'package:consumerbalinee/Core/Constant/text_constants.dart';
import 'package:consumerbalinee/Features/ViewScreens/SplashScreen/SplashController/SplashController.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../Core/Constant/app_images.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override

  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      context.read<SplashController>().navigate(context);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.routeBackgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AppImages.appLogo,width: 150,),
              SizedBox(
                height: 20,
              ),
              Text('Your Dairy Delivery Partner',style: TextConstants.headingStyle.copyWith(color:Colors.white),),
            SizedBox(
              height: 10,
            ),
              CircularProgressIndicator(
                color: Colors.white,
              )

            ],
          ),
        ),
      ),
    );
  }
}
