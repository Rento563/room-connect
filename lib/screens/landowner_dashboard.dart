import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/room_provider.dart';
import '../widgets/room_card.dart';
import 'add_room_screen.dart';
import 'room_details.dart';

class LandownerDashboard extends StatefulWidget {
  const LandownerDashboard({super.key});

  @override
  State<LandownerDashboard> createState() => _LandownerDashboardState();
}

class _LandownerDashboardState extends State<LandownerDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RoomProvider>(context, listen: false).loadRooms();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final roomProvider = Provider.of<RoomProvider>(context);
    final userRooms = roomProvider.getRoomsByOwner(
      authProvider.currentUser!.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rooms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              context.go('/login');
            },
          ),
        ],
      ),
      body: userRooms.isEmpty
          ? const Center(child: Text('No rooms added yet.'))
          : ListView.builder(
              itemCount: userRooms.length,
              itemBuilder: (context, index) {
                final room = userRooms[index];
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddRoomScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
