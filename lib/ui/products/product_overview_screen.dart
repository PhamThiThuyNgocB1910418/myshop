import 'package:flutter/material.dart';
import 'package:myshop/ui/cart/cart_manager.dart';
import 'package:myshop/ui/products/products_manager.dart';
import 'package:myshop/ui/shared/app_drawer.dart';
import 'package:provider/provider.dart';
import 'products_grid.dart';

import "../cart/cart_screen.dart";
import 'top_right_badge.dart';

enum FilterOptions { favorites, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
  
}

// class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
//   var _showOnlyFavorites = false;



class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
 
  final _showOnlyFavorites = ValueNotifier<bool>(false);
  late Future<void> _fetchProducts;
  
  @override
  void initState() {
    super.initState();
    _fetchProducts = context.read<ProductsManager>().fetchProducts();
  }

// class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
//   var _showOnlyFavorites = false;

//Lab4
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          buildProductFilterMenu(),
          buildShoppingCartIcon(),
        ],
      ),
      drawer: const AppDrawer(),
      // body: ProductsGrid(_showOnlyFavorites),
      body: FutureBuilder(
          future: _fetchProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ValueListenableBuilder<bool>(
                  valueListenable: _showOnlyFavorites,
                  builder: (context, onlyFavorites, child) {
                    return ProductsGrid(onlyFavorites);
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
//lab2 hinh 1,2,3
  // Widget buildShoppingCartIcon() {
  //   return IconButton(
  //     icon: const Icon(
  //       Icons.shopping_cart,
  //     ),
  //     onPressed: () {
  //       // print('Go to cart screen');
  //       Navigator.of(context).pushNamed(CartScreen.routerName);
  //     },
  //   );
  // }

  //lab2 hinh 4
  // Widget buildShoppingCartIcon() {
  //   return TopRightBadge(
  //     data: CartManager().productCount,
  //     child: IconButton(
  //       icon: const Icon(
  //         Icons.shopping_cart,
  //       ),
  //       onPressed: () {
  //         Navigator.of(context).pushNamed(CartScreen.routeName);
  //       },
  //     ),
  //   );
  // }

  Widget buildShoppingCartIcon() {
    return Consumer<CartManager>(
      builder: (ctx, cartManager, child) {
        return TopRightBadge(
          data: cartManager.productCount,
          child: IconButton(
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.of(ctx).pushNamed(CartScreen.routename);
            },
          ),
        );
      },
    );
  }

//LAB4
  Widget buildProductFilterMenu() {
    return PopupMenuButton(
      onSelected: (FilterOptions selectedValue) {
        if (selectedValue == FilterOptions.favorites) {
          _showOnlyFavorites.value = true;
        } else {
          _showOnlyFavorites.value = false;
        }
      },
      icon: const Icon(
        Icons.more_vert,
      ),
      itemBuilder: (ctx) => [
        const PopupMenuItem(
          value: FilterOptions.favorites,
          child: Text('Only Favorites'),
        ),
        const PopupMenuItem(
          value: FilterOptions.all,
          child: Text('Show All'),
        ),
      ],
    );
  }
}