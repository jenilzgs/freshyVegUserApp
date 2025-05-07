import 'package:flutter/material.dart';
import 'package:flutter_grocery/features/order/providers/order_provider.dart';
import 'package:flutter_grocery/utill/dimensions.dart';
import 'package:flutter_grocery/utill/styles.dart';
import 'package:provider/provider.dart';

class PaymentButtonWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String walletBalance;
  final String totalAmount;
  final bool isSelected;
  final Function onTap;

  const PaymentButtonWidget({
    super.key, required this.isSelected, required this.icon,
    required this.title,required this.walletBalance,required this.totalAmount, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (ctx, orderController, _) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        child: InkWell(
          onTap: onTap as void Function()?,
          child: Stack(clipBehavior: Clip.none, children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusSizeSmall),
                  border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).disabledColor.withOpacity(0.1))
              ),
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
              child: Column(
                children: [
                  Row(children: [
                    Image.asset(
                      icon, width: 20, height: 20,
                    ),
                    const SizedBox(width: Dimensions.paddingSizeSmall),

                    Expanded(child: Row(
                      children: [
                        Text(title, style: poppinsMedium.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color:  Theme.of(context).textTheme.bodyLarge?.color,
                        )),
                        const SizedBox(width: Dimensions.fontSizeMaxLarge),
                        Text(totalAmount, style: poppinsMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge,
                          color: Theme.of(context).primaryColor,
                        )),

                      ],
                    )),
                  ]),
                  const SizedBox(height: Dimensions.fontSizeLarge),

                  Text(walletBalance, style: poppinsMedium.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color:  Theme.of(context).textTheme.bodyLarge?.color,
                  )),
                ],
              ),

            ),

            if(isSelected) Positioned(top: -7, right: -7, child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.all(2),
              child: const Icon(Icons.check, color: Colors.white, size: 18),
            )),
          ]),
        ),
      );
    });
  }
}
