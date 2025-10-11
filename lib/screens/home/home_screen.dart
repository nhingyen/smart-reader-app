import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/models/categories.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/category/category_screen.dart';
import 'package:smart_reader/screens/category_detail/category_detail_screen.dart';
import 'package:smart_reader/screens/home/bloc/home_bloc.dart';
import 'package:smart_reader/screens/home/bloc/home_event.dart';
import 'package:smart_reader/screens/home/bloc/home_state.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/widgets/author_avatar.dart';
import 'package:smart_reader/widgets/book_card.dart';
import 'package:smart_reader/widgets/footer/footer.dart';
import 'package:smart_reader/widgets/special_card.dart';
import 'package:smart_reader/widgets/top_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeBloc(repository: BookRepository())..add(LoadHomeDataEvent()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is HomeLoaded) {
              return Scaffold(
                appBar: AppBar(
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
                      icon: const Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 22,
                      ),
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

                body: Column(
                  children: [
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                "Thể loại sách",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryScreen(), // Thêm tạm trang Home trước đã
                                    ),
                                  );
                                },
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
                          // SizedBox(height: 5),
                          // Categories Row
                          SizedBox(
                            height: 40,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: state.categories.map((c) {
                                final selected =
                                    state.selectedCategory?.name == c.name;
                                return GestureDetector(
                                  onTap: () {
                                    print("👉 Category tapped: ${c.name}");
                                    context.read<HomeBloc>().add(
                                      CategorySelectedEvent(c),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryDetailScreen(
                                              category: c,
                                            ), // Thêm tạm trang Home trước đã
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      c.name,
                                      style: TextStyle(
                                        color: AppColors.textLight,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
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
                            height: 175,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: state.continueReading.map((b) {
                                return BookCard(b.title, b.imgUrl, () {});
                              }).toList(),
                            ),
                          ),

                          SizedBox(height: 5),
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
                            height: 80,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: state.authors.map((a) {
                                return AuthorAvatar(
                                  name: a.authorName,
                                  avatarUrl: a.avatarUrl,
                                  onTap: () {},
                                );
                              }).toList(),
                            ),
                          ),

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
                          Column(
                            children: state.newBooks.map((c) {
                              return TopCard(
                                imgUrl: c.imgUrl,
                                title: c.title,
                                author: c.authorName,
                                rating: c.rating,
                              );
                            }).toList(),
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
                          SizedBox(
                            height: 230,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: state.specialBooks.map((d) {
                                return SpecialCard(
                                  imgUrl: d.imgUrl,
                                  title: d.title,
                                  author: d.authorName,
                                  rating: d.rating,
                                  onTap: () {},
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is HomeError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text("Chưa có dữ liệu"));
          },
        ),
        bottomNavigationBar: CustomFooter(
          selectedIndex: 0,
          onItemSelected: (index) {},
        ),
      ),
    );
  }
}
