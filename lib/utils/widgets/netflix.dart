// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter/services.dart';

// class NetflixStyleControls extends MaterialControls {
//   const NetflixStyleControls({super.key});
//   final

//   @override
//   State<NetflixStyleControls> createState() => _NetflixStyleControlsState();
// }

// class _NetflixStyleControlsState extends State<NetflixStyleControls> {
  
//   Timer? _hideTimer;
//   bool _visible = true;

//   @override
//   void initState() {
//     super.initState();
//     _startHideTimer();
//   }

//   void _startHideTimer() {
//     _hideTimer?.cancel();
//     _hideTimer = Timer(const Duration(seconds: 3), () {
//       setState(() {
//         _visible = false;
//       });
//     });
//   }

//   void _toggleControls() {
//     setState(() {
//       _visible = !_visible;
//     });
//     if (_visible) _startHideTimer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _toggleControls,
//       child: Stack(
//         children: [
//           AnimatedOpacity(
//             opacity: _visible ? 1.0 : 0.0,
//             duration: const Duration(milliseconds: 300),
//             child: Container(
//               color: Colors.black45,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildTopBar(),
//                   _buildCenterPlayPause(),
//                   _buildBottomBar(context),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTopBar() {
//     return const Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Icon(Icons.arrow_back, color: Colors.white),
//         ),
//         Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Icon(Icons.more_vert, color: Colors.white),
//         ),
//       ],
//     );
//   }

//   Widget _buildCenterPlayPause() {
//     return Center(
//       child: IconButton(
//         iconSize: 60,
//         icon: Icon(
//           controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
//           color: Colors.white,
//         ),
//         onPressed: () {
//           controller.value.isPlaying ? controller.pause() : controller.play();
//           _startHideTimer();
//         },
//       ),
//     );
//   }

//   Widget _buildBottomBar(BuildContext context) {
//     return Column(
//       children: [
//         VideoProgressIndicator(
//           controller,
//           allowScrubbing: true,
//           colors: const VideoProgressColors(
//             playedColor: Colors.red,
//             backgroundColor: Colors.white30,
//             bufferedColor: Colors.grey,
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               icon: Icon(
//                 controller.value.volume > 0 ? Icons.volume_up : Icons.volume_off,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 controller.setVolume(controller.value.volume > 0 ? 0.0 : 1.0);
//               },
//             ),
//             IconButton(
//               icon: const Icon(Icons.fullscreen, color: Colors.white),
//               onPressed: () {
//                 chewieController!.enterFullScreen();
//               },
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _hideTimer?.cancel();
//     super.dispose();
//   }
// }
