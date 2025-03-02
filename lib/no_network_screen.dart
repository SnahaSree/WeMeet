import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'network_service.dart';
import 'package:lottie/lottie.dart';

class NoNetworkScreen extends StatefulWidget {
  const NoNetworkScreen({super.key});

  @override
  _NoNetworkScreenState createState() => _NoNetworkScreenState();
}

class _NoNetworkScreenState extends State<NoNetworkScreen> {
  bool isRetrying = false;

  @override
  Widget build(BuildContext context) {
    var networkController = Provider.of<NetworkController>(context);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/no_network.json',
              width: 200,
              repeat: true,
            ),
            const SizedBox(height: 20),
            const Text(
              "No Internet Connection",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                setState(() => isRetrying = true);
                await networkController.retryConnection();
                await Future.delayed(const Duration(seconds: 2));
                setState(() => isRetrying = false);
              },
              child: AnimatedRotation(
                turns: isRetrying ? 3 : 0,
                duration: const Duration(seconds: 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Retry",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

