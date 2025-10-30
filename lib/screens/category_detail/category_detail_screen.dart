import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/categories.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/book_detail/book_detail_screen.dart';
import 'package:smart_reader/screens/category_detail/bloc/category_detail_bloc.dart';
import 'package:smart_reader/screens/category_detail/bloc/category_detail_event.dart';
import 'package:smart_reader/screens/category_detail/bloc/category_detail_state.dart';
import 'package:smart_reader/screens/home/home_screen.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/widgets/list_card.dart';
import 'package:smart_reader/widgets/top_card.dart';

class CategoryDetailScreen extends StatelessWidget {
  final BookCategory category;

  CategoryDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryDetailBloc(repository: BookRepository())
            ..add(LoadCategoryBooksEvent(category)),
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
          title: Text(
            "Sách ${category.categoryName}",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<CategoryDetailBloc, CategoryDetailState>(
          builder: (context, state) {
            if (state is CategoryDetailLoading ||
                state is CategoryDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryDetailLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.books.length,
                itemBuilder: (context, index) {
                  final book = state.books[index];
                  // Sử dụng lại TopCard hoặc một widget phù hợp cho danh sách dọc
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookDetailScreen(bookId: book.bookId),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: ListCard(
                        imgUrl: book.imgUrl,
                        title: book.title,
                        author: book.author.authorName,
                        description: book.description,
                        // Thêm onTap để chuyển đến màn hình chi tiết sách
                      ),
                    ),
                  );
                },
              );
            } else if (state is CategoryDetailError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text("Không tìm thấy sách."));
          },
        ),
      ),
    );
  }
}
