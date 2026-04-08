import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/book_detail/book_detail_screen.dart';
import 'package:smart_reader/screens/category/bloc/category_bloc.dart';
import 'package:smart_reader/screens/category/bloc/category_event.dart';
import 'package:smart_reader/screens/category/bloc/category_state.dart';
import 'package:smart_reader/screens/category_detail/category_detail_screen.dart';
import 'package:smart_reader/screens/home/home_screen.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/widgets/book_card.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          CategoryBloc(repository: BookRepository())
            ..add(LoadCategoriesEvent()),
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 20,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 12),
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          title: const Text("Thể loại sách", style: TextStyle(fontSize: 20)),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.error != null) {
              return Center(child: Text("Lỗi: ${state.error}"));
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 3, 14, 16),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final item = state.categories[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.category.categoryName,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CategoryDetailScreen(
                                    category: item.category,
                                  ),
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
                    ),
                    // const SizedBox(height: 8),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: item.books.length,
                        padding: EdgeInsets.zero,
                        itemBuilder: (context, i) {
                          final book = item.books[i];
                          return Padding(
                            padding: const EdgeInsets.only(right: 1),
                            child: BookCard(
                              book.bookId,
                              book.title,
                              book.imgUrl,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookDetailScreen(bookId: book.bookId),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    // const SizedBox(height: 2),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
