import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/food/food_bloc.dart';
import '../blocs/location/location_bloc.dart';
import '../models/food_model.dart';
import '../utils/app_theme.dart';
import 'cart_screen.dart';
import 'food_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<FoodBloc, FoodState>(
          builder: (context, foodState) {
            return BlocBuilder<CartBloc, CartState>(
              builder: (context, cartState) {
                return BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, locationState) {
                    return BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        final userName = authState is AuthAuthenticated
                            ? authState.user.name.split(' ').first
                            : 'there';
                        final userInitial = authState is AuthAuthenticated
                            ? authState.user.name.substring(0, 1)
                            : 'U';

                        return CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: _buildHeader(
                                  context, userName, userInitial,
                                  cartState, locationState),
                            ),
                            SliverToBoxAdapter(
                                child: _buildSearch(context)),
                            SliverToBoxAdapter(
                                child: _buildBanner()),
                            SliverToBoxAdapter(
                                child: _buildCategories(
                                    context, foodState)),
                            SliverToBoxAdapter(
                                child: _buildSectionTitle(
                                    'Popular Near You 🔥')),
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.72,
                                  crossAxisSpacing: 14,
                                  mainAxisSpacing: 14,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, i) {
                                    final items = foodState.filteredFoods;
                                    if (i >= items.length) return null;
                                    return _FoodCard(food: items[i]);
                                  },
                                  childCount:
                                      foodState.filteredFoods.length,
                                ),
                              ),
                            ),
                            const SliverToBoxAdapter(
                                child: SizedBox(height: 24)),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName,
      String userInitial, CartState cartState, LocationState locationState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Icon(Icons.location_on,
                      color: AppTheme.primary, size: 18),
                  const SizedBox(width: 4),
                  Text(locationState.userAddress,
                      style: const TextStyle(
                          color: AppTheme.textSecondary, fontSize: 13)),
                  const Icon(Icons.keyboard_arrow_down,
                      color: AppTheme.textSecondary, size: 18),
                ]),
                const SizedBox(height: 4),
                Text('Hey $userName 👋',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary)),
              ],
            ),
          ),
          Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const CartScreen())),
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10)
                    ],
                  ),
                  child: const Icon(Icons.shopping_bag_outlined,
                      color: AppTheme.textPrimary),
                ),
              ),
              if (cartState.itemCount > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                        color: AppTheme.primary, shape: BoxShape.circle),
                    child: Center(
                      child: Text('${cartState.itemCount}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
            child: Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06), blurRadius: 10)
                ],
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primary.withOpacity(0.15),
                child: Text(userInitial,
                    style: const TextStyle(
                        color: AppTheme.primary,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: TextField(
        controller: _searchController,
        onChanged: (q) =>
            context.read<FoodBloc>().add(FoodSearched(q)),
        decoration: InputDecoration(
          hintText: 'Search food, restaurants...',
          prefixIcon:
              const Icon(Icons.search, color: AppTheme.textSecondary),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10)),
            child:
                const Icon(Icons.tune, color: Colors.white, size: 18),
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      height: 140,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, Color(0xFFFF8C42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Text('🍕',
                style: TextStyle(
                    fontSize: 80,
                    color: Colors.white.withOpacity(0.2))),
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Free Delivery 🎉',
                    style:
                        TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 4),
                Text('On your first order!',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                _PromoChip(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context, FoodState foodState) {
    final categories = FoodData.getCategories();
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('Categories',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary)),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final selected =
                    foodState.selectedCategory == categories[i];
                return GestureDetector(
                  onTap: () => context
                      .read<FoodBloc>()
                      .add(FoodCategorySelected(categories[i])),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.primary : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                  color:
                                      AppTheme.primary.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4))
                            ]
                          : [],
                    ),
                    child: Text(
                      categories[i],
                      style: TextStyle(
                        color: selected
                            ? Colors.white
                            : AppTheme.textSecondary,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary)),
          TextButton(
              onPressed: () {},
              child: const Text('See all',
                  style: TextStyle(color: AppTheme.primary))),
        ],
      ),
    );
  }
}

class _PromoChip extends StatelessWidget {
  const _PromoChip();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: const Text('Use code: RUSH50',
          style: TextStyle(
              color: AppTheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: 12)),
    );
  }
}

class _FoodCard extends StatefulWidget {
  final FoodItem food;
  const _FoodCard({required this.food});

  @override
  State<_FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<_FoodCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _bounceAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(
          parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _addToCart() {
    context.read<CartBloc>().add(CartItemAdded(widget.food));
    _bounceController.forward().then((_) => _bounceController.reverse());
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${widget.food.name} added to cart!'),
      backgroundColor: AppTheme.success,
      behavior: SnackBarBehavior.floating,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, LocationState>(
      builder: (context, locationState) {
        return BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            final inCart = cartState.isInCart(widget.food.id);
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          FoodDetailScreen(food: widget.food))),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20)),
                      child: Stack(
                        children: [
                          Image.network(
                            widget.food.imageUrl,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              height: 130,
                              color: Colors.grey.shade100,
                              child: const Center(
                                  child: Text('🍽️',
                                      style:
                                          TextStyle(fontSize: 40))),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: widget.food.isVeg
                                    ? Colors.green
                                    : Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                  widget.food.isVeg
                                      ? '🌿 Veg'
                                      : '🍗 Non-Veg',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.food.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppTheme.textPrimary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(widget.food.restaurantName,
                              style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 6),
                          Row(children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text('${widget.food.rating}',
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(width: 6),
                            const Icon(Icons.location_on_outlined,
                                color: AppTheme.textSecondary,
                                size: 11),
                            Text(
                              locationState.hasLocation
                                  ? locationState.formattedDistance(
                                      widget.food.restaurantLat,
                                      widget.food.restaurantLng)
                                  : '--',
                              style: const TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 11),
                            ),
                          ]),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text('₹${widget.food.price.toInt()}',
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppTheme.textPrimary)),
                              ScaleTransition(
                                scale: _bounceAnim,
                                child: GestureDetector(
                                  onTap: _addToCart,
                                  child: AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 200),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: inCart
                                          ? AppTheme.primary
                                          : AppTheme.primary
                                              .withOpacity(0.1),
                                      borderRadius:
                                          BorderRadius.circular(9),
                                    ),
                                    child: Icon(Icons.add,
                                        color: inCart
                                            ? Colors.white
                                            : AppTheme.primary,
                                        size: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
