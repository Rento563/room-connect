import 'package:flutter/material.dart';
import '../models/room.dart';

class RoomDetails extends StatelessWidget {
  final Room room;

  const RoomDetails({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(room.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: room.images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.network(
                      room.images[index],
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '₹${room.price}/month',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(room.location),
            const SizedBox(height: 16),
            Text(
              'Description',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(room.description),
            const SizedBox(height: 16),
            Text(
              'Amenities',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: room.amenities
                  .map((amenity) => Chip(label: Text(amenity)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Contact owner logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contacting owner...')),
                );
              },
              child: const Text('Contact Owner'),
            ),
          ],
        ),
      ),
    );
  }
}
