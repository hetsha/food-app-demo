const { PrismaClient } = require('@prisma/client');
const crypto = require('crypto');
const prisma = new PrismaClient();

function uuid() { return crypto.randomUUID(); }

const now = new Date();
const tomorrow = new Date(now); tomorrow.setDate(tomorrow.getDate() + 1);
const nextWeek = new Date(now); nextWeek.setDate(nextWeek.getDate() + 7);
const nextMonth = new Date(now); nextMonth.setMonth(nextMonth.getMonth() + 1);

async function main() {
  console.log('Seeding database...');

  // ── Categories ──
  const categories = await Promise.all([
    prisma.category.upsert({ where: { name: 'Thali' }, update: {}, create: { id: uuid(), name: 'Thali', icon: '🍛', displayOrder: 1 } }),
    prisma.category.upsert({ where: { name: 'Rice & Biryani' }, update: {}, create: { id: uuid(), name: 'Rice & Biryani', icon: '🍚', displayOrder: 2 } }),
    prisma.category.upsert({ where: { name: 'Breads' }, update: {}, create: { id: uuid(), name: 'Breads', icon: '🫓', displayOrder: 3 } }),
    prisma.category.upsert({ where: { name: 'Snacks' }, update: {}, create: { id: uuid(), name: 'Snacks', icon: '🥟', displayOrder: 4 } }),
    prisma.category.upsert({ where: { name: 'South Indian' }, update: {}, create: { id: uuid(), name: 'South Indian', icon: '🫕', displayOrder: 5 } }),
    prisma.category.upsert({ where: { name: 'Healthy Bowls' }, update: {}, create: { id: uuid(), name: 'Healthy Bowls', icon: '🥗', displayOrder: 6 } }),
    prisma.category.upsert({ where: { name: 'Desserts' }, update: {}, create: { id: uuid(), name: 'Desserts', icon: '🍮', displayOrder: 7 } }),
    prisma.category.upsert({ where: { name: 'Beverages' }, update: {}, create: { id: uuid(), name: 'Beverages', icon: '🥤', displayOrder: 8 } }),
  ]);
  const [thali, rice, breads, snacks, southIndian, healthy, desserts, beverages] = categories;
  console.log(`Created ${categories.length} categories`);

  // ── Food Items ──
  const foods = [
    { name: 'Gujarati Thali', description: 'Complete Gujarati meal with dal, kadhi, sabzi, rice, roti, papad, pickle and sweet', price: 180, originalPrice: 220, categoryId: thali.id, isVeg: true, isBestseller: true, isHealthyPick: false, rating: 4.8, reviewsCount: 245, calories: 650, preparationTimeMinutes: 25, imageUrls: ['https://images.unsplash.com/photo-1546833998-877b37c2e5c6?w=400'] },
    { name: 'Punjabi Thali', description: 'Hearty Punjabi meal with paneer, dal makhani, rice, naan, raita and gulab jamun', price: 220, originalPrice: 260, categoryId: thali.id, isVeg: true, isBestseller: true, rating: 4.7, reviewsCount: 189, calories: 750, preparationTimeMinutes: 30, imageUrls: ['https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400'] },
    { name: 'Rajasthani Thali', description: 'Authentic Rajasthani spread with dal baati churma, ker sangri, gatte ki sabzi', price: 240, originalPrice: 280, categoryId: thali.id, isVeg: true, isBestseller: false, rating: 4.6, reviewsCount: 132, calories: 700, preparationTimeMinutes: 35, imageUrls: ['https://images.unsplash.com/photo-1567337710282-00832b415979?w=400'] },
    { name: 'Chicken Biryani', description: 'Fragrant basmati rice layered with tender chicken, saffron, and aromatic spices', price: 250, originalPrice: 300, categoryId: rice.id, isVeg: false, isBestseller: true, isHealthyPick: false, rating: 4.9, reviewsCount: 312, calories: 550, preparationTimeMinutes: 30, imageUrls: ['https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=400'] },
    { name: 'Paneer Biryani', description: 'Fragrant rice with marinated paneer, mint raita, and whole spices', price: 200, originalPrice: 240, categoryId: rice.id, isVeg: true, isBestseller: true, rating: 4.5, reviewsCount: 178, calories: 480, preparationTimeMinutes: 25, imageUrls: ['https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=400'] },
    { name: 'Jeera Rice', description: 'Cumin flavored basmati rice, light and aromatic', price: 120, categoryId: rice.id, isVeg: true, rating: 4.3, reviewsCount: 95, calories: 300, preparationTimeMinutes: 15, imageUrls: ['https://images.unsplash.com/photo-1596560548464-f010549b84d7?w=400'] },
    { name: 'Butter Naan', description: 'Soft tandoori naan brushed with butter', price: 60, categoryId: breads.id, isVeg: true, rating: 4.6, reviewsCount: 201, calories: 250, preparationTimeMinutes: 10, imageUrls: ['https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400'] },
    { name: 'Garlic Naan', description: 'Naan loaded with garlic and coriander', price: 65, categoryId: breads.id, isVeg: true, rating: 4.5, reviewsCount: 167, calories: 260, preparationTimeMinutes: 10, imageUrls: ['https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400'] },
    { name: 'Tandoori Roti', description: 'Whole wheat roti cooked in clay oven', price: 30, categoryId: breads.id, isVeg: true, isHealthyPick: true, rating: 4.4, reviewsCount: 145, calories: 180, preparationTimeMinutes: 8, imageUrls: ['https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400'] },
    { name: 'Samosa (2 pcs)', description: 'Crispy pastry filled with spiced potato and peas', price: 40, categoryId: snacks.id, isVeg: true, isBestseller: true, rating: 4.7, reviewsCount: 289, calories: 200, preparationTimeMinutes: 15, imageUrls: ['https://images.unsplash.com/photo-1601050690597-df0568f70950?w=400'] },
    { name: 'Pav Bhaji', description: 'Mashed vegetable curry with butter toasted buns', price: 120, originalPrice: 140, categoryId: snacks.id, isVeg: true, rating: 4.6, reviewsCount: 198, calories: 450, preparationTimeMinutes: 20, imageUrls: ['https://images.unsplash.com/photo-1625220194771-7ebdea0b70b9?w=400'] },
    { name: 'Masala Dosa', description: 'Crispy rice crepe with spiced potato filling, sambar and chutney', price: 100, categoryId: southIndian.id, isVeg: true, isBestseller: true, rating: 4.8, reviewsCount: 267, calories: 350, preparationTimeMinutes: 15, imageUrls: ['https://images.unsplash.com/photo-1668236543090-82eba5ee5976?w=400'] },
    { name: 'Idli Sambar (4 pcs)', description: 'Steamed rice cakes with sambar and coconut chutney', price: 80, categoryId: southIndian.id, isVeg: true, isHealthyPick: true, rating: 4.5, reviewsCount: 156, calories: 250, preparationTimeMinutes: 12, imageUrls: ['https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=400'] },
    { name: 'Buddha Bowl', description: 'Quinoa, roasted veggies, chickpeas, avocado, tahini dressing', price: 280, categoryId: healthy.id, isVeg: true, isHealthyPick: true, rating: 4.7, reviewsCount: 134, calories: 380, preparationTimeMinutes: 20, imageUrls: ['https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400'] },
    { name: 'Grilled Chicken Salad', description: 'Grilled chicken breast with mixed greens, cherry tomatoes, olive oil', price: 250, categoryId: healthy.id, isVeg: false, isHealthyPick: true, rating: 4.6, reviewsCount: 98, calories: 320, preparationTimeMinutes: 15, imageUrls: ['https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'] },
    { name: 'Gulab Jamun (4 pcs)', description: 'Soft milk dumplings soaked in rose-flavored sugar syrup', price: 80, categoryId: desserts.id, isVeg: true, isBestseller: true, rating: 4.8, reviewsCount: 210, calories: 300, preparationTimeMinutes: 10, imageUrls: ['https://images.unsplash.com/photo-1666190099736-10f8b8a10f03?w=400'] },
    { name: 'Rasmalai (2 pcs)', description: 'Delicate cheese patties in saffron flavored milk', price: 100, categoryId: desserts.id, isVeg: true, rating: 4.7, reviewsCount: 145, calories: 250, preparationTimeMinutes: 10, imageUrls: ['https://images.unsplash.com/photo-1645177628172-a94c1f96e6db?w=400'] },
    { name: 'Mango Lassi', description: 'Refreshing yogurt drink with Alphonso mango pulp', price: 80, categoryId: beverages.id, isVeg: true, isHealthyPick: false, rating: 4.6, reviewsCount: 178, calories: 180, preparationTimeMinutes: 5, imageUrls: ['https://images.unsplash.com/photo-1527661591475-527312dd65f5?w=400'] },
    { name: 'Masala Chai', description: 'Traditional Indian spiced tea with ginger and cardamom', price: 30, categoryId: beverages.id, isVeg: true, rating: 4.5, reviewsCount: 312, calories: 60, preparationTimeMinutes: 5, imageUrls: ['https://images.unsplash.com/photo-1564890369478-c89ca6d9cde9?w=400'] },
    { name: 'Buttermilk', description: 'Cool and refreshing spiced buttermilk', price: 40, categoryId: beverages.id, isVeg: true, isHealthyPick: true, rating: 4.4, reviewsCount: 89, calories: 50, preparationTimeMinutes: 3, imageUrls: ['https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400'] },
  ];

  for (const food of foods) {
    await prisma.foodItem.create({
      data: {
        id: uuid(),
        name: food.name,
        description: food.description,
        price: food.price,
        originalPrice: food.originalPrice || null,
        imageUrls: food.imageUrls,
        categoryId: food.categoryId,
        isVeg: food.isVeg,
        isBestseller: food.isBestseller || false,
        isHealthyPick: food.isHealthyPick || false,
        isJainAvailable: false,
        isFastingFriendly: false,
        rating: food.rating,
        reviewsCount: food.reviewsCount,
        calories: food.calories,
        preparationTimeMinutes: food.preparationTimeMinutes,
        isActive: true,
      },
    });
  }
  console.log(`Created ${foods.length} food items`);

  // ── Banners ──
  await prisma.banner.createMany({
    data: [
      { id: uuid(), title: 'Welcome Offer', subtitle: 'Get 20% off on your first order', imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800', displayOrder: 1, startDate: now, endDate: nextMonth, isActive: true },
      { id: uuid(), title: 'Lunch Special', subtitle: 'Flat 15% off on thalis', imageUrl: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=800', displayOrder: 2, startDate: now, endDate: nextWeek, isActive: true },
      { id: uuid(), title: 'Healthy Eating', subtitle: 'Fresh salads & bowls starting at ₹199', imageUrl: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800', displayOrder: 3, startDate: now, endDate: nextMonth, isActive: true },
    ],
  });
  console.log('Created 3 banners');

  // ── Delivery Slots ──
  await prisma.deliverySlot.createMany({
    data: [
      { id: uuid(), name: 'Morning', startTime: '07:00', endTime: '09:00', maxOrders: 20, isActive: true, displayOrder: 1 },
      { id: uuid(), name: 'Lunch', startTime: '12:00', endTime: '14:00', maxOrders: 50, isActive: true, displayOrder: 2 },
      { id: uuid(), name: 'Evening', startTime: '18:00', endTime: '20:00', maxOrders: 40, isActive: true, displayOrder: 3 },
      { id: uuid(), name: 'Dinner', startTime: '20:00', endTime: '22:00', maxOrders: 40, isActive: true, displayOrder: 4 },
    ],
  });
  console.log('Created 4 delivery slots');

  // ── Subscriptions ──
  await prisma.subscription.createMany({
    data: [
      { id: uuid(), name: 'Weekly Veg', description: '7 days of healthy vegetarian meals', price: 1499, durationDays: 7, mealsCount: 14, mealType: 'lunch+dinner', benefits: JSON.stringify(['Free delivery', '20% off regular price', 'Priority delivery']), isActive: true },
      { id: uuid(), name: 'Monthly All Meals', description: '30 days of complete meal plan', price: 5499, durationDays: 30, mealsCount: 60, mealType: 'breakfast+lunch+dinner', benefits: JSON.stringify(['Free delivery', '25% off regular price', 'Priority delivery', 'Free dessert daily']), isActive: true },
      { id: uuid(), name: 'Weekly Non-Veg', description: '7 days of protein-rich non-veg meals', price: 1799, durationDays: 7, mealsCount: 14, mealType: 'lunch+dinner', benefits: JSON.stringify(['Free delivery', '20% off regular price', 'Fresh chicken/fish daily']), isActive: true },
    ],
  });
  console.log('Created 3 subscriptions');

  // ── Settings ──
  await prisma.setting.upsert({
    where: { key: 'app_config' },
    update: {},
    create: {
      key: 'app_config',
      value: JSON.stringify({
        deliveryFee: 30,
        platformFee: 2,
        freeDeliveryMinOrder: 250,
        taxRate: 5,
        minOrderValue: 99,
      }),
      valueType: 'json',
      description: 'App configuration settings',
    },
  });
  console.log('Created app config settings');

  console.log('\nSeed complete!');
  await prisma.$disconnect();
}

main().catch((e) => { console.error(e); process.exit(1); });
