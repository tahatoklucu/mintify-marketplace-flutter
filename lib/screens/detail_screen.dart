import 'package:flutter/material.dart';
import '../models/card_item.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final item = ModalRoute.of(context)!.settings.arguments as CardItem;

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 260,
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Image.network(item.imageUrl, fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(label: Text(item.category, style: const TextStyle(fontSize: 12))),
                      Text(
                        '\$${item.price}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(item.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  const Divider(),
                  const SizedBox(height: 6),
                  const Text('Öğe Detay Bilgisi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black54)),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: TextStyle(color: Colors.grey[800], fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}