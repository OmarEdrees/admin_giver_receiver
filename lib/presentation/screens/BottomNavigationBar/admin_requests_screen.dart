import 'package:admin_giver_receiver/logic/services/colors_app.dart';
import 'package:admin_giver_receiver/logic/services/variables_app.dart';
import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/requests_screen/requests_screen_widgets.dart';
import 'package:admin_giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';
import 'package:flutter/material.dart';

class AdminRequestsScreen extends StatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  State<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends State<AdminRequestsScreen> {
  late RequestsScreenWidgets controller;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRequests();
  }

  Future<void> loadRequests() async {
    controller = RequestsScreenWidgets(
      refreshUi: () => setState(() {}), // ← الآن مسموح
    );
    await controller.loadRequests();
    setState(() => isLoading = false);
  }

  int _getInitialTabIndex(String status) {
    switch (status) {
      case "pending":
        return 1;
      case "Approved":
        return 2;
      case "Rejected":
        return 3;
      case "Delivery":
        return 4;
      default:
        return 0;
    }
  }

  String _getStatusFromTab(int index) {
    switch (index) {
      case 1:
        return "pending";
      case 2:
        return "Approved";
      case 3:
        return "Rejected";
      case 4:
        return "Delivery";
      default:
        return "All";
    }
  }

  Widget _buildCustomTab(String title, int index, TabController controller) {
    final bool isSelected = controller.index == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),

      decoration: BoxDecoration(
        color: isSelected ? AppColors().primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black45,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors().primaryColor;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white, Color(0xFF17A589)],
            stops: [0.0, 0.7, 1.5],
          ),
        ),
        child: Column(
          children: [
            const CustomHeader(
              icon: Icons.admin_panel_settings,
              title: "Requests Management",
            ),
            const SizedBox(height: 15),

            // ------------------ البحث + الفلترة ------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔍 Search Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                    child: TextFormField(
                      controller: requestScreenSearch,
                      cursorColor: primary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintText: 'Search for Request',
                        prefixIcon: Icon(Icons.search, color: primary),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onChanged: (value) {
                        controller.applyFilters(value);
                        setState(() {});
                      },
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ----------------- ⭐ TabBar Filter -----------------
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                    ),
                    child: DefaultTabController(
                      length: 5,
                      initialIndex: _getInitialTabIndex(
                        controller.selectedStatus,
                      ),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Builder(
                          builder: (context) {
                            final TabController tabController =
                                DefaultTabController.of(context);

                            tabController.addListener(() {
                              if (!tabController.indexIsChanging) {
                                controller.selectedStatus = _getStatusFromTab(
                                  tabController.index,
                                );

                                controller.applyFilters(
                                  requestScreenSearch.text,
                                );
                                setState(() {});
                              }
                            });

                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: constraints.maxWidth,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 6,
                                        right: 6,
                                      ),
                                      child: TabBar(
                                        controller: tabController,
                                        isScrollable: true,
                                        tabAlignment: TabAlignment.start,

                                        // No padding issues
                                        padding: EdgeInsets.zero,
                                        labelPadding: EdgeInsets.zero,

                                        // Remove underline & default indicator
                                        indicator: const BoxDecoration(),
                                        indicatorColor: Colors.transparent,
                                        dividerColor: Colors.transparent,
                                        overlayColor: MaterialStateProperty.all(
                                          Colors.transparent,
                                        ),

                                        tabs: [
                                          _buildCustomTab(
                                            "All",
                                            0,
                                            tabController,
                                          ),
                                          _buildCustomTab(
                                            "Pending",
                                            1,
                                            tabController,
                                          ),
                                          _buildCustomTab(
                                            "Approved",
                                            2,
                                            tabController,
                                          ),
                                          _buildCustomTab(
                                            "Rejected",
                                            3,
                                            tabController,
                                          ),
                                          _buildCustomTab(
                                            "Delivery",
                                            4,
                                            tabController,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ------------------ الطلبات ------------------
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller.filteredRequests.isEmpty
                  ? const Center(child: Text("No Requests Found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(15),
                      itemCount: controller.filteredRequests.length,
                      itemBuilder: (context, index) {
                        final req = controller.filteredRequests[index];

                        return controller.buildRequestCard(context, req);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
