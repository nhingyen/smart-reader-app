import 'dart:math';

import 'package:flutter/material.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/widgets/author_avatar.dart';
import 'package:smart_reader/widgets/book_card.dart';
import 'package:smart_reader/widgets/footer/footer.dart';
import 'package:smart_reader/widgets/special_card.dart';
import 'package:smart_reader/widgets/top_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AppBar(
            leading: IconButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomeScreen()),
                // );
              },
              icon: const Icon(Icons.book),
              color: AppColors.primary,
              iconSize: 24,
            ),
            leadingWidth: 40,
            titleSpacing: 0,
            title: const Text("SmartBook"),
            actions: [
              IconButton(
                icon: const Icon(Icons.search, color: Colors.black, size: 22),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.black,
                  size: 22,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Divider(height: 1, thickness: 1, color: Colors.grey[300]),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Today's Pick",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textLight,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Atomic Habits",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textLight,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "by James Clear",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textLight,
                              ),
                            ),
                            SizedBox(height: 4),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.background,
                                // foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Đọc ngay",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height: 140,
                        child: Image.network(
                          "https://static.oreka.vn/800-800_2a51b6cf-f9d0-4afa-a6c0-8fa6a89986cf.webp",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tiếp tục đọc",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Xem tất cả",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 175, // chiều cao cho list ngang
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      BookCard(
                        "Trong gia đình",
                        "https://product.hstatic.net/200000343865/product/trong-gia-dinh_bia_tb2019_0_3fc0a81ef5474430a9a8d2076547f31b_c3cd8396cec1487e8fe2cea594bdb685_master.jpg",
                      ),
                      BookCard(
                        "Ông già và biển cả",
                        "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
                      ),
                      BookCard(
                        "Lão Hạc",
                        "https://sach.baikiemtra.com/uploads/book/lao-hac/lao-hac-nam-cao.jpg",
                      ),
                      BookCard(
                        "Không gia đình",
                        "https://cdn1.fahasa.com/media/flashmagazine/images/page_images/khong_gia_dinh_tai_ban_2024/2024_11_05_16_37_52_1-390x510.jpg",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tác giả nổi bật",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Xem tất cả",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80, // chiều cao cho list ngang
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      AuthorAvatar(
                        name: "Hector Malot",
                        avatarUrl:
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStC3hdUdJ2xkTml0xQRc5bIdTzrU88IXPBsw&s",
                      ),
                      AuthorAvatar(
                        name: "Jame Clear",
                        avatarUrl:
                            "https://bookbins.b-cdn.net/wp-content/uploads/2024/04/Bookbins-Authors-James-Clear-1.jpeg",
                      ),
                      AuthorAvatar(
                        name: "Ernest Hemingway",
                        avatarUrl:
                            "https://revelogue.com/wp-content/uploads/2021/06/Enest-Hemingway-hinh-anh-1-1-e1624294493693.jpg",
                      ),
                      AuthorAvatar(
                        name: "Nam Cao",
                        avatarUrl:
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b0/Portrait_of_Nam_Cao.jpg/250px-Portrait_of_Nam_Cao.jpg",
                      ),
                      AuthorAvatar(
                        name: "Tố Hữu",
                        avatarUrl:
                            "https://upload.wikimedia.org/wikipedia/vi/1/18/To_Huu.jpg",
                      ),
                    ],
                  ),
                ),

                // Tiêu đề + nút
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sách mới",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Xem tất cả",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                // Danh sách 2 card
                const SizedBox(height: 8),
                Column(
                  children: [
                    TopCard(
                      "https://cdn1.fahasa.com/media/flashmagazine/images/page_images/khong_gia_dinh_tai_ban_2024/2024_11_05_16_37_52_1-390x510.jpg",
                      "Không gia đình",
                      "Hector Malot",
                      5.0,
                    ),
                    TopCard(
                      "https://cdn1.fahasa.com/media/flashmagazine/images/page_images/khong_gia_dinh_tai_ban_2024/2024_11_05_16_37_52_1-390x510.jpg",
                      "Không gia đình",
                      "Hector Malot",
                      4.6,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Sách đặc biệt dành cho bạn",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Xem tất cả",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 225, // chiều cao cho list ngang
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SpecialCard(
                        "https://cdn1.fahasa.com/media/flashmagazine/images/page_images/khong_gia_dinh_tai_ban_2024/2024_11_05_16_37_52_1-390x510.jpg",
                        "Không gia đình",
                        "Hector Malot",
                        5.0,
                      ),
                      SpecialCard(
                        "https://cdn1.fahasa.com/media/flashmagazine/images/page_images/khong_gia_dinh_tai_ban_2024/2024_11_05_16_37_52_1-390x510.jpg",
                        "Không gia đình",
                        "Hector Malot",
                        4.6,
                      ),
                      SpecialCard(
                        "https://sach.baikiemtra.com/uploads/book/lao-hac/lao-hac-nam-cao.jpg",
                        "Không gia đình",
                        "Hector Malot",
                        4.6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomFooter(
        selectedIndex: 0,
        onItemSelected: (index) {},
      ),
    );
  }
}
