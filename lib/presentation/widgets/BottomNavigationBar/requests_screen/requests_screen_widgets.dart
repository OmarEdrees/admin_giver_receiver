// ---------------------------------------------------------------------
//   CONTROLLER + UI Builder for Requests Screen
// ---------------------------------------------------------------------

import 'package:admin_giver_receiver/logic/services/BottomNavigationBar/requests_screen_services/requests_screen_services.dart';
import 'package:admin_giver_receiver/logic/services/colors_app.dart';
import 'package:admin_giver_receiver/logic/services/variables_app.dart';
import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/items_screen/items_card/button_widget.dart';
import 'package:flutter/material.dart';

class RequestsScreenWidgets {
  final RequestsScreenServices _req = RequestsScreenServices();
  Function()? refreshUi;
  List<Map<String, dynamic>> allRequests = [];
  List<Map<String, dynamic>> filteredRequests = [];
  String selectedStatus = "All";

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
    await _req.updateStatus(id, "Approved");
    await loadRequests();
    if (refreshUi != null) refreshUi!();
  }

  Future<void> rejectRequest(String id) async {
    await _req.updateStatus(id, "Rejected");
    await loadRequests();
    if (refreshUi != null) refreshUi!();
  }

  Future<void> convertToDelivery(String id) async {
    await _req.updateStatus(id, "Delivery");
    await loadRequests();
    if (refreshUi != null) refreshUi!();
  }

  // ------------------- فتح الشات -------------------
  void openChat(BuildContext context, String donorId, String requesterId) {
    // Navigator.pushNamed(
    //   context,
    //   "/chat",
    //   arguments: {"donor_id": donorId, "requester_id": requesterId},
    // );
  }

  // ------------------- الكارد -------------------
  Widget buildRequestCard(BuildContext context, Map<String, dynamic> req) {
    final itemName = req["user_items"]?["title"] ?? "Unknown Item";
    final donorName = req["donor"]?["full_name"] ?? "Unknown Donor";
    final donorId = req["donor"]?["id"] ?? "Unknown Donor";

    final requesterName = req["requester"]?["full_name"] ?? "Unknown Requester";
    final requesterId = req["requester"]?["id"] ?? "Unknown Requester";

    final reason = req["reason"];
    final imageUrl = req["attachment_url"];
    final status = req["status"];
    final timeAgo = formatTime(req["created_at"]);

    Color statusColor = status == "Approved"
        ? Colors.green
        : status == "Rejected"
        ? Colors.red
        : status == "Delivery"
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

          const SizedBox(height: 18),

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
                  "Donor: $donorName",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Row(
            children: [
              Icon(Icons.person, color: AppColors().primaryColor, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "Requester: $requesterName",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          Divider(thickness: 1, color: Colors.grey.shade500),
          const SizedBox(height: 10),

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
                "Request Details",
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

          const SizedBox(height: 20),

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
          buildButtons(context, status, req["id"], donorId, requesterId),
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
              openChat(context, donorId, requesterId);
            },
          ),
        ],
      );
    }

    // ---------------------- حالة APPROVED ----------------------
    if (status == "Approved") {
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
              openChat(context, donorId, requesterId);
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
        openChat(context, donorId, requesterId);
      },
    );
  }
}



// import 'package:admin_giver_receiver/logic/services/BottomNavigationBar/requests_screen_services/requests_screen_services.dart';
// import 'package:admin_giver_receiver/logic/services/colors_app.dart';
// import 'package:admin_giver_receiver/logic/services/variables_app.dart';
// import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/items_screen/items_card/button_widget.dart';
// import 'package:flutter/material.dart';






// class RequestsScreenWidgets {
// List<Map<String, dynamic>> allRequests = [];
//   List<Map<String, dynamic>> filteredRequests = [];

//   bool isLoading = true;
//   String selectedStatus = "All";
// final RequestsScreenServices _req = RequestsScreenServices();
//    // ------------------- تحميل الطلبات -------------------
//   Future<void> loadRequests() async {
//     allRequests = await _req.getAllRequestsForAdmin();
//     filteredRequests = List.from(allRequests);
//     setState(() => isLoading = false);
//   }

//   // ------------------- فلترة الطلبات -------------------
//   void filterRequests() {
//     if (selectedStatus == "All") {
//       filteredRequests = List.from(allRequests);
//     } else {
//       filteredRequests = allRequests.where((req) {
//         return req["status"] == selectedStatus;
//       }).toList();
//     }
//     setState(() {});
//   }

//    // ------------------- تحديث الحالة -------------------
//   Future<void> approveRequest(String id) async {
//     await _req.updateStatus(id, "Approved");
//     loadRequests();
//   }

//   Future<void> rejectRequest(String id) async {
//     await _req.updateStatus(id, "Rejected");
//     loadRequests();
//   }

//   Future<void> convertToDelivery(String id) async {
//     await _req.updateStatus(id, "Delivery");
//     loadRequests();
//   }

//   // ------------------- فتح الشات -------------------
//   void openChat(String donorId, String requesterId) {
//     // Navigator.pushNamed(
//     //   context,
//     //   "/chat",
//     //   arguments: {"donor_id": donorId, "requester_id": requesterId},
//     // );
//   }


//   Widget buildRequestCard(Map<String, dynamic> req) {
//   final itemName = req["user_items"]?["title"] ?? "Unknown Item";

//   final donorName = req["donors"]?["full_name"] ?? "Unknown Donor";
//   final donorId = req["donors"]?["id"] ?? "Unknown Donor";

//   final requesterName = req["requesters"]?["full_name"] ?? "Unknown Requester";
//   final requesterId = req["requesters"]?["id"] ?? "Unknown Requester";

//   final reason = req["reason"];
//   final imageUrl = req["attachment_url"];
//   final status = req["status"];
//   final timeAgo = formatTime(req["created_at"]);

//   Color statusColor = status == "Approved"
//       ? Colors.green
//       : status == "Rejected"
//       ? Colors.red
//       : status == "Converted"
//       ? Colors.blue
//       : Colors.orange;

//   return Container(
//     padding: const EdgeInsets.all(15),
//     margin: const EdgeInsets.only(bottom: 15),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(18),
//       boxShadow: [
//         BoxShadow(color: Colors.black12, blurRadius: 7, offset: Offset(0, 3)),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               itemName,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: statusColor.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: statusColor, width: 1.2),
//               ),
//               child: Text(
//                 status,
//                 style: TextStyle(
//                   color: statusColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),

//         SizedBox(height: 10),
//         Text(
//           "Donor: $donorName",
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//         ),
//         Text(
//           "Requester: $requesterName",
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//         ),

//         SizedBox(height: 15),
//         Text(
//           "Request Details:",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 4),
//         Text(reason, style: TextStyle(fontSize: 15, color: Colors.grey[800])),

//         SizedBox(height: 15),

//         ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: imageUrl != null
//               ? Image.network(
//                   imageUrl,
//                   height: 200,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 )
//               : Container(
//                   width: double.infinity,
//                   height: 200,
//                   color: Colors.grey[300],
//                   child: Icon(
//                     Icons.image_not_supported,
//                     size: 40,
//                     color: Colors.grey,
//                   ),
//                 ),
//         ),

//         SizedBox(height: 20),

//         // 🔥 زرار ButtonWidget
//         buildButtons(status, req["id"], donorId, requesterId),
//       ],
//     ),
//   );
// }
// ///////////////////////////////////////////////////////////////////////////////

// Widget buildButtons(
//   String status,
//   String id,
//   String donorId,
//   String requesterId,
// ) {
//   final primary = AppColors().primaryColor;

//   // ----------------------------------------------------------
//   // 🟠 1) حالة الـ Pending → Approve – Reject – Open Chat
//   // ----------------------------------------------------------
//   if (status == "pending") {
//     return Row(
//       children: [
//         Expanded(
//           child: ButtonWidget(
//             icon: Icons.check_circle,
//             title: "Approve",
//             ontap: () async {
//               await approveRequest(id);
//               // 🔄 تحديث الصفحة بعد تنفيذ الطلب
//             },
//           ),
//         ),
//         const SizedBox(width: 5),
//         Expanded(
//           child: ButtonWidget(
//             icon: Icons.cancel,
//             title: "Reject",
//             ontap: () async {
//               //  await rejectRequest(id);
//               // 🔄 تحديث الصفحة بعد تنفيذ الرفض
//             },
//           ),
//         ),
//         const SizedBox(width: 5),
//         Expanded(
//           child: ButtonWidget(
//             icon: Icons.chat_bubble_outline,
//             title: "Chat",
//             ontap: () async {
//               // 📌 فتح صفحة الشات
//               // 🔽 Navigation
//               // openChat(donorId, requesterId);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // ----------------------------------------------------------
//   // 🟢 2) حالة Approved → Convert – Chat
//   // ----------------------------------------------------------
//   if (status == "Approved") {
//     return Row(
//       children: [
//         Expanded(
//           child: ButtonWidget(
//             icon: Icons.delivery_dining,
//             title: "Convert",
//             ontap: () async {
//               //  await convertToDelivery(id);
//               // 🔄 تحديث الصفحة بعد التحويل
//             },
//           ),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: ButtonWidget(
//             icon: Icons.chat,
//             title: "Chat",
//             ontap: () async {
//               // 📌 فتح الشات
//               // 🔽 Navigation
//               //  openChat(donorId, requesterId);
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   // ----------------------------------------------------------
//   // 🔵 3) باقي الحالات → زر واحد للشات فقط
//   // ----------------------------------------------------------
//   return ButtonWidget(
//     icon: Icons.chat_bubble,
//     title: "Chat Session",
//     ontap: () async {
//       // 📌 فتح صفحة الشات
//       // 🔽 Navigation
//       //  openChat(donorId, requesterId);
//     },
//   );
// }


// }


// Widget buildRequestCard(Map<String, dynamic> req) {
//   final itemName = req["user_items"]?["title"] ?? "Unknown Item";
//   final donorName = req["users"]?["full_name"] ?? "Unknown Donor";
//   final donorId = req["requestes"]?["donor_id"] ?? "Unknown Donor";
//   final requesterName = req["requestes"]?["full_name"] ?? "Unknown Requester";
//     final requesterId = req["users"]?["id"] ?? "Unknown Requester";

//   final reason = req["reason"];
//   final imageUrl = req["attachment_url"];
//   final status = req["status"];
//   final timeAgo = formatTime(req["created_at"]);

//   Color statusColor = status == "Approved"
//       ? Colors.green
//       : status == "Rejected"
//       ? Colors.red
//       : status == "Converted"
//       ? Colors.blue
//       : Colors.orange;

//   return Container(
//     padding: const EdgeInsets.all(15),
//     margin: const EdgeInsets.only(bottom: 15),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(18),
//       boxShadow: [
//         BoxShadow(color: Colors.black12, blurRadius: 7, offset: Offset(0, 3)),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // -------------------------------- TITLE ROW --------------------------------
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               itemName,
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: statusColor.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: statusColor, width: 1.2),
//               ),
//               child: Text(
//                 status,
//                 style: TextStyle(
//                   color: statusColor,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),

//         SizedBox(height: 10),
//         Text(
//           "Donor: $donorName",
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//         ),
//         Text(
//           "Requester: $requesterName",
//           style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//         ),

//         SizedBox(height: 15),

//         Text(
//           "Request Details:",
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),

//         SizedBox(height: 4),
//         Text(reason, style: TextStyle(fontSize: 15, color: Colors.grey[800])),

//         SizedBox(height: 15),

//         ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Stack(
//             children: [
//               imageUrl != null
//                   ? Image.network(
//                       imageUrl,
//                       height: 200,
//                       width: double.infinity,
//                       fit: BoxFit.cover,
//                     )
//                   : Container(
//                       height: 200,
//                       color: Colors.grey[300],
//                       child: Icon(
//                         Icons.image_not_supported,
//                         size: 40,
//                         color: Colors.grey,
//                       ),
//                     ),
//               Container(height: 200, color: Colors.black.withOpacity(0.35)),
//             ],
//           ),
//         ),

//         SizedBox(height: 20),

//         // -------------------------------- BUTTONS --------------------------------
//         buildButtons(status, req["id"],donorId,requesterId),
//       ],
//     ),
//   );
// }

////////////////////////////////////////////////////////////////////////////////
