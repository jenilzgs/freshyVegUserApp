import 'package:flutter/material.dart';
import 'package:flutter_grocery/common/enums/footer_type_enum.dart';

class FooterWebWidget extends StatelessWidget {
  final FooterType footerType;
  const FooterWebWidget({super.key, required this.footerType});


  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(),
    );
  }
}

