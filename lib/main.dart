import 'package:flutter/material.dart';
import 'package:myshop/ui/Screens.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'ui/Screens.dart';

// Future<void> main() async {
//   await dotenv.load();
//   runApp(const.MyApp());
// }
Future<void> main() async {
  await dotenv.load();
  runApp(const MyApp());
}

// void main() {
//   runApp(const MyApp());
// }

class MyApp extends StatelessWidget {
//  const MyApp({super.key});
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          //LAB4
          ChangeNotifierProvider(
            create: (ctx) => AuthManager(),
          ),
          //LAB3

          // ChangeNotifierProvider(
          //   create: (ctx) => ProductsManager(),
          // ),
          ChangeNotifierProxyProvider<AuthManager, ProductsManager>(
            create: (ctx) => ProductsManager(),
            update: (ctx, authManager, productsManager) {
              //khi authManager co bao hieu thay doi thi doc lai authtoken
              // cho productManager
              productsManager!.authToken = authManager.authToken;
              return productsManager;
            },
          ),
          //LAB3 buoc 2,3
          ChangeNotifierProvider(
            create: (ctx) => CartManager(),
          ),
          // LAB3 buoc 4
          ChangeNotifierProvider(
            create: (ctx) => OrdersManager(),
          ),
        ],
        child: Consumer<AuthManager>(
          builder: (ctx, authManager, child) {
            return MaterialApp(
              title: 'My Shop',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                fontFamily: 'Lato',
                colorScheme: ColorScheme.fromSwatch(
                  primarySwatch: Colors.purple,
                ).copyWith(
                  secondary: Colors.deepOrange,
                ),
              ),
              //lab1 hinh 1
              // home: SafeArea(
              //   child: ProductDetailScreen(
              //     ProductsManager().items[0],
              //   ),
              // ),
// lab1 hinh 2,3
              // home: const SafeArea(
              //    //child: ProductOverviewScreen(),
              //   child: UserProductsScreen(),
              //  ),
//lab2, hinh 1
              // home: const SafeArea(
              //   child: CartScreen(),
              // ),
//lab2 , hinh 2
              //
//lab2 , hinh3
              //    home: const ProductOverviewScreen(),

              //LAB4
              home: authManager.isAuth
                  ? const ProductOverviewScreen()
                  : FutureBuilder(
                      future: authManager.tryAutoLogin(),
                      builder: (ctx, snapshot) {
                        return snapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen();
                      },
                    ),

              routes: {
                CartScreen.routename: (ctx) => const CartScreen(),
                OrdersScreen.routeName: (ctx) => const OrdersScreen(),
                UserProductsScreen.routeName: (ctx) =>
                    const UserProductsScreen(),
              },

              onGenerateRoute: (settings) {
                if (settings.name == ProductDetailScreen.routeName) {
                  final productId = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return ProductDetailScreen(
                        ctx.read<ProductsManager>().findById(productId),
                        // ProductsManager().findById(productId));
                      );
                    },
                  );
                }
                if (settings.name == EditProductScreen.routeName) {
                  final productId = settings.arguments as String?;
                  return MaterialPageRoute(
                    builder: (ctx) {
                      return EditProductScreen(
                        productId != null
                            ? ctx.read<ProductsManager>().findById(productId)
                            : null,
                      );
                    },
                  );
                }

                return null;
              },
            );
          },
        ));
  }
}