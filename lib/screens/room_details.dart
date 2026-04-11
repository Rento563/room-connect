import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/room.dart';
import '../providers/auth_provider.dart';
import '../utils/supabase_queries.dart';

class RoomDetails extends StatefulWidget {
  final Room room;

  const RoomDetails({super.key, required this.room});

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  bool _isLoading = false;

  Future<void> _contactOwner() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Show message dialog
    final messageController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Owner'),
        content: TextField(
          controller: messageController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Write your message to the owner...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, 'send'),
            child: const Text('Send'),
          ),
        ],
      ),
    );
    if (result == 'send' && messageController.text.isNotEmpty) {
      setState(() => _isLoading = true);
      try {
        await SupabaseQueries.sendMessage(
          roomId: widget.room.id,
          tenantId: authProvider.currentUser!.id,
          message: messageController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message sent to owner!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final isOwner = authProvider.currentUser?.id == widget.room.ownerId;

    return Scaffold(
      appBar: AppBar(title: Text(widget.room.title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image gallery
                  if (widget.room.images.isNotEmpty)
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.room.images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.network(
                              widget.room.images[index],
                              width: 300,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 300,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, size: 50),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.home, size: 50),
                    ),

                  const SizedBox(height: 16),

                  // Price
                  Text(
                    '₹${widget.room.price.toStringAsFixed(0)}/month',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(widget.room.location),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Room type
                  Chip(label: Text(widget.room.roomType)),

                  const SizedBox(height: 16),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.room.description),

                  const SizedBox(height: 16),

                  // Amenities
                  if (widget.room.amenities.isNotEmpty) ...[
                    const Text(
                      'Amenities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      children: widget.room.amenities
                          .map((amenity) => Chip(label: Text(amenity)))
                          .toList(),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Contact Owner button (only for tenants, not owner)
                  if (!isOwner)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _contactOwner,
                        icon: const Icon(Icons.message),
                        label: const Text('Contact Owner'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}