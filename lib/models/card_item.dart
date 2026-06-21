class CardItem {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  CardItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory CardItem.fromJson(Map<String, dynamic> json) {
    return CardItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image'],
      category: json['category'],
    );
  }
}

final List<Map<String, dynamic>> mintifyRawJson = [
  {
    "id": 1,
    "title": "Charizard Base Set",
    "description": "1999 Shadowless holographic card in pristine mint condition. Highly collectible.",
    "price": 299.99,
    "category": "Cards",
    "image": "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500"
  },
  {
    "id": 2,
    "title": "Retro Mecha Funko",
    "description": "Exclusive glow-in-the-dark vinyl figure, vaulted special edition.",
    "price": 45.50,
    "category": "Figures",
    "image": "https://images.unsplash.com/photo-1566577134770-3d85bb3a9cc4?w=500"
  },
  {
    "id": 3,
    "title": "Cyberpunk Comic #1",
    "description": "First print edition with variant cover art, graded 9.8 by CGC.",
    "price": 80.00,
    "category": "Comics",
    "image": "https://images.unsplash.com/photo-1612036782180-6f0b6cd846fe?w=500"
  },
  {
    "id": 4,
    "title": "Pikachu Illustrator",
    "description": "Extremely rare promotional card. One of the holy grails of card collecting.",
    "price": 999.99,
    "category": "Cards",
    "image": "https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=500"
  }
];