import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery/common/enums/data_source_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/helper/maintenance_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/common/providers/cart_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/main.dart';
import 'package:flutter_grocery/utill/app_constants.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/features/onboarding/screens/on_boarding_screen.dart';
import 'package:provider/provider.dart';

import '../../../helper/auth_helper_password.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription<List<ConnectivityResult>>? subscription;
  bool isNotLoaded = true;


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _checkConnectivity();

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData();
    _route();
  }

  void _route() {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    splashProvider.initConfig(source: DataSourceEnum.local).then((configModel) async{
      _onConfigAction(configModel, splashProvider, Get.context!);
    });
  }

  void _onConfigAction(ConfigModel? configModel, SplashProvider splashProvider, BuildContext context) {
    if (configModel != null) {
      splashProvider.getDeliveryInfo();
      splashProvider.initializeScreenList();

      double minimumVersion = 0.0;
      if (Platform.isAndroid) {
        if (splashProvider.configModel?.playStoreConfig?.minVersion != null) {
          minimumVersion =
              splashProvider.configModel?.playStoreConfig?.minVersion ??
                  AppConstants.appVersion;
        }
      } else if (Platform.isIOS) {
        if (splashProvider.configModel?.appStoreConfig?.minVersion != null) {
          minimumVersion =
              splashProvider.configModel?.appStoreConfig?.minVersion ??
                  AppConstants.appVersion;
        }
      }
      Future.delayed(const Duration(milliseconds: 5)).then((_) async {

        if(AppConstants.appVersion < minimumVersion && !ResponsiveHelper.isWeb()) {
          Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getUpdateRoute(), (route) => false);
        }
        else{
          if(MaintenanceHelper.isMaintenanceModeEnable(configModel) && MaintenanceHelper.isCustomerMaintenanceEnable(configModel)){
            if (mounted) {
              print("Not Login");
              Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getMainRoute(), (route) => false);
            } else {
              print('Widget is not mounted; cannot navigate.');
            }
            //Navigator.pushNamedAndRemoveUntil(context, RouteHelper.getMainRoute(), (route) => false);
          }
          else if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
            print("User is logged in");

            Provider.of<AuthProvider>(context, listen: false).updateToken();
            Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.menu, (route) => false);

          } else {
            if(Provider.of<SplashProvider>(context, listen: false).showIntro()) {
              Navigator.pushNamedAndRemoveUntil(context, RouteHelper.onBoarding, (route) => false, arguments: OnBoardingScreen());

            }else {

              Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.menu, (route) => false);
            }
          }
        }
      });
    }
  }

  void _checkConnectivity() {
    bool isFirst = true;
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
      bool isConnected = result.contains(ConnectivityResult.wifi)  || result.contains(ConnectivityResult.mobile);

      if((isFirst && !isConnected) || !isFirst && context.mounted) {
        showCustomSnackBarHelper(getTranslated(isConnected ?  'connected' : 'no_internet_connection', context), isError: !isConnected);

        if(isConnected && ModalRoute.of(context)?.settings.name == RouteHelper.splash) {
          _route();
        }
      }
      isFirst = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SplashProvider>(
        builder: (context, splashProvider, _) {
          if(splashProvider.configModel != null && isNotLoaded) {
            isNotLoaded = false;
            _onConfigAction(splashProvider.configModel, splashProvider, context);
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(Images.appLogo, height: 130, width: 500),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Text(AppConstants.appName,
                  textAlign: TextAlign.center,
                  style: poppinsMedium.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 30,
                  )),
            ],
          );
        }
      ),
    );
  }
}
