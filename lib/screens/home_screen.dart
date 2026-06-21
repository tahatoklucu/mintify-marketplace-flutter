import 'package:flutter/material.dart';
import '../models/card_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<CardItem> _allItems = mintifyRawJson.map((json) => CardItem.fromJson(json)).toList();
  List<CardItem> _filteredItems = [];
  
  final List<CardItem> _cartItems = [];
  
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredItems = _allItems;
  }

  void _filterProducts() {
    setState(() {
      _filteredItems = _allItems.where((item) {
        final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
        final matchesSearch = item.title.toLowerCase().contains(_searchQuery.toLowerCase());
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _addToCart(CardItem item) {
    setState(() {
      _cartItems.add(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} sepete eklendi!'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showCartBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sepetiniz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Divider(),
                  _cartItems.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 30.0),
                          child: Center(child: Text('Sepetiniz boş!', style: TextStyle(color: Colors.grey, fontSize: 15))),
                        )
                      : Flexible(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              final cartItem = _cartItems[index];
                              return ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: Image.network(cartItem.imageUrl, width: 40, height: 40, fit: BoxFit.cover),
                                ),
                                title: Text(cartItem.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                                subtitle: Text('\$${cartItem.price}', style: const TextStyle(color: Colors.indigo)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _cartItems.removeAt(index);
                                    });
                                    setModalState(() {});
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                  if (_cartItems.isNotEmpty) ...[
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Toplam:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(
                            '\$${_cartItems.fold<double>(0, (sum, item) => sum + item.price).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mintify Marketplace', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined),
                onPressed: _showCartBottomSheet,
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(color: Colors.indigo, shape: BoxShape.circle),
                    constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
                      '${_cartItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 110,
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/TradingCards.webp',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Text('Mintify Live Banner Area', style: TextStyle(color: Colors.black38)));
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Koleksiyon öğesi ara...',
                prefixIcon: Icon(Icons.search, size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _filterProducts();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['All', 'Cards', 'Figures', 'Comics'].map((cat) {
                final isSel = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat, style: const TextStyle(fontSize: 12)),
                  selected: isSel,
                  onSelected: (selected) {
                    if (selected) {
                      _selectedCategory = cat;
                      _filterProducts();
                    }
                  },
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(child: Text('Sonuç bulunamadı.'))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _filteredItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.95,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pushNamed(context, '/detail', arguments: item);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(item.imageUrl, fit: BoxFit.contain),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(item.category, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('\$${item.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo, fontSize: 13)),
                                    IconButton(
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.add_circle, color: Colors.indigo, size: 22),
                                      onPressed: () => _addToCart(item),
                                    ),
                                  ],
                                )
                              ],
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
}