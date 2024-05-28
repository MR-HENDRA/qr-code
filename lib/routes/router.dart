// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrcode/models/product.dart';

import '../pages/home.dart';
import '../pages/error.dart';
import '../pages/products.dart';
import '../pages/detail_product.dart';
import '../pages/add_product.dart';
import '../pages/login.dart';

export 'package:go_router/go_router.dart';
part 'route_name.dart';

// GoRouter configuration
final router = GoRouter(
  redirect: (context, state) {
    FirebaseAuth auth = FirebaseAuth.instance;
    // print(auth.currentUser);
    // cek kondisi mi dlu -> sedang terauntentikasi
    if (auth.currentUser == null) {
      return '/login';
    } else {
      return null;
    }
  },
  errorBuilder: (context, state) => const ErrorPage(),
  routes: [
    GoRoute(
      path: '/',
      name: Routes.home,
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'products',
          name: Routes.products,
          builder: (context, state) => const ProductsPage(),
          routes: [
            GoRoute(
              path: ':productId',
              name: Routes.detailProduct,
              builder: (context, state) => DetailProductPage(
                state.pathParameters['productId'].toString(),
                state.extra as Product,
                // state.uri.queryParameters,
              ),
              // state.params['id'].toString()), -> ini tidak berlaku di versi terbaru flutter/dart
            ),
          ],
        ),
        GoRoute(
          path: 'add-product',
          name: Routes.addProduct,
          builder: (context, state) => AddProductPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      name: Routes.login,
      builder: (context, state) => LoginPage(),
    ),
  ],
);
