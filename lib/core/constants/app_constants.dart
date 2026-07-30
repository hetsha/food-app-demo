class AppConstants {
  static const String appName = 'Ambo';
  
  // Storage Keys
  static const String keyUserLoggedIn = 'user_logged_in';
  static const String keyUserToken = 'user_token';
  static const String keyUserPhone = 'user_phone';
  static const String keyDarkTheme = 'dark_theme';
  static const String keyCartItems = 'cart_items';
  static const String keySubscriptions = 'user_subscriptions';
  static const String keyAddresses = 'user_addresses';
  static const String keyWishlist = 'user_wishlist';
}

// Model Classes to represent the database items cleanly.
class Meal {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final String category;
  final int calories;
  final int cookingTimeMinutes;
  final bool isVeg;
  final bool isBestSeller;
  final bool isHealthyPick;
  final List<String> ingredients;
  final Map<String, String> nutrition;

  const Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.category,
    required this.calories,
    required this.cookingTimeMinutes,
    required this.isVeg,
    this.isBestSeller = false,
    this.isHealthyPick = false,
    required this.ingredients,
    required this.nutrition,
  });
}

class SubscriptionPlan {
  final String id;
  final String name;
  final double price;
  final int durationDays;
  final String description;
  final List<String> benefits;
  final String imageUrl;

  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.price,
    required this.durationDays,
    required this.description,
    required this.benefits,
    required this.imageUrl,
  });
}

class Address {
  final String id;
  final String type; // Home, Work, Parents
  final String addressLine1;
  final String addressLine2;
  final String phone;

  const Address({
    required this.id,
    required this.type,
    required this.addressLine1,
    required this.addressLine2,
    required this.phone,
  });
}

class OfferBanner {
  final String id;
  final String title;
  final String subtitle;
  final String discountCode;
  final String imageUrl;
  final double discountPercent;

  const OfferBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.discountCode,
    required this.imageUrl,
    required this.discountPercent,
  });
}

// Complete Mock Database
final List<CategoryItem> mockCategories = [
  const CategoryItem(id: 'all', name: 'All', icon: '🍽️'),
  const CategoryItem(id: 'thali', name: 'Thali', icon: '🍛'),
  const CategoryItem(id: 'biryani', name: 'Biryani', icon: '🍲'),
  const CategoryItem(id: 'paratha', name: 'Paratha', icon: '🫓'),
  const CategoryItem(id: 'sabzi', name: 'Sabzi', icon: '🥦'),
  const CategoryItem(id: 'dal', name: 'Dal', icon: '🥣'),
];

class CategoryItem {
  final String id;
  final String name;
  final String icon;
  const CategoryItem({required this.id, required this.name, required this.icon});
}

final List<OfferBanner> mockOffers = [
  const OfferBanner(
    id: 'o1',
    title: 'Eat Healthy, Stay Strong',
    subtitle: 'Upto 20% OFF on Subscriptions',
    discountCode: 'HEALTH20',
    imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&q=80&w=600',
    discountPercent: 20,
  ),
  const OfferBanner(
    id: 'o2',
    title: 'Chef\'s Special Week',
    subtitle: 'Flat ₹100 OFF on premium meals',
    discountCode: 'CHEF100',
    imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&q=80&w=600',
    discountPercent: 15,
  ),
];

final List<Meal> mockMeals = [
  const Meal(
    id: 'm1',
    name: 'Gujarati Thali',
    description: 'An premium assortment of Gujarati delicacies containing 3 Rotli, Dal, Shaak (Sabzi), Rice, Papad, Salad and Buttermilk.',
    price: 150.0,
    originalPrice: 200.0,
    rating: 4.8,
    reviewsCount: 142,
    imageUrl: 'https://images.unsplash.com/photo-1626777552726-4a6b54c97e46?auto=format&fit=crop&q=80&w=600',
    category: 'thali',
    calories: 680,
    cookingTimeMinutes: 25,
    isVeg: true,
    isBestSeller: true,
    ingredients: ['Whole Wheat Flour', 'Toor Dal', 'Mix Vegetables', 'Basmati Rice', 'Buttermilk', 'Spices'],
    nutrition: {'Carbs': '88g', 'Protein': '18g', 'Fat': '14g', 'Fiber': '9g'},
  ),
  const Meal(
    id: 'm2',
    name: 'Paneer Sabzi with Rice',
    description: 'Cottage cheese cooked in homestyle rich tomato gravy served with hot steamed basmati rice.',
    price: 130.0,
    originalPrice: 170.0,
    rating: 4.7,
    reviewsCount: 98,
    imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?auto=format&fit=crop&q=80&w=600',
    category: 'sabzi',
    calories: 520,
    cookingTimeMinutes: 20,
    isVeg: true,
    isBestSeller: true,
    isHealthyPick: true,
    ingredients: ['Cottage Cheese', 'Tomatoes', 'Onion', 'Basmati Rice', 'Cashews', 'Fresh Cream'],
    nutrition: {'Carbs': '65g', 'Protein': '16g', 'Fat': '18g', 'Fiber': '5g'},
  ),
  const Meal(
    id: 'm3',
    name: 'Rajma Chawal',
    description: 'Red kidney beans simmered in a spiced tomato-onion reduction served over aromatic long-grain basmati rice.',
    price: 120.0,
    originalPrice: 150.0,
    rating: 4.9,
    reviewsCount: 310,
    imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?auto=format&fit=crop&q=80&w=600',
    category: 'dal',
    calories: 450,
    cookingTimeMinutes: 15,
    isVeg: true,
    isBestSeller: false,
    ingredients: ['Red Kidney Beans', 'Onions', 'Tomatoes', 'Ginger', 'Garlic', 'Basmati Rice'],
    nutrition: {'Carbs': '72g', 'Protein': '12g', 'Fat': '6g', 'Fiber': '11g'},
  ),
  const Meal(
    id: 'm4',
    name: 'Kadhi Chawal',
    description: 'Sour yogurt-based gram flour curry with soft vegetable pakoras, served with hot rice.',
    price: 110.0,
    originalPrice: 140.0,
    rating: 4.6,
    reviewsCount: 88,
    imageUrl: 'https://images.unsplash.com/photo-1601050690597-df056fb4ce78?auto=format&fit=crop&q=80&w=600',
    category: 'dal',
    calories: 490,
    cookingTimeMinutes: 18,
    isVeg: true,
    ingredients: ['Sour Yogurt', 'Gram Flour', 'Spices', 'Mustard Seeds', 'Basmati Rice'],
    nutrition: {'Carbs': '68g', 'Protein': '10g', 'Fat': '12g', 'Fiber': '4g'},
  ),
  const Meal(
    id: 'm5',
    name: 'Dal Tadka with Jeera Rice',
    description: 'Yellow lentils tempered with ghee, garlic, and red chilies, paired with fragrant cumin rice.',
    price: 100.0,
    originalPrice: 130.0,
    rating: 4.7,
    reviewsCount: 175,
    imageUrl: 'https://images.unsplash.com/photo-1626132647523-66f5bf380027?auto=format&fit=crop&q=80&w=600',
    category: 'dal',
    calories: 420,
    cookingTimeMinutes: 15,
    isVeg: true,
    isHealthyPick: true,
    ingredients: ['Arhar Dal', 'Ghee', 'Garlic', 'Dry Red Chili', 'Cumin Seeds', 'Basmati Rice'],
    nutrition: {'Carbs': '58g', 'Protein': '11g', 'Fat': '8g', 'Fiber': '7g'},
  ),
  const Meal(
    id: 'm6',
    name: 'Mix Veg Sabzi with Roti',
    description: 'Fresh seasonal vegetables cooked dry in home style mild spices, served with 3 butter tawa rotis.',
    price: 100.0,
    originalPrice: 130.0,
    rating: 4.5,
    reviewsCount: 64,
    imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&q=80&w=600',
    category: 'sabzi',
    calories: 380,
    cookingTimeMinutes: 20,
    isVeg: true,
    isHealthyPick: true,
    ingredients: ['Carrot', 'Beans', 'Potato', 'Cauliflower', 'Whole Wheat Flour', 'Spices'],
    nutrition: {'Carbs': '48g', 'Protein': '8g', 'Fat': '5g', 'Fiber': '8g'},
  ),
];

final List<SubscriptionPlan> mockSubscriptionPlans = [
  const SubscriptionPlan(
    id: 'sub1',
    name: 'Daily Lunch Plan',
    price: 2400.0,
    durationDays: 30,
    description: 'Healthy, home-style premium meals delivered to your desk daily.',
    benefits: ['1 Lunch per day', 'Free delivery', 'Pause/Skip anytime', 'Customizable Spice Level'],
    imageUrl: 'https://images.unsplash.com/photo-1543339308-43e59d6b73a6?auto=format&fit=crop&q=80&w=600',
  ),
  const SubscriptionPlan(
    id: 'sub2',
    name: 'Daily Lunch + Dinner',
    price: 4400.0,
    durationDays: 30,
    description: 'Ensure nutritional goodness twice a day, every day.',
    benefits: ['Lunch & Dinner daily', 'Free delivery', 'Weekly menu changes', 'Priority Support'],
    imageUrl: 'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&q=80&w=600',
  ),
  const SubscriptionPlan(
    id: 'sub3',
    name: 'Daily Breakfast, Lunch & Dinner',
    price: 6500.0,
    durationDays: 30,
    description: 'Full monthly wellness plan with zero cooking hassle.',
    benefits: ['3 Meals daily', 'Complimentary healthy snacks', 'Personal nutritionist advice', 'Custom delivery slots'],
    imageUrl: 'https://images.unsplash.com/photo-1505253716362-afaea1d3d1af?auto=format&fit=crop&q=80&w=600',
  ),
  const SubscriptionPlan(
    id: 'sub4',
    name: 'Weekly Plan (Lunch)',
    price: 1200.0,
    durationDays: 7,
    description: 'Try the Ambo goodness for a week.',
    benefits: ['7 Lunches', 'Free delivery', 'Customizable spice level', 'Skip anytime'],
    imageUrl: 'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?auto=format&fit=crop&q=80&w=600',
  ),
];

final List<Address> mockAddresses = [
  const Address(
    id: 'a1',
    type: 'Home',
    addressLine1: '501, Shilp Euphoria, Near Bopal Square',
    addressLine2: 'Ambli, Ahmedabad, Gujarat 380058',
    phone: '+91 98765 43210',
  ),
  const Address(
    id: 'a2',
    type: 'Work',
    addressLine1: '4th Floor, Midtown Corporate',
    addressLine2: 'SG Highway, Ahmedabad, Gujarat 380054',
    phone: '+91 98765 43211',
  ),
  const Address(
    id: 'a3',
    type: 'Parents Home',
    addressLine1: '22, Shyamal Park Society',
    addressLine2: 'Satellite, Ahmedabad, Gujarat 380015',
    phone: '+91 98765 43212',
  ),
];

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String type; // order, subscription, offer, other

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
  });
}

final List<NotificationItem> mockNotifications = [
  NotificationItem(
    id: 'n1',
    title: 'Order Confirmed',
    body: 'Your order #ORD12345 has been confirmed by the kitchen.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    type: 'order',
  ),
  NotificationItem(
    id: 'n2',
    title: 'Out for Delivery',
    body: 'Your order #ORD12345 is out for delivery with our rider Rohan.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    type: 'order',
  ),
  NotificationItem(
    id: 'n3',
    title: 'Delivered',
    body: 'Your order #ORD12343 has been successfully delivered. Enjoy!',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    type: 'order',
  ),
  NotificationItem(
    id: 'n4',
    title: 'Subscription Renewed',
    body: 'Your Daily Lunch Plan subscription has been renewed successfully.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    type: 'subscription',
  ),
  NotificationItem(
    id: 'n5',
    title: 'Offer Extended',
    body: 'Get 20% OFF on all plans. Use code: HAPPY20.',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    type: 'offer',
  ),
];
