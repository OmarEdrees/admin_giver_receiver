// ---------------------------------------------------------------------
//   CONTROLLER + UI Builder for Requests Screen
// ---------------------------------------------------------------------

import 'package:admin_giver_receiver/logic/cubit/chat_cubit.dart';
import 'package:admin_giver_receiver/logic/services/BottomNavigationBar/requests_screen_services/requests_screen_services.dart';
import 'package:admin_giver_receiver/logic/services/colors_app.dart';
import 'package:admin_giver_receiver/logic/services/variables_app.dart';
import 'package:admin_giver_receiver/presentation/screens/BottomNavigationBar/chats/chat_screen.dart';
import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/items_screen/items_card/button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RequestsScreenWidgets {
  final RequestsScreenServices _req = RequestsScreenServices();
  Function()? refreshUi;
  List<Map<String, dynamic>> allRequests = [];
  List<Map<String, dynamic>> filteredRequests = [];
  String selectedStatus = "All";
  final supabase = Supabase.instance.client;
  // late final adminId = supabase.auth.currentUser!.id;

  RequestsScreenWidgets({this.refreshUi});

  // ------------------- تحميل الطلبات -------------------
  Future<void> loadRequests() async {
    allRequests = await _req.getAllRequestsForAdmin();
    filteredRequests = List.from(allRequests);
  }

  // ------------------- فلترة الطلبات -------------------
  void applyFilters(String searchText) {
    filteredRequests = allRequests.where((req) {
      final reason = req["reason"].toString().toLowerCase();
      final matchReason = reason.contains(searchText.toLowerCase());

      final matchStatus = selectedStatus == "All"
          ? true
          : req["status"] == selectedStatus;

      return matchReason && matchStatus;
    }).toList();
  }

  // ------------------- تحديث الحالة -------------------
  Future<void> approveRequest(String id) async {
    await _req.updateStatus(id, "approve");
    await loadRequests();
    if (refreshUi != null) refreshUi!();
  }

  Future<void> rejectRequest(String id) async {
    await _req.updateStatus(id, "reject");
    await loadRequests();
    if (refreshUi != null) refreshUi!();
  }

  Future<void> convertToDelivery(String id) async {
    await _req.updateStatus(id, "delivered");
    await loadRequests();
    if (refreshUi != null) refreshUi!();
  }

  ///////////////////////////////////////////////////////////////
  String generateChatId(String donorId, String requesterId) {
    final sortedIds = [donorId, requesterId]..sort();
    return "${sortedIds[0]}_${sortedIds[1]}";
  }

  // ------------------- فتح الشات -------------------
  void openChatRecipient({
    required BuildContext context,
    required String adminId,
    required String recipientId,
    required String recipientName,
    required String recipientImage,
  }) {
    final ids = [adminId, recipientId]..sort();
    final chatId = "${ids[0]}_${ids[1]}";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminChatCubit(
            chatId: chatId,
            adminId: adminId,
            recipientId: recipientId,
          )..loadChat(),
          child: ChatScreen(
            chatId: chatId,
            recipientName: recipientName,
            recipientImage: recipientImage,
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////
  // ------------------- فتح الشات -------------------
  void openChatDonor({
    required BuildContext context,
    required String adminId,
    required String donorId,
    required String donorName,
    required String donorImage,
  }) {
    final ids = [adminId, donorId]..sort();
    final chatId = "${ids[0]}_${ids[1]}";

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AdminChatCubit(
            chatId: chatId,
            adminId: adminId,
            recipientId: donorId,
          )..loadChat(),
          child: ChatScreen(
            chatId: chatId,
            recipientName: donorName,
            recipientImage: donorImage,
          ),
        ),
      ),
    );
  }

  // ------------------- الكارد -------------------
  Widget buildRequestCard(BuildContext context, Map<String, dynamic> req) {
    final itemName = req["user_items"]?["title"] ?? "Unknown Item";
    final donorImage = req["donor"]?["image"] ?? "Unknown Requester";
    final donorName = req["donor"]?["full_name"] ?? "Unknown Donor";
    final donorId = req["donor"]?["id"] ?? "Unknown Donor";
    final requesterName = req["requester"]?["full_name"] ?? "Unknown Requester";
    final requesterImage = req["requester"]?["image"] ?? "Unknown Requester";
    final requesterId = req["requester"]?["id"] ?? "Unknown Requester";
    final reason = req["reason"];
    final imageUrl = req["attachment_url"];
    final status = req["status"];
    final timeAgo = formatTime(req["created_at"]);

    Color statusColor = status == "approve"
        ? Colors.green
        : status == "reject"
        ? Colors.red
        : status == "delivered"
        ? Colors.blue
        : Colors.orange;

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade400, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- HEADER ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ),

              // ----- Status Badge -----
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor, width: 1.2),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Divider(thickness: 1, color: Colors.grey.shade500),
          const SizedBox(height: 4),
          // ---------------- DONOR & REQUESTER ----------------
          Row(
            children: [
              Icon(
                Icons.volunteer_activism,
                color: AppColors().primaryColor,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "الواهب: $donorName",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              GestureDetector(
                onTap: () async {
                  openChatDonor(
                    context: context,
                    adminId: supabase.auth.currentUser!.id,
                    donorId: donorId,
                    donorName: donorName,
                    donorImage: donorImage,
                    // recipientId: donorId,
                    // recipientName: donorName,
                    // recipientImage: donorImage,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors().primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors().primaryColor,
                      width: 1.2,
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.chat_bubble_fill,
                    color: AppColors().primaryColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),
          Divider(thickness: 1, color: Colors.grey.shade500),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.person, color: AppColors().primaryColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "الموهوب: $requesterName",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Divider(thickness: 1, color: Colors.grey.shade500),
          const SizedBox(height: 20),

          // ---------------- DETAILS ----------------
          Row(
            children: [
              Icon(
                Icons.description,
                color: AppColors().primaryColor,
                size: 22,
              ),
              const SizedBox(width: 10),
              const Text(
                "تفاصيل الطلب",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            reason,
            style: TextStyle(
              fontSize: 15,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 10),

          // ---------------- IMAGE ----------------
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: imageUrl != null
                ? Image.network(
                    imageUrl,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.grey[400],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                      size: 45,
                    ),
                  ),
          ),

          const SizedBox(height: 25),

          // ---------------- BUTTONS ----------------
          buildButtons(
            context,
            status,
            req["id"],
            donorId,
            requesterId,
            requesterName,
            requesterImage,
          ),
        ],
      ),
    );
  }

  // ------------------- الأزرار -------------------
  Widget buildButtons(
    BuildContext context,
    String status,
    String id,
    String donorId,
    String requesterId,
    String recipientName,
    String recipientImage,
  ) {
    // ---------------------- حالة PENDING ----------------------
    if (status == "pending") {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  icon: Icons.check_circle,
                  title: "Approve",
                  ontap: () async {
                    await approveRequest(id);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ButtonWidget(
                  icon: Icons.cancel,
                  title: "Reject",
                  ontap: () async {
                    await rejectRequest(id);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ButtonWidget(
            icon: Icons.chat_bubble_outline,
            title: "Open Chat Session",
            ontap: () async {
              openChatRecipient(
                context: context,
                adminId: donorId,
                recipientId: requesterId,
                recipientName: recipientName,
                recipientImage: recipientImage,
              );
            },
          ),
        ],
      );
    }

    // ---------------------- حالة APPROVED ----------------------
    if (status == "approve") {
      return Column(
        children: [
          ButtonWidget(
            icon: Icons.delivery_dining,
            title: "Convert to Delivery/Pickup",
            ontap: () async {
              await convertToDelivery(id);
            },
          ),

          const SizedBox(height: 10),

          ButtonWidget(
            icon: Icons.chat_bubble_outline,
            title: "Open Chat Session",
            ontap: () async {
              openChatRecipient(
                context: context,
                adminId: donorId,
                recipientId: requesterId,
                recipientName: recipientName,
                recipientImage: recipientImage,
              );
            },
          ),
        ],
      );
    }

    // ---------------------- أي حالة أخرى (Rejected / Delivery) ----------------------
    return ButtonWidget(
      icon: Icons.chat_bubble,
      title: "Open Chat Session",
      ontap: () async {
        openChatRecipient(
          context: context,
          adminId: donorId,
          recipientId: requesterId,
          recipientName: recipientName,
          recipientImage: recipientImage,
        );
      },
    );
  }
}
