import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/food_model.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/location/location_bloc.dart';
import '../utils/app_theme.dart';

class FoodCard extends StatelessWidget {
  final FoodItem item;

  const FoodCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final inCart = cartState.isInCart(item.id);
        final qty = cartState.quantityOf(item.id);

        return GestureDetector(
          onTap: () => _showDetail(context),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.cardBg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20)),
                      child: Image.network(
                        item.imageUrl,
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            height: 130,
                            color: AppTheme.cardBg,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primary,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          height: 130,
                          color: AppTheme.cardBg,
                          child: const Icon(Icons.restaurant_rounded,
                              color: AppTheme.textLight, size: 36),
                        ),
                      ),
                    ),
                    // Veg / Non-veg dot badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: item.isVeg
                                ? AppTheme.vegGreen
                                : AppTheme.nonVegRed,
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.circle,
                          size: 7,
                          color: item.isVeg
                              ? AppTheme.vegGreen
                              : AppTheme.nonVegRed,
                        ),
                      ),
                    ),
                    // Rating badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                color: AppTheme.secondary, size: 11),
                            const SizedBox(width: 3),
                            Text(
                              item.rating.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // First tag banner
                    if (item.tags.isNotEmpty)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            item.tags.first,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                // Info section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Distance + prep time row
                        BlocBuilder<LocationBloc, LocationState>(
                          builder: (context, locationState) {
                            return Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 11, color: AppTheme.textLight),
                                const SizedBox(width: 2),
                                Text(
                                  locationState.hasLocation
                                      ? locationState.formattedDistance(
                                          item.restaurantLat,
                                          item.restaurantLng)
                                      : '--',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.textLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.access_time_rounded,
                                    size: 11, color: AppTheme.textLight),
                                const SizedBox(width: 2),
                                Text(
                                  '${item.prepTime}m',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.textLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const Spacer(),
                        // Price + cart controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '₹${item.price.toInt()}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            if (inCart)
                              _InlineQtyControl(
                                quantity: qty,
                                onDecrease: () => context
                                    .read<CartBloc>()
                                    .add(CartItemDecremented(item.id)),
                                onIncrease: () => context
                                    .read<CartBloc>()
                                    .add(CartItemAdded(item)),
                              )
                            else
                              GestureDetector(
                                onTap: () => context
                                    .read<CartBloc>()
                                    .add(CartItemAdded(item)),
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.primary
                                            .withOpacity(0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(Icons.add_rounded,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CartBloc>(),
        child: _FoodDetailSheet(item: item),
      ),
    );
  }
}

// ── Inline quantity stepper ────────────────────────────────────────────────

class _InlineQtyControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _InlineQtyControl({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrease,
            child: const SizedBox(
              width: 26,
              height: 30,
              child: Icon(Icons.remove_rounded,
                  color: AppTheme.primary, size: 14),
            ),
          ),
          Text(
            quantity.toString(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: AppTheme.primary,
            ),
          ),
          GestureDetector(
            onTap: onIncrease,
            child: const SizedBox(
              width: 26,
              height: 30,
              child: Icon(Icons.add_rounded,
                  color: AppTheme.primary, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom sheet detail ────────────────────────────────────────────────────

class _FoodDetailSheet extends StatelessWidget {
  final FoodItem item;

  const _FoodDetailSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        final inCart = cartState.isInCart(item.id);
        final qty = cartState.quantityOf(item.id);

        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                child: Image.network(
                  item.imageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 220,
                    color: AppTheme.cardBg,
                    child: const Icon(Icons.restaurant_rounded,
                        color: AppTheme.textLight, size: 60),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: item.isVeg
                                  ? AppTheme.vegGreen
                                  : AppTheme.nonVegRed,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(Icons.circle,
                              size: 8,
                              color: item.isVeg
                                  ? AppTheme.vegGreen
                                  : AppTheme.nonVegRed),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.description,
                      style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.5),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            color: AppTheme.secondary, size: 18),
                        const SizedBox(width: 4),
                        Text(item.rating.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w800)),
                        Text('  (${item.reviewCount})',
                            style: const TextStyle(
                                color: AppTheme.textSecondary)),
                        const Spacer(),
                        const Icon(Icons.access_time_rounded,
                            color: AppTheme.textSecondary, size: 16),
                        const SizedBox(width: 4),
                        Text('${item.prepTime} min',
                            style: const TextStyle(
                                color: AppTheme.textSecondary,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          '₹${item.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.primary,
                          ),
                        ),
                        const Spacer(),
                        if (inCart)
                          _InlineQtyControl(
                            quantity: qty,
                            onDecrease: () => context
                                .read<CartBloc>()
                                .add(CartItemDecremented(item.id)),
                            onIncrease: () => context
                                .read<CartBloc>()
                                .add(CartItemAdded(item)),
                          )
                        else
                          SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                context
                                    .read<CartBloc>()
                                    .add(CartItemAdded(item));
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('${item.name} added to cart!'),
                                    backgroundColor: AppTheme.success,
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                  ),
                                );
                              },
                              icon: const Icon(
                                  Icons.add_shopping_cart_rounded,
                                  size: 18),
                              label: const Text('Add to Cart'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
