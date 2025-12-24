import 'package:admin_giver_receiver/logic/services/BottomNavigationBar/dashboard_screen_services/dashboard_services.dart';
import 'package:admin_giver_receiver/logic/services/colors_app.dart';
import 'package:admin_giver_receiver/presentation/screens/BottomNavigationBar/admin_requests_screen.dart';
import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/dashboard_screen/dashboard_card.dart';
import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/dashboard_screen/lineChartData.dart';
import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/dashboard_screen/model_item.dart';
import 'package:admin_giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DashboardOverviewScreen extends StatefulWidget {
  const DashboardOverviewScreen({super.key});

  @override
  State<DashboardOverviewScreen> createState() =>
      _DashboardOverviewScreenState();
}

class _DashboardOverviewScreenState extends State<DashboardOverviewScreen> {
  int totalDonors = 0;
  int totalSeekers = 0;
  int totalDonations = 0;
  int requests = 0;

  int lateCases = 0;
  String request = '';
  String donor = '';
  String seekers = '';
  String donations = '';

  final service = DashboardService();

  @override
  void initState() {
    super.initState();
    loadDashboardData();
    donorsUpdate();
    seekersUpdate();
    donationsUpdate();
    requestUpdate();
  }

  Future<void> loadDashboardData() async {
    totalDonors = await service.getTotalDonors();
    totalSeekers = await service.getTotalServiceSeekers();
    totalDonations = await service.getTotalDonations();

    requests = await service.getRequests();

    lateCases = await service.getLateRequests();

    setState(() {});
  }

  Future<void> donorsUpdate() async {
    final result = await service.getLastDonorsUpdate();

    setState(() {
      donor = result;
    });
  }

  /////////////////////////////////////////////////////////////
  Future<void> seekersUpdate() async {
    final result = await service.getLastSeekersUpdate();

    setState(() {
      seekers = result;
    });
  }

  ///////////////////////////////////////////////////////////////
  Future<void> donationsUpdate() async {
    final result = await service.getLastDonationsUpdate();

    setState(() {
      donations = result;
    });
  }

  ///////////////////////////////////////////////////////////////
  Future<void> requestUpdate() async {
    final result = await service.getLastRequestUpdate();

    setState(() {
      request = result;
    });
  }
  //////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final items = [
      DashboardItem(
        onTap: () {},
        icon: Icons.handshake,
        title: 'إجمالي المتبرعين',
        value: totalDonors.toString(),
        percent: '+15%',
        update: donor,
      ),
      DashboardItem(
        onTap: () {},
        icon: Icons.groups,
        title: 'إجمالي طالبي الخدمة',
        value: totalSeekers.toString(),
        percent: '+15%',
        update: seekers,
      ),
      DashboardItem(
        onTap: () {},
        icon: Icons.volunteer_activism,
        title: 'إجمالي التبرعات',
        value: totalDonations.toString(),
        percent: '+15%',
        update: donations,
      ),
      DashboardItem(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminRequestsScreen()),
          );
        },
        icon: Icons.assignment,
        title: 'عدد الطلبات',
        value: requests.toString(),
        percent: '+15%',
        update: request,
      ),
      DashboardItem(
        onTap: () {},
        icon: Icons.pending_actions,
        title: 'عدد الحالات المتأخرة',
        value: lateCases.toString(),
        percent: '+15%',
        update: request,
      ),
    ];

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomHeader(icon: Icons.home, title: "لوحة القيادة"),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 25),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,

                          colors: [AppColors().primaryColor, Color(0xFF30ae96)],
                          stops: [0.93, 0.2],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors().primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors().primaryColor.withOpacity(0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 20),
                          ),
                        ],
                      ),
                      height: 250,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مبلغ الربح',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '\$ 15.237.000',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 35,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 7),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 1.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Text(
                                        '+15%',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'من الاسبوع السابق',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 105,
                            child: LineChart(lineChartData()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.2,
                          ),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: item.onTap,
                          child: DashboardCard(item: item),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
