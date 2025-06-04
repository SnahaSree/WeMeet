import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'network_service.dart';
import 'no_network_screen.dart';

class NoInternetWrapper extends StatelessWidget {
  final Widget child; // The page to display if there's internet

  const NoInternetWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var networkController = Provider.of<NetworkController>(context);

    return networkController.isConnected ? child : const NoNetworkScreen();
  }
}
