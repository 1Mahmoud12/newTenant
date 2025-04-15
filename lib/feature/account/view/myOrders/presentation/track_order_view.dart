import 'package:dobzz_seller/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class TrackOrderView extends StatelessWidget {
  const TrackOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(AppImages.actionBlocked, fit: BoxFit.cover)),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TrackOrderBottomSheet(),
          ),
        ],
      ),
    );
  }
}

class TrackOrderBottomSheet extends StatelessWidget {
  const TrackOrderBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
              height: 7,
              width: 90,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Order Status',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 24,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Order status timeline
          const Column(
            children: [
              // Packing status (completed)
              TrackOrderItem(
                status: 'Packing',
                address: '233b Jack Warren Rd, Delta Junction, Alaska 99737',
                isCompleted: true,
                showConnector: true,
              ),

              // Picked status (completed)
              TrackOrderItem(
                status: 'Picked',
                address: '2417 Tongass Ave #111, Ketchikan, Alaska 99901',
                isCompleted: true,
                showConnector: true,
              ),

              // In Transit status (completed)
              TrackOrderItem(
                status: 'In Transit',
                address: '16 Rr 2, Ketchikan, Alaska 99901, USA',
                isCompleted: true,
                showConnector: true,
              ),

              // Delivered status (pending)
              TrackOrderItem(
                status: 'Delivered',
                address: '925 S Chugach St #APT 10, Alaska 99645',
                isCompleted: false,
                showConnector: false,
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Delivery person info
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                // Profile picture
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade300,
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://picsum.photos/200', // Placeholder image
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.person, size: 32, color: Colors.grey.shade700);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Delivery person info
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jacob Jones',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Delivery Guy',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Call button
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade200,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () {
                      // Handle call action
                    },
                    color: Colors.black,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrackOrderItem extends StatelessWidget {
  final String status;
  final String address;
  final bool isCompleted;
  final bool showConnector;

  const TrackOrderItem({
    Key? key,
    required this.status,
    required this.address,
    required this.isCompleted,
    required this.showConnector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status indicator column (dot and connector line)
        SizedBox(
          width: 24,
          child: Column(
            children: [
              // Status dot indicator
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Colors.black : Colors.white,
                  border: Border.all(
                    color: isCompleted ? Colors.black : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
              ),

              // Connector line
              if (showConnector)
                Container(
                  width: 2,
                  height: 65,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Status text info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCompleted ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
