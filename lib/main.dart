import 'package:carpooling_frontend/themes/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpooling_frontend/screens/home_screen/home_bloc.dart';
import 'package:carpooling_frontend/screens/home_screen/home_event.dart';
import 'package:carpooling_frontend/screens/login_screen/login_bloc.dart';
import 'package:carpooling_frontend/screens/login_screen/login_screen.dart';
import 'package:carpooling_frontend/services/auth_service.dart';
import 'package:carpooling_frontend/services/fcm_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase

  final fcmService = FCMService(); // Instantiate the FCM service

  // Retrieve the FCM token
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("FCM Token: $fcmToken"); // Log the token for testing

  // Send the FCM token to the backend
  //await fcmService.sendTokenToBackend(fcmToken);

  final authService = AuthService();
  runApp(MyApp(
    authService: authService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;

  const MyApp({Key? key, required this.authService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => LoginBloc(authService)),
        BlocProvider(create: (_) => HomeBloc()..add(LoadAds())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, theme) {
          return MaterialApp(
            title: 'School Police',
            theme: theme,
            home: LoginScreen(),
          );
        },
      ),
    );
  }
}
