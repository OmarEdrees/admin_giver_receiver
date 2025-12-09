// import 'package:admin_giver_receiver/logic/services/colors_app.dart';
// import 'package:admin_giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';
// import 'package:flutter/material.dart';

// class ChatsScreen extends StatefulWidget {
//   const ChatsScreen({super.key});

//   @override
//   State<ChatsScreen> createState() => _ChatsScreenState();
// }

// class _ChatsScreenState extends State<ChatsScreen> {
//   String? imagePath; // مسار الصورة (يمكن تغييره حسب الحاجة)
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomHeader(icon: Icons.chat, title: 'Chats'),
//           SizedBox(height: 15),
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [Colors.white, Colors.white, Color(0xFF17A589)],
//                   stops: [0.0, 0.7, 1.5],
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 15),
//               child: Column(
//                 children: [
//                   // 🔹 حقل البحث
//                   Row(
//                     children: [
//                       Expanded(
//                         flex: 5,
//                         child: TextFormField(
//                           //controller: doctorsScreenSearch,
//                           cursorColor: AppColors().primaryColor,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.grey[300],
//                             hintText: 'Search for items',
//                             prefixIcon: Icon(
//                               Icons.search,
//                               color: AppColors().primaryColor,
//                             ),
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                           //onChanged: _onSearchChanged,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         flex: 1,
//                         child: GestureDetector(
//                           // onTap: _showFilterSheet,
//                           child: Container(
//                             height: 55,
//                             decoration: BoxDecoration(
//                               color: Colors.grey[300],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             child: Icon(
//                               Icons.filter_list,
//                               color: AppColors().primaryColor,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Expanded(
//                     child: ListView.builder(
//                       padding: EdgeInsets.zero,
//                       itemCount: 10,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           padding: EdgeInsets.only(left: 10),
//                           margin: EdgeInsets.only(bottom: 10),
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: ListTile(
//                             contentPadding: EdgeInsets.zero,
//                             horizontalTitleGap: 10,
//                             title: const Text(
//                               'Wael',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             subtitle: Row(
//                               children: [
//                                 Icon(
//                                   Icons.medical_services_outlined,
//                                   size: 18,
//                                   color: AppColors().primaryColor,
//                                 ),
//                                 SizedBox(width: 5),
//                                 Text(
//                                   'Music Therapist',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey[700],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             trailing: Padding(
//                               padding: const EdgeInsets.only(right: 10, top: 2),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     padding: EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 3,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: AppColors().primaryColor,
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: Text(
//                                       '10:38 PM',
//                                       style: TextStyle(
//                                         letterSpacing: -0.5,
//                                         color: Colors.white,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ),
//                                   // Text(
//                                   //   '10:38 PM',
//                                   //   style: TextStyle(
//                                   //     fontSize: 12.5,
//                                   //     color: Colors.grey[700],
//                                   //   ),
//                                   // ),
//                                 ],
//                               ),
//                             ),

//                             leading: Container(
//                               width: 55,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(50),
//                                 color: Colors.white,
//                               ),
//                               child: imagePath == null || imagePath!.isEmpty
//                                   ? const Icon(
//                                       Icons.person,
//                                       size: 30,
//                                       color: Colors.grey,
//                                     )
//                                   : ClipRRect(
//                                       borderRadius: BorderRadius.circular(50),
//                                       child: Image.asset(
//                                         imagePath!,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:admin_giver_receiver/logic/cubit/chat_cubit.dart';
import 'package:admin_giver_receiver/logic/cubit/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final myId = Supabase.instance.client.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadChat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final msg = state.messages[index];
                      final isMe = msg['id'] == myId;

                      return BubbleSpecialThree(
                        isSender: isMe,
                        text: msg['message'],
                        color: isMe
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                        tail: true,
                        textStyle: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),

          // Input
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Type message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (controller.text.trim().isEmpty) return;

                    context.read<ChatCubit>().sendMessage(
                      controller.text.trim(),
                    );

                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
