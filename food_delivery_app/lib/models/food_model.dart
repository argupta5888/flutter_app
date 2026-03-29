class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int reviewCount;
  final int prepTime;
  final bool isVeg;
  final List<String> tags;
  final String restaurantName;
  final double restaurantLat;
  final double restaurantLng;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.prepTime,
    required this.isVeg,
    required this.tags,
    required this.restaurantName,
    required this.restaurantLat,
    required this.restaurantLng,
  });
}

class CartItem {
  final FoodItem food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});

  double get totalPrice => food.price * quantity;
}

class FoodData {
  static List<FoodItem> getSampleFoods() {
    return [
      FoodItem(
        id: '1',
        name: 'Butter Chicken',
        description: 'Creamy tomato-based curry with tender chicken pieces, slow-cooked with aromatic spices',
        price: 320,
        imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=500',
        category: 'Main Course',
        rating: 4.8,
        reviewCount: 1240,
        prepTime: 25,
        isVeg: false,
        tags: ['Spicy', 'Popular', 'Creamy'],
        restaurantName: 'Spice Garden',
        restaurantLat: 19.0760,
        restaurantLng: 72.8777,
      ),
      FoodItem(
        id: '2',
        name: 'Margherita Pizza',
        description: 'Classic wood-fired pizza with San Marzano tomatoes, fresh mozzarella and basil',
        price: 380,
        imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=500',
        category: 'Pizza',
        rating: 4.6,
        reviewCount: 892,
        prepTime: 20,
        isVeg: true,
        tags: ['Italian', 'Crispy', 'Classic'],
        restaurantName: 'Pizza Palazzo',
        restaurantLat: 19.0830,
        restaurantLng: 72.8900,
      ),
      FoodItem(
        id: '3',
        name: 'Chicken Biryani',
        description: 'Fragrant basmati rice layered with marinated chicken, saffron and fried onions',
        price: 280,
        imageUrl: 'https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=500',
        category: 'Rice',
        rating: 4.9,
        reviewCount: 2100,
        prepTime: 35,
        isVeg: false,
        tags: ['Aromatic', 'Best Seller', 'Spicy'],
        restaurantName: 'Biryani House',
        restaurantLat: 19.0680,
        restaurantLng: 72.8650,
      ),
      FoodItem(
        id: '4',
        name: 'Masala Dosa',
        description: 'Crispy rice crepe stuffed with spiced potato filling, served with coconut chutney',
        price: 120,
        imageUrl: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=500',
        category: 'Breakfast',
        rating: 4.7,
        reviewCount: 650,
        prepTime: 15,
        isVeg: true,
        tags: ['South Indian', 'Crispy', 'Light'],
        restaurantName: 'Udupi Diner',
        restaurantLat: 19.0900,
        restaurantLng: 72.8700,
      ),
      FoodItem(
        id: '5',
        name: 'Paneer Tikka',
        description: 'Marinated cottage cheese cubes grilled in tandoor with bell peppers and onions',
        price: 260,
        imageUrl: 'https://images.unsplash.com/photo-1567188040759-fb8a883dc6d8?w=500',
        category: 'Starters',
        rating: 4.5,
        reviewCount: 430,
        prepTime: 20,
        isVeg: true,
        tags: ['Grilled', 'Smoky', 'Protein'],
        restaurantName: 'Spice Garden',
        restaurantLat: 19.0760,
        restaurantLng: 72.8777,
      ),
      FoodItem(
        id: '6',
        name: 'Beef Burger',
        description: 'Juicy 150g beef patty with cheddar, lettuce, tomato and our secret house sauce',
        price: 350,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500',
        category: 'Burgers',
        rating: 4.4,
        reviewCount: 780,
        prepTime: 18,
        isVeg: false,
        tags: ['Juicy', 'Loaded', 'American'],
        restaurantName: 'Burger Barn',
        restaurantLat: 19.0720,
        restaurantLng: 72.8850,
      ),
      FoodItem(
        id: '7',
        name: 'Pad Thai',
        description: 'Stir-fried rice noodles with shrimp, tofu, peanuts in tangy tamarind sauce',
        price: 290,
        imageUrl: 'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=500',
        category: 'Asian',
        rating: 4.6,
        reviewCount: 520,
        prepTime: 22,
        isVeg: false,
        tags: ['Thai', 'Noodles', 'Tangy'],
        restaurantName: 'Bangkok Street',
        restaurantLat: 19.0810,
        restaurantLng: 72.8820,
      ),
      FoodItem(
        id: '8',
        name: 'Chocolate Lava Cake',
        description: 'Warm dark chocolate cake with a gooey molten center, served with vanilla ice cream',
        price: 180,
        imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=500',
        category: 'Desserts',
        rating: 4.9,
        reviewCount: 340,
        prepTime: 15,
        isVeg: true,
        tags: ['Sweet', 'Indulgent', 'Chocolate'],
        restaurantName: 'Sweet Cravings',
        restaurantLat: 19.0750,
        restaurantLng: 72.8760,
      ),
    ];
  }

  static List<String> getCategories() {
    return ['All', 'Main Course', 'Pizza', 'Rice', 'Breakfast', 'Starters', 'Burgers', 'Asian', 'Desserts'];
  }
}
