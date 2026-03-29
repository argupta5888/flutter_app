import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/location/location_bloc.dart';
import '../models/food_model.dart';
import '../utils/app_theme.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, cartState) {
        return BlocBuilder<LocationBloc, LocationState>(
          builder: (context, locationState) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('My Cart'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  if (cartState.items.isNotEmpty)
                    TextButton(
                      onPressed: () =>
                          context.read<CartBloc>().add(CartCleared()),
                      child: const Text('Clear All',
                          style: TextStyle(color: AppTheme.primary)),
                    ),
                ],
              ),
              body: cartState.items.isEmpty
                  ? _EmptyCart()
                  : Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: cartState.items.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, i) => _CartItemCard(
                                item: cartState.items[i],
                                locationState: locationState),
                          ),
                        ),
                        _OrderSummary(cartState: cartState),
                      ],
                    ),
            );
          },
        );
      },
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🛒', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          const Text('Your cart is empty',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          const SizedBox(height: 8),
          const Text('Add some delicious food!',
              style: TextStyle(color: AppTheme.textSecondary)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Browse Food'),
          ),
        ]),
      );
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final LocationState locationState;
  const _CartItemCard({required this.item, required this.locationState});

  @override
  Widget build(BuildContext context) {
    final distance = locationState.hasLocation
        ? locationState.formattedDistance(
            item.food.restaurantLat, item.food.restaurantLng)
        : '--';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 12)
        ],
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            item.food.imageUrl,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: 70,
              height: 70,
              color: Colors.grey.shade100,
              child: const Center(
                  child: Text('🍽️', style: TextStyle(fontSize: 28))),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.food.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: AppTheme.textPrimary)),
                const SizedBox(height: 2),
                Text(item.food.restaurantName,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Row(children: [
                  const Icon(Icons.location_on_outlined,
                      size: 12, color: AppTheme.primary),
                  const SizedBox(width: 2),
                  Text(distance,
                      style: const TextStyle(
                          color: AppTheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  const Icon(Icons.access_time,
                      size: 12, color: AppTheme.textSecondary),
                  const SizedBox(width: 2),
                  Text('${item.food.prepTime}min',
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 11)),
                ]),
                const SizedBox(height: 8),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹${item.totalPrice.toInt()}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: AppTheme.textPrimary)),
                      Row(children: [
                        GestureDetector(
                          onTap: () => context
                              .read<CartBloc>()
                              .add(CartItemDecremented(item.food.id)),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppTheme.divider),
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.remove, size: 14),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('${item.quantity}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15)),
                        ),
                        GestureDetector(
                          onTap: () => context
                              .read<CartBloc>()
                              .add(CartItemAdded(item.food)),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                                color: AppTheme.primary,
                                borderRadius: BorderRadius.circular(8)),
                            child: const Icon(Icons.add,
                                size: 14, color: Colors.white),
                          ),
                        ),
                      ]),
                    ]),
              ]),
        ),
        const SizedBox(width: 6),
        GestureDetector(
          onTap: () => context
              .read<CartBloc>()
              .add(CartItemDeleted(item.food.id)),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.delete_outline,
                size: 16, color: Colors.red),
          ),
        ),
      ]),
    );
  }
}

class _OrderSummary extends StatelessWidget {
  final CartState cartState;
  const _OrderSummary({required this.cartState});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -8))
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Order Summary',
              style:
                  TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 14),
          _SummaryRow('Subtotal', '₹${cartState.subtotal.toInt()}'),
          const SizedBox(height: 8),
          _SummaryRow(
              'Delivery Fee', '₹${cartState.deliveryFee.toInt()}'),
          const SizedBox(height: 8),
          _SummaryRow(
              'Taxes (5%)', '₹${cartState.tax.toStringAsFixed(0)}'),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider()),
          _SummaryRow('Total', '₹${cartState.total.toStringAsFixed(0)}',
              isBold: true),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  content: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🎉', style: TextStyle(fontSize: 48)),
                        SizedBox(height: 12),
                        Text('Order Placed!',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 8),
                        Text(
                            'Your food is being prepared and will be delivered soon.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppTheme.textSecondary)),
                      ]),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<CartBloc>().add(CartCleared());
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              );
            },
            child: Text(
                'Place Order  •  ₹${cartState.total.toStringAsFixed(0)}'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool isBold;
  const _SummaryRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: isBold
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                  fontWeight:
                      isBold ? FontWeight.w700 : FontWeight.w400,
                  fontSize: isBold ? 16 : 14)),
          Text(value,
              style: TextStyle(
                  color: isBold ? AppTheme.primary : AppTheme.textPrimary,
                  fontWeight:
                      isBold ? FontWeight.w800 : FontWeight.w600,
                  fontSize: isBold ? 18 : 14)),
        ],
      );
}
