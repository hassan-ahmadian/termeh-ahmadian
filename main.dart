import 'package:flutter/material.dart';

void main() => runApp(const TermehApp());

const cream = Color(0xFFF9F5EF);
const navy = Color(0xFF183A43);
const gold = Color(0xFFB38A4A);

class Product {
  final String name;
  final String category;
  final int price;
  final IconData icon;
  const Product(this.name, this.category, this.price, this.icon);
}

const products = <Product>[
  Product('سرویس شاه‌نشین طرح اصیل', 'شاه‌نشین', 12800000, Icons.weekend_outlined),
  Product('پشتی سنتی ترمه', 'پشتی', 2450000, Icons.chair_outlined),
  Product('تشک نشیمن سنتی', 'تشک', 3900000, Icons.bed_outlined),
  Product('سرویس شاه‌نشین سفارشی', 'سفارشی', 16900000, Icons.auto_awesome_outlined),
  Product('کوسن ترمه ایرانی', 'کوسن', 890000, Icons.crop_square_outlined),
  Product('ست پشتی و نشیمن', 'شاه‌نشین', 7900000, Icons.chair_alt_outlined),
];

String money(int value) {
  final s = value.toString();
  return s.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',') + ' تومان';
}

class TermehApp extends StatelessWidget {
  const TermehApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'ترمه احمدیان',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, scaffoldBackgroundColor: cream, colorScheme: ColorScheme.fromSeed(seedColor: navy)),
    home: const Directionality(textDirection: TextDirection.rtl, child: StorePage()),
  );
}

class StorePage extends StatefulWidget {
  const StorePage({super.key});
  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final Map<int, int> cart = {};
  String filter = 'همه';
  String search = '';
  int page = 0;
  int get count => cart.values.fold(0, (a, b) => a + b);
  int get total => cart.entries.fold(0, (sum, entry) => sum + products[entry.key].price * entry.value);

  void add(int index) {
    setState(() => cart[index] = (cart[index] ?? 0) + 1);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('به سبد خرید اضافه شد'), duration: Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: navy,
      foregroundColor: Colors.white,
      title: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ترمه احمدیان', style: TextStyle(fontWeight: FontWeight.bold)), Text('زیبایی اصیل خانه ایرانی', style: TextStyle(fontSize: 11))]),
      actions: [IconButton(onPressed: () => setState(() => page = 1), icon: Badge(isLabelVisible: count > 0, label: Text('$count'), child: const Icon(Icons.shopping_bag_outlined)))],
    ),
    body: page == 0 ? store() : cartPage(),
    bottomNavigationBar: NavigationBar(
      selectedIndex: page,
      onDestinationSelected: (i) => setState(() => page = i),
      destinations: const [NavigationDestination(icon: Icon(Icons.storefront_outlined), label: 'فروشگاه'), NavigationDestination(icon: Icon(Icons.shopping_cart_outlined), label: 'سبد خرید')],
    ),
  );

  Widget store() {
    final visible = <int>[];
    for (var i = 0; i < products.length; i++) {
      if ((filter == 'همه' || products[i].category == filter) && products[i].name.contains(search)) visible.add(i);
    }
    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(20)),
        child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.auto_awesome, color: gold, size: 32), SizedBox(height: 10), Text('هنر ایرانی، شکوه خانه شما', style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.bold)), SizedBox(height: 8), Text('سرویس شاه‌نشین، پشتی و محصولات سنتی با امکان سفارش اختصاصی', style: TextStyle(color: Colors.white70)), SizedBox(height: 10), Text('نسخه آزمایشی • تصاویر و قیمت‌ها نمونه هستند', style: TextStyle(color: Color(0xFFFFDDAA), fontSize: 11))]),
      ),
      const SizedBox(height: 18),
      TextField(onChanged: (s) => setState(() => search = s), decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'جست‌وجوی محصول...', filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none))),
      const SizedBox(height: 12),
      SizedBox(height: 45, child: ListView(scrollDirection: Axis.horizontal, children: ['همه', 'شاه‌نشین', 'پشتی', 'تشک', 'کوسن', 'سفارشی'].map((c) => Padding(padding: const EdgeInsets.only(left: 8), child: ChoiceChip(label: Text(c), selected: filter == c, onSelected: (_) => setState(() => filter = c)))).toList())),
      const SizedBox(height: 18),
      const Text('محصولات فروشگاه', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: navy)),
      const SizedBox(height: 12),
      if (visible.isEmpty) const Padding(padding: EdgeInsets.all(25), child: Center(child: Text('محصولی پیدا نشد'))),
      ...visible.map((i) => Card(color: Colors.white, margin: const EdgeInsets.only(bottom: 12), child: Padding(padding: const EdgeInsets.all(12), child: Row(children: [
        Container(width: 88, height: 92, decoration: BoxDecoration(color: const Color(0xFFF0E7DA), borderRadius: BorderRadius.circular(12)), child: Icon(products[i].icon, size: 43, color: gold)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(products[i].name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), const SizedBox(height: 5), Text(products[i].category, style: const TextStyle(color: Colors.grey)), const SizedBox(height: 5), Text(money(products[i].price), style: const TextStyle(color: navy, fontWeight: FontWeight.bold)), const SizedBox(height: 5), FilledButton.icon(onPressed: () => add(i), icon: const Icon(Icons.add_shopping_cart, size: 16), label: const Text('افزودن'), style: FilledButton.styleFrom(backgroundColor: navy))]))
      ])))),
    ]);
  }

  Widget cartPage() => ListView(padding: const EdgeInsets.all(18), children: [
    const Text('سبد خرید شما', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: navy)),
    const SizedBox(height: 14),
    if (cart.isEmpty) const Padding(padding: EdgeInsets.all(45), child: Center(child: Text('سبد خرید خالی است'))),
    ...cart.entries.map((e) => Card(color: Colors.white, child: ListTile(title: Text(products[e.key].name), subtitle: Text('${money(products[e.key].price)} × ${e.value}'), trailing: IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () => setState(() { if (e.value <= 1) { cart.remove(e.key); } else { cart[e.key] = e.value - 1; } })))),
    if (cart.isNotEmpty) ...[
      const SizedBox(height: 18),
      Text('جمع کل: ${money(total)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: navy)),
      const SizedBox(height: 16),
      FilledButton(onPressed: () => showDialog(context: context, builder: (context) => AlertDialog(title: const Text('سفارش آزمایشی'), content: const Text('این نسخه نمایشی است؛ سفارش ثبت نشده و هیچ پرداختی انجام نمی‌شود.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('متوجه شدم'))])), child: const Padding(padding: EdgeInsets.all(12), child: Text('ثبت سفارش آزمایشی'))),
    ]
  ]);
}
