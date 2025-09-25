import 'package:flutter/material.dart';

class WatchlistOptionDialog extends StatelessWidget {
  const WatchlistOptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A), 
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Top Row - Song Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    "https://via.placeholder.com/50", // song cover
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Le Aaunga",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Arijit Singh",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.thumb_up_alt_outlined, color: Colors.white),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Top 3 Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTopButton(Icons.play_arrow, "Play next"),
                _buildTopButton(Icons.playlist_add, "Save to Playlist"),
                _buildTopButton(Icons.share, "Share"),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(color: Colors.grey),

            /// Menu Items
            _buildMenuItem(Icons.queue_music, "Add to queue"),
            _buildMenuItem(Icons.library_add, "Save to Library"),
            _buildMenuItem(Icons.download, "Download"),
            _buildMenuItem(Icons.album, "Go to Album"),
            _buildMenuItem(Icons.push_pin, "Pin to Speed dial"),
            _buildMenuItem(Icons.close, "Not interested"),
          ],
        ),
      ),
    );
  }

  Widget _buildTopButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}