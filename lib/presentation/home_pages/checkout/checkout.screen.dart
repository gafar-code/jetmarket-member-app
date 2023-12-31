import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'controllers/checkout.controller.dart';
import 'section/address_section.dart';
import 'section/app_bar_section.dart';
import 'section/delivery_section.dart';
import 'section/footer_section.dart';
import 'section/product_section.dart';

class CheckoutScreen extends GetView<CheckoutController> {
  const CheckoutScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarCheckout,
      body: ListView(
        children: const [AddressSection(), ProductSection(), DeliverySection()],
      ),
      bottomNavigationBar: const FooterSection(),
    );
  }
}
