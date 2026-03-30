import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/room_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/room_card.dart';
import 'room_details.dart';

class TenantHome extends StatefulWidget {
  const TenantHome({super.key});

  @override
  State<TenantHome> createState() => _TenantHomeState();
}

class _TenantHomeState extends State<TenantHome> {
  final _searchController = TextEditingController();
  String _selectedCity = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RoomProvider>(context, listen: false).loadRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);
    final filteredRooms = roomProvider.rooms.where((room) {
      final matchesSearch =
          room.title.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          room.location.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
      final matchesCity =
          _selectedCity == 'All' || room.location.contains(_selectedCity);
      return matchesSearch && matchesCity;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Rooms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by location or title',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: _selectedCity,
              items: ['All', 'Delhi', 'Mumbai', 'Bangalore', 'Chennai'].map((
                city,
              ) {
                return DropdownMenuItem(value: city, child: Text(city));
              }).toList(),
              onChanged: (value) => setState(() => _selectedCity = value!),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredRooms.length,
              itemBuilder: (context, index) {
                final room = filteredRooms[index];
                return RoomCard(
                  room: room,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RoomDetails(room: room),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
