import 'package:admin_giver_receiver/logic/services/BottomNavigationBar/items_screen_services/items_services.dart';
import 'package:admin_giver_receiver/logic/services/colors_app.dart';
import 'package:admin_giver_receiver/logic/services/variables_app.dart';
import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/items_screen/edit_items_screen/edit_items_screen.dart';
import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/items_screen/items_card/button_widget.dart';
import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/items_screen/items_card/button_widget_change_color.dart';
import 'package:admin_giver_receiver/presentation/widgets/BottomNavigationBar/items_screen/items_card/hide_button/HideItemManager.dart';
import 'package:admin_giver_receiver/presentation/widgets/save_items_screen/SaveItemManager.dart';
import 'package:flutter/material.dart';

class UserItemsCard extends StatefulWidget {
  // final String name;
  // final String specialty;
  final String itemId;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String timeAgo;
  final VoidCallback onRefresh;

  // final String avatarUrl;

  const UserItemsCard({
    super.key,
    // required this.name,
    // required this.specialty,
    required this.onRefresh,
    required this.itemId,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.imageUrls,
    // required this.avatarUrl,
  });

  @override
  State<UserItemsCard> createState() => _UserItemsCardState();
}

class _UserItemsCardState extends State<UserItemsCard> {
  int currentPage = 0;
  bool isSaved = false;
  bool isHide = false;

  void loadSaveStatus() async {
    isSaved = await SaveItemManager.isItemSaved(widget.itemId);
    setState(() {});
  }

  // void loadHideStatus() async {
  //   isHide = await HideItemManager.isItemHidden(widget.itemId);
  //   setState(() {});
  // }
  void loadHideStatus() async {
    isHide = await HideItemManager.isItemHidden(widget.itemId);
    setState(() {});
  }

  void onRefresh() async {
    await ItemsServices().loadItems(); // ← اجلب البيانات من جديد
    setState(() {});
  }

  ///////////////////////////////////////////
  void confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ---------------- Icon ----------------
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.delete_forever, color: Colors.red, size: 48),
              ),

              SizedBox(height: 18),

              // ---------------- Title ----------------
              Text(
                "حذف العنصر",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10),

              // ---------------- Content ----------------
              Text(
                "هل أنت متأكد أنك تريد حذف هذا العنصر؟ لا يمكن التراجع عن هذا الإجراء.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),

              SizedBox(height: 25),

              // ---------------- Buttons ----------------
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.grey[200],
                      ),
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        "إلغاء",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await ItemsServices().deleteItem(widget.itemId);
                        Navigator.pop(context); // خروج من الـ Dialog
                        widget.onRefresh(); // ← تحديث الصفحة الأساسية
                      },

                      child: Text(
                        "حذف",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pageControllerImagesItems = PageController();
    loadSaveStatus();
    loadHideStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15, left: 15, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 10),
          //   child: Divider(color: Colors.grey[300], thickness: 1.5),
          // ),
          Container(
            height: 40,
            //padding: const EdgeInsets.symmetric(horizontal: 10),
            alignment: Alignment.bottomCenter,

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ---------------------- العنوان ----------------------
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                // ---------------------- الوقت (trailing) ----------------------
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors().primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    widget.timeAgo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          /////////////////////////////////////////////////////////////
          Text(
            widget.description,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
          ),
          SizedBox(height: 10),
          /////////////////////////////////////////////////////////////
          if (widget.imageUrls.isNotEmpty)
            SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // ----------------- صور العنصر (PageView) -----------------
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: PageView.builder(
                      controller: pageControllerImages,
                      itemCount: widget.imageUrls.length,
                      onPageChanged: (index) {
                        setState(() => currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        return Image.network(
                          widget.imageUrls[index],
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),

                  // ----------------- طبقة التعتيم -----------------
                  IgnorePointer(
                    ignoring: true,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.black.withOpacity(0.35),
                      ),
                    ),
                  ),

                  // ----------------- زر الحذف -----------------
                  Positioned(
                    top: 10,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        // استدعِ دالة الحذف الخاصة فيك
                        // confirmDelete(widget.itemId);
                        confirmDelete();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 243, 227, 227),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 185, 17, 5),
                            width: 1.7,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 22,
                        ),
                      ),
                    ),
                  ),

                  // ----------------- مؤشر الصور (Dots) -----------------
                  if (widget.imageUrls.length > 1)
                    Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.imageUrls.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentPage == index ? 12 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: currentPage == index
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image, size: 40, color: Colors.grey),
            ),

          /////////////////////////////////////////////////////////////
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ------------------------- edit -------------------------
              Expanded(
                child: ButtonWidget(
                  icon: Icons.edit,
                  title: "تعديل",
                  ontap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditItemsScreen(
                          itemId: widget.itemId,
                          onItemUpdated: () {
                            widget.onRefresh();
                          },
                        ),
                      ),
                    );
                    if (result == true) {
                      onRefresh(); // ← تحديث القائمة مباشرة بعد الرجوع
                    }
                  },
                ),
              ),
              SizedBox(width: 10),
              // ------------------------- save -------------------------
              Expanded(
                child: ButtonWidgetChangeColor(
                  onTap: () async {
                    await SaveItemManager.toggleSaveItem(widget.itemId);
                    loadSaveStatus(); // تحديث اللون فوراً
                    print("Item Saved Status Changed");
                  },
                  icon: Icons.save_outlined,
                  title: 'حفظ',
                  flipColorOnTap: false, // ← لا تغيّر اللون تلقائياً
                  isActive: isSaved, // ← اللون يأتي من حالة الحفظ
                ),
              ),
              SizedBox(width: 10),
              // ------------------------- Hide -------------------------
              Expanded(
                child: ButtonWidgetChangeColor(
                  onTap: () async {
                    await HideItemManager.toggleHideItem(widget.itemId);
                    loadHideStatus(); // ← تحديث اللون فوراً
                  },
                  icon: Icons.visibility_off,
                  title: 'إخفاء',
                  flipColorOnTap: false, // ← لا تغيّر اللون تلقائياً
                  isActive: isHide, // ← اللون يأتي من حالة الحفظ
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
