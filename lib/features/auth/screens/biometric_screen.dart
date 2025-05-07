import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_grocery/features/auth/screens/send_otp_screen.dart';
import 'package:flutter_grocery/features/auth/widgets/only_social_login_screen.dart';
import 'package:flutter_grocery/helper/auth_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/footer_web_widget.dart';
import 'package:flutter_grocery/common/widgets/web_app_bar_widget.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {




  Future<void> authenticateWithBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool isBiometricSupported = await auth.isDeviceSupported();
    bool canCheckBiometrics = await auth.canCheckBiometrics;

    if (isBiometricSupported && canCheckBiometrics) {
      bool authenticated = false;

      try {
        authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to continue',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } catch (e) {
        showCustomSnackBarHelper('Biometric authentication error: $e');
      }

      if (authenticated) {
        Provider.of<AuthProvider>(context, listen: false).updateToken();
        Navigator.of(context).pushNamedAndRemoveUntil(RouteHelper.menu, (route) => false);
      } else {
        showCustomSnackBarHelper(getTranslated('authentication_failed', context) ?? 'Authentication failed');
      }
    } else {
      showCustomSnackBarHelper(getTranslated('biometric_not_supported', context) ?? 'Biometric not supported');
    }
  }


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return Selector<SplashProvider, ConfigModel?>(
      selector: (ctx, splashProvider)=> splashProvider.configModel,
      builder: (ctx, configModel, _){
          return CustomPopScopeWidget(child: Scaffold(
            appBar: ResponsiveHelper.isDesktop(context)? const PreferredSize(preferredSize: Size.fromHeight(120), child: WebAppBarWidget()) : null,
            body: SafeArea(child: CustomScrollView(slivers: [

              if(ResponsiveHelper.isDesktop(context)) const SliverToBoxAdapter(child: SizedBox(height: Dimensions.paddingSizeLarge)),

              SliverToBoxAdapter(child: Padding(
                padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? 0 : Dimensions.paddingSizeLarge),
                child: Center(child: Container(
                  width: ResponsiveHelper.isMobile() ? width : 500,
                  padding: !ResponsiveHelper.isMobile() ? const EdgeInsets.symmetric(horizontal: 50,vertical: 50) :  width > 500 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
                  decoration: !ResponsiveHelper.isMobile() ? BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
                  ) : null,
                  child: Consumer<AuthProvider>(
                    builder: (context, authProvider, child) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Text(
                          getTranslated('login', context) ?? 'Login',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Center(child: Padding(
                          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                          child: Image.asset(
                            Images.appLogo, height: ResponsiveHelper.isDesktop(context)
                              ? MediaQuery.of(context).size.height * 0.15
                              : MediaQuery.of(context).size.height / 4.5,
                            fit: BoxFit.scaleDown,
                          ),
                        )),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        const SizedBox(height: 30),

                        const Icon(Icons.fingerprint, size: 100, color: Colors.blue),
                        const SizedBox(height: 20),

                        Text(
                          getTranslated('use_fingerprint_to_continue', context) ?? 'Use fingerprint to continue',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),

                        ElevatedButton.icon(
                          onPressed: () => authenticateWithBiometrics(),
                          icon: const Icon(Icons.fingerprint),
                          label: Text(getTranslated('authenticate', context) ?? 'Authenticate'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                )),
              )),

              const FooterWebWidget(footerType: FooterType.sliver),

            ])),

          ));
      },
    );



  }



}
