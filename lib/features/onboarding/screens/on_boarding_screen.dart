import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/widgets/custom_pop_scope_widget.dart';
import 'package:flutter_grocery/helper/route_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/onboarding/providers/onboarding_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/color_resources.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/features/auth/screens/login_screen.dart';
import 'package:flutter_grocery/features/onboarding/widgets/on_boarding_widget.dart';
import 'package:provider/provider.dart';

class OnBoardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();

  OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<OnBoardingProvider>(context, listen: false).getBoardingList(context);

    return CustomPopScopeWidget(child: Scaffold(
      body: SafeArea(child: Consumer<OnBoardingProvider>(
        builder: (context, onBoarding, child) {
          return onBoarding.onBoardingList.isNotEmpty ? Column(children: [
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                onPressed: () {
                  Provider.of<SplashProvider>(context, listen: false).disableIntro();
                  Navigator.of(context).pushReplacementNamed(RouteHelper.login, arguments: const LoginScreen());
                },
                child: Text(
                  onBoarding.selectedIndex != onBoarding.onBoardingList.length - 1 ? getTranslated('skip', context): '',
                  style: poppinsSemiBold.copyWith(color: Theme.of(context).hintColor.withOpacity(0.6)),
                ),
              ),
            ]),

            Expanded(child: PageView.builder(
              itemCount: onBoarding.onBoardingList.length,
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
                  child: OnBoardingWidget(onBoardingModel: onBoarding.onBoardingList[index]),
                );
              },
              onPageChanged: (index) => onBoarding.setSelectIndex(index),
            )),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _pageIndicators(onBoarding.onBoardingList, context),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
              child: Stack(children: [
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      value: (onBoarding.selectedIndex + 1) / onBoarding.onBoardingList.length,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () {
                      if (onBoarding.selectedIndex == onBoarding.onBoardingList.length - 1) {
                        Provider.of<SplashProvider>(context, listen: false).disableIntro();
                        Navigator.of(context).pushReplacementNamed(RouteHelper.login, arguments: const LoginScreen());
                      } else {
                        _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColor),
                      child: Icon(
                        onBoarding.selectedIndex == onBoarding.onBoardingList.length - 1 ? Icons.check : Icons.navigate_next,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ]) : const SizedBox();
        },
      )),
    ));
  }

  List<Widget> _pageIndicators(var onBoardingList, BuildContext context) {
    List<Container> indicators = [];

    for (int i = 0; i < onBoardingList.length; i++) {
      indicators.add(
        Container(
          width: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? 20 : 10,
          height: 10,
          margin: const EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color:
                i == Provider.of<OnBoardingProvider>(context).selectedIndex ? Theme.of(context).primaryColor : ColorResources.getGreyColor(context),
            borderRadius: i == Provider.of<OnBoardingProvider>(context).selectedIndex ? BorderRadius.circular(50) : BorderRadius.circular(25),
          ),
        ),
      );
    }
    return indicators;
  }
}
