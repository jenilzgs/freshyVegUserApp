import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/models/config_model.dart';
import 'package:flutter_grocery/helper/checkout_helper.dart';
import 'package:flutter_grocery/helper/price_converter_helper.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';
import 'package:flutter_grocery/localization/language_constraints.dart';
import 'package:flutter_grocery/features/auth/providers/auth_provider.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/features/profile/providers/profile_provider.dart';
import 'package:flutter_grocery/features/splash/providers/splash_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/images.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:flutter_grocery/helper/custom_snackbar_helper.dart';
import 'package:flutter_grocery/common/widgets/no_data_widget.dart';
import 'package:flutter_grocery/features/checkout/widgets/payment_button_widget.dart';
import 'package:provider/provider.dart';

import 'partial_pay_dialog_widget.dart';



class PaymentMethodBottomSheetWidget extends StatefulWidget {

  const PaymentMethodBottomSheetWidget({super.key});

  @override
  State<PaymentMethodBottomSheetWidget> createState() => _PaymentMethodBottomSheetWidgetState();
}

class _PaymentMethodBottomSheetWidgetState extends State<PaymentMethodBottomSheetWidget> {
  bool canSelectWallet = false;
  bool notHideCod = true;
  bool notHideDigital = true;
  bool notHideOffline = true;
  List<PaymentMethod> paymentList = [];

  @override
  void initState() {
    super.initState();

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    orderProvider.setPaymentIndex(1);
    orderProvider.clearOfflinePayment();
    orderProvider.savePaymentMethod();



  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    double orderAmount = orderProvider.getCheckOutData?.amount ?? 0;

    return SingleChildScrollView(
      child: Center(child: SizedBox(width: 550, child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.8),
          width: 550,
          margin: const EdgeInsets.only(top: kIsWeb ? 0 : 30),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: ResponsiveHelper.isMobile() ? const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusSizeLarge))
                : const BorderRadius.all(Radius.circular(Dimensions.radiusSizeDefault)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeExtraSmall),
          child: Consumer<OrderProvider>(
              builder: (ctx, orderProvider, _) {
                double orderAmount = orderProvider.getCheckOutData?.amount ?? 0;
                return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Row(children: [

                    notHideCod ? Text(getTranslated('choose_payment_method', context), style: poppinsBold.copyWith(fontSize: Dimensions.fontSizeDefault)) : const SizedBox(),
                    SizedBox(width: notHideCod ? Dimensions.paddingSizeExtraSmall : 0),
                  ]),

                  SizedBox(height: notHideCod ? Dimensions.paddingSizeLarge : 0),

                  Row(children: [
                    Expanded(child: PaymentButtonWidget(
                      icon: Images.walletPayment,
                      title: getTranslated('pay_via_wallet', context),
                      totalAmount: "${orderAmount}",
                      walletBalance: profileProvider.userInfoModel!.walletBalance! < orderAmount ? getTranslated('can_be_paid_via_wallet', context): '${getTranslated('remaining_wallet_balance', context)}: ${PriceConverterHelper.convertPrice(context, profileProvider.userInfoModel!.walletBalance! - orderAmount)}',
                      isSelected: orderProvider.paymentMethodIndex == 1,
                      onTap: () {
                        // if( canSelectWallet) {
                        //   // Navigator.pop(context);
                        //   // showDialog(context: context, builder: (ctx)=> PartialPayDialogWidget(
                        //   //   isPartialPay: profileProvider.userInfoModel!.walletBalance! < orderAmount,
                        //   //   totalPrice: orderAmount,
                        //   // ));
                        //   // orderProvider.setPaymentIndex(1);
                        //
                        //   // orderProvider.changePartialPayment(amount: orderAmount - (profileProvider.userInfoModel?.walletBalance ?? 0));
                        //
                        //   // orderProvider.setPaymentIndex(1);
                        //   // orderProvider.clearOfflinePayment();
                        //   // orderProvider.savePaymentMethod(index: orderProvider.paymentMethodIndex, method: orderProvider.paymentMethod);
                        //
                        // }else{
                        //   Navigator.pop(context);
                        //   showCustomSnackBarHelper(getTranslated('your_wallet_have_not_sufficient_balance', context));
                        // }
                      },
                    ))


                    // if(isWalletActive && canSelectWallet)
                    //   Text(PriceConverterHelper.convertPrice(context, orderAmount < profileProvider.userInfoModel!.walletBalance!
                    //       ? orderAmount : profileProvider.userInfoModel!.walletBalance!),
                    //     style: poppinsBold.copyWith(fontSize: Dimensions.fontSizeOverLarge, color: Theme.of(context).primaryColor),
                    //   ),
                    // Padding(
                    //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    //   child: Text(
                    //     profileProvider.userInfoModel!.walletBalance! < orderAmount ? getTranslated('can_be_paid_via_wallet', context): '${getTranslated('remaining_wallet_balance', context)}: ${PriceConverterHelper.convertPrice(context, profileProvider.userInfoModel!.walletBalance! - orderAmount)}',
                    //     style: poppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor), textAlign: TextAlign.center,
                    //   ),
                    // ),

                  ]),



                ]);
              }
          ),
        ),
      ]))),
    );
  }
}