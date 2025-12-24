import 'package:admin_giver_receiver/logic/services/colors_app.dart';
import 'package:admin_giver_receiver/logic/services/sized_config.dart';
import 'package:admin_giver_receiver/presentation/widgets/CustomHeader/custom_header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const CustomHeader(icon: Icons.info, title: 'حول التطبيق'),
            const SizedBox(height: 5),

            /// --- Logo ---
            Center(
              child: Image.asset(
                "assets/images/logo_app1.png",
                fit: BoxFit.contain,
                height: SizeConfig.width * 0.5,
                width: SizeConfig.width * 0.8,
              ),
            ),

            /// --- Content ---
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.width * 0.05,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// --- Title ---
                      Text(
                        "حول الواهب والموهوب",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors().primaryColor,
                        ),
                        textAlign: TextAlign.start,
                      ),

                      const SizedBox(height: 10),

                      /// --- App Description ---
                      Text(
                        """
"المتبرع والمتلقي" عبارة عن منصة تبرع آمنة ومجهولة المصدر تعمل على ربط الأفراد الذين يرغبون في التبرع بالعناصر غير المستخدمة مع الأشخاص الذين يحتاجون إليها - كل ذلك من خلال وسيط إداري موثوق.
      
 مهمتنا هي أن نجعل العطاء بسيطًا، ذا معنى، وآمنًا. ومن خلال الحفاظ على الخصوصية لكل من المانحين والمتلقين، فإننا نضمن أن تصبح المشاركة تجربة مريحة وإيجابية للجميع.
                
 من خلال التطبيق يمكنك:
• مشاركة العناصر التي لم تعد بحاجة إليها
• تصفح التبرعات المتاحة
• طلب العناصر من خلال المشرف
• التواصل بأمان ومجهول 
      """,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// --- Contact Section ---
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.phone,
                                      size: 35,
                                      color: Colors.green,
                                    ),
                                    SizedBox(height: 5),
                                    Text('Call'),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 22,
                                    right: 15,
                                  ),
                                  child: VerticalDivider(
                                    color: Colors.grey,
                                    width: 20,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesomeIcons.facebook,
                                  size: 40,
                                  color: Colors.blue,
                                ),
                                SizedBox(height: 5),
                                Text('Facebook'),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: VerticalDivider(
                                color: Colors.grey,
                                width: 20,
                                thickness: 1,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesomeIcons.whatsapp,
                                  size: 40,
                                  color: Colors.green,
                                ),
                                SizedBox(height: 5),
                                Text('WhatsApp'),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
