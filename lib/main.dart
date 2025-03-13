import 'package:flutter/material.dart';
//import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'network_service.dart';
import 'no_network_screen.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NetworkController()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Consumer<NetworkController>(
          builder: (context, networkController, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: themeProvider.themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              initialRoute: '/',
              routes: {
                '/login': (context) => OnboardingScreen(),
              },
              home: Stack(
                children: [
                  StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.hasData) {
                          User? user = snapshot.data;
                          return HomeScreen(
                            userName: user?.displayName ?? "User",
                            userProfilePic: user?.photoURL ?? "https://via.placeholder.com/150",
                          );
                        } else {
                          return OnboardingScreen();
                        }
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),

                  // Show No Network Screen as an overlay if disconnected
                  if (!networkController.isConnected)
                    const NoNetworkScreen(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
