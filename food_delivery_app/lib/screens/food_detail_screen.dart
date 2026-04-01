import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/food_model.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/location/location_bloc.dart';
import '../utils/app_theme.dart';
import 'cart_screen.dart';

class FoodDetailScreen extends StatelessWidget {
  final FoodItem food;
  const FoodDetailScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    // Scaffold lives OUTSIDE BlocBuilder so cart state changes
    // never rebuild it — snackbars can live their full duration.
    return BlocListener<CartBloc, CartState>(
      listenWhen: (prev, curr) => curr.itemCount > prev.itemCount,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(
            content: Text('${food.name} added to cart!'),
            backgroundColor: AppTheme.success,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            action: SnackBarAction(
              label: 'View Cart',
              textColor: Colors.white,
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CartScreen())),
            ),
          ));
      },
      child: Scaffold(
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
            final distance = locationState.hasLocation
                ? locationState.formattedDistance(
                    food.restaurantLat, food.restaurantLng)
                : '--';
            final estTime = locationState.hasLocation
                ? locationState.estimatedTime(
                    food.restaurantLat, food.restaurantLng)
                : food.prepTime;

            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 280,
                  pinned: true,
                  backgroundColor: AppTheme.background,
                  leading: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child:
                          const Icon(Icons.arrow_back_ios_new, size: 18),
                    ),
                  ),
                  actions: [
                    // Only the cart badge rebuilds on cart changes
                    BlocBuilder<CartBloc, CartState>(
                      builder: (context, cartState) => GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CartScreen())),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            const Icon(Icons.shopping_bag_outlined,
                                size: 18),
                            if (cartState.itemCount > 0) ...[
                              const SizedBox(width: 4),
                              Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                    color: AppTheme.primary,
                                    shape: BoxShape.circle),
                                child: Center(
                                    child: Text(
                                        '${cartState.itemCount}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight:
                                                FontWeight.w700))),
                              ),
                            ],
                          ]),
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      food.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade100,
                        child: const Center(
                            child: Text('🍽️',
                                style: TextStyle(fontSize: 80))),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppTheme.background,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(28)),
                    ),
                    transform: Matrix4.translationValues(0, -20, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Veg / category badges
                          Row(children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: (food.isVeg
                                        ? Colors.green
                                        : Colors.red)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: food.isVeg
                                        ? Colors.green
                                        : Colors.red,
                                    width: 0.5),
                              ),
                              child: Text(
                                  food.isVeg
                                      ? '🌿 Vegetarian'
                                      : '🍗 Non-Veg',
                                  style: TextStyle(
                                      color: food.isVeg
                                          ? Colors.green
                                          : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.amber, width: 0.5),
                              ),
                              child: Text(food.category,
                                  style: const TextStyle(
                                      color: Colors.amber,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ]),
                          const SizedBox(height: 12),

                          // Name & price
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Text(food.name,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                            color: AppTheme.textPrimary))),
                                Text('₹${food.price.toInt()}',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: AppTheme.primary)),
                              ]),
                          const SizedBox(height: 4),
                          Text(food.restaurantName,
                              style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 14)),
                          const SizedBox(height: 16),

                          // Stats row
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Colors.black.withOpacity(0.04),
                                    blurRadius: 10)
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: [
                                _StatTile(
                                    icon: '⭐',
                                    value: '${food.rating}',
                                    label:
                                        '${food.reviewCount} reviews'),
                                _HDivider(),
                                _StatTile(
                                    icon: '📍',
                                    value: distance,
                                    label: 'Distance'),
                                _HDivider(),
                                _StatTile(
                                    icon: '⏱️',
                                    value: '${estTime}m',
                                    label: 'Delivery'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Route card
                          if (locationState.hasLocation) ...[
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  AppTheme.primary.withOpacity(0.05),
                                  AppTheme.secondary.withOpacity(0.05)
                                ]),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: AppTheme.primary
                                        .withOpacity(0.15)),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  const Row(children: [
                                    Icon(Icons.route,
                                        color: AppTheme.primary,
                                        size: 18),
                                    SizedBox(width: 8),
                                    Text('Delivery Route',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.textPrimary)),
                                  ]),
                                  const SizedBox(height: 12),
                                  _RoutePoint(
                                      icon: Icons.my_location,
                                      color: Colors.blue,
                                      label: 'Your Location',
                                      sublabel:
                                          locationState.userAddress),
                                  _RouteLine(),
                                  _RoutePoint(
                                      icon: Icons.storefront,
                                      color: AppTheme.primary,
                                      label: food.restaurantName,
                                      sublabel:
                                          '${food.restaurantLat.toStringAsFixed(4)}°N, ${food.restaurantLng.toStringAsFixed(4)}°E'),
                                  _RouteLine(),
                                  _RoutePoint(
                                      icon: Icons.home,
                                      color: Colors.green,
                                      label: 'Your Door',
                                      sublabel:
                                          locationState.userAddress),
                                  const SizedBox(height: 12),
                                  Row(children: [
                                    Expanded(
                                        child: _InfoChip(
                                            icon: Icons.straighten,
                                            label: 'Total: $distance')),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: _InfoChip(
                                            icon: Icons.access_time,
                                            label:
                                                'ETA: ${estTime}min')),
                                  ]),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Description
                          const Text('Description',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.textPrimary)),
                          const SizedBox(height: 8),
                          Text(food.description,
                              style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  height: 1.6)),
                          const SizedBox(height: 16),

                          // Tags
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: food.tags
                                .map((tag) => Container(
                                      padding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                            color: AppTheme.divider),
                                      ),
                                      child: Text(tag,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppTheme
                                                  .textSecondary)),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Bottom bar — only this section rebuilds on cart changes
        bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            final inCart = cartState.isInCart(food.id);
            final qty = cartState.quantityOf(food.id);
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, -5))
                ],
              ),
              child: Row(children: [
                if (inCart) ...[
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.divider),
                        borderRadius: BorderRadius.circular(14)),
                    child: Row(children: [
                      IconButton(
                          icon: const Icon(Icons.remove, size: 18),
                          onPressed: () => context
                              .read<CartBloc>()
                              .add(CartItemDecremented(food.id))),
                      Text('$qty',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                      IconButton(
                          icon: const Icon(Icons.add, size: 18),
                          onPressed: () => context
                              .read<CartBloc>()
                              .add(CartItemAdded(food))),
                    ]),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context
                        .read<CartBloc>()
                        .add(CartItemAdded(food)),
                    child: Text(inCart
                        ? 'Add More  •  ₹${food.price.toInt()}'
                        : 'Add to Cart  •  ₹${food.price.toInt()}'),
                  ),
                ),
              ]),
            );
          },
        ),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String icon, value, label;
  const _StatTile(
      {required this.icon, required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Column(children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: AppTheme.textPrimary)),
        Text(label,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 11)),
      ]);
}

class _HDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 40, color: AppTheme.divider);
}

class _RoutePoint extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label, sublabel;
  const _RoutePoint(
      {required this.icon,
      required this.color,
      required this.label,
      required this.sublabel});
  @override
  Widget build(BuildContext context) => Row(children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
              color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              Text(sublabel,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11)),
            ])),
      ]);
}

class _RouteLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Container(width: 2, height: 20, color: AppTheme.divider),
      );
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Icon(icon, size: 14, color: AppTheme.primary),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary)),
        ]),
      );
}
