import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '/screens/login.dart';
import 'package:journal_app/screens/homescreen.dart';
import 'package:journal_app/screens/register.dart';
import 'package:journal_app/screens/entryscreen.dart';
import 'package:journal_app/screens/entry_detail_screen.dart';
import 'package:journal_app/screens/maps.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = FirebaseAuth.instance.currentUser != null;
      final bool isLoggingIn = state.matchedLocation == '/login';
      final bool isRegistering = state.matchedLocation == '/register';

      if (!loggedIn && !isLoggingIn && !isRegistering) {
        return '/login';
      } else if (loggedIn && (isLoggingIn || isRegistering)) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterPage(),
      ),
      GoRoute(
        path: '/new-entry',
        builder: (context, state) => EntryScreen(),
      ),
      GoRoute(
      path: '/maps',
      builder: (BuildContext context, GoRouterState state) {
        return const MapsScreen();
      },
    ),
      GoRoute(
        path: '/entry/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EntryDetailScreen(documentId: id);
        },
      ),
    ],
  );
}