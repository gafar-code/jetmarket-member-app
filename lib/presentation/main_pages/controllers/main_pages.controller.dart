import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jetmarket/infrastructure/dal/repository/notification_repository_impl.dart';
import 'package:jetmarket/presentation/screens.dart';
import '../../../infrastructure/dal/services/firebase/firebase_controller.dart';
import '../../../utils/assets/assets_svg.dart';
import '../../../utils/global/constant.dart';
import 'item_bar_model.dart';

class MainPagesController extends GetxController {
  late StreamSubscription sub;
  var selectedIndex = 0;
  bool isEmployees = false;
  void changeTabIndex(int index) {
    selectedIndex = index;
    update();
  }

  Future<bool> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await updateUnreadNotification();
      _handleMessage(initialMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
      return true;
    } else {
      return false;
    }
  }

  void _handleMessage(RemoteMessage message) async {
    if (message.notification != null) {
      log("${message.data}");
      log("${message.data['pagelink']}");
      log(message.notification?.body ?? 'o');
    }
  }

  Future<void> updateUnreadNotification() async {
    final controller =
        Get.put(FirebaseController(NotificationRepositoryImpl()));
    await controller.getUnreadNotification();
  }

  List<Widget> get listPageIsEmploye {
    return [
      const HomeScreen(),
      const OrderScreen(),
      const KoperasiScreen(),
      const EWalletScreen(),
      const AccountScreen(),
    ];
  }

  List<Widget> get listPageNotIsEmploye {
    return [
      const HomeScreen(),
      const OrderScreen(),
      const EWalletScreen(),
      const AccountScreen(),
    ];
  }

  List<Widget> get listPages {
    if (isEmployees) {
      return [
        const HomeScreen(),
        const OrderScreen(),
        const KoperasiScreen(),
        const EWalletScreen(),
        const AccountScreen(),
      ];
    } else {
      return [
        const HomeScreen(),
        const OrderScreen(),
        const EWalletScreen(),
        const AccountScreen(),
      ];
    }
  }

  List<ItemBarModel> get listItemBar {
    if (isEmployees) {
      return [
        ItemBarModel(
          label: "Home",
          icon: home,
          iconFill: homeFill,
        ),
        ItemBarModel(
          label: "Pesanan",
          icon: pesanan,
          iconFill: pesananFill,
        ),
        ItemBarModel(
          label: "Koperasi",
          icon: koperasi,
          iconFill: koperasiFill,
        ),
        ItemBarModel(
          label: "E-Wallet",
          icon: wallet,
          iconFill: walletFill,
        ),
        ItemBarModel(
          label: "Akun",
          icon: akun,
          iconFill: akunFill,
        )
      ];
    } else {
      return [
        ItemBarModel(
          label: "Home",
          icon: home,
          iconFill: homeFill,
        ),
        ItemBarModel(
          label: "Pesanan",
          icon: pesanan,
          iconFill: pesananFill,
        ),
        ItemBarModel(
          label: "E-Wallet",
          icon: wallet,
          iconFill: walletFill,
        ),
        ItemBarModel(
          label: "Akun",
          icon: akun,
          iconFill: akunFill,
        )
      ];
    }
  }

  setEmploye() {
    isEmployees = isEmployee;
    update();
  }

  rebuildController() {}

  @override
  void onInit() {
    setEmploye();
    updateUnreadNotification();
    setupInteractedMessage();
    super.onInit();
  }
}
