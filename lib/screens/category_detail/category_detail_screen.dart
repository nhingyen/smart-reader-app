import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/categories.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/category_detail/bloc/category_detail_bloc.dart';
import 'package:smart_reader/screens/category_detail/bloc/category_detail_event.dart';
import 'package:smart_reader/screens/category_detail/bloc/category_detail_state.dart';
import 'package:smart_reader/theme/app_colors.dart';
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
          leadingWidth: 25,
          title: Text(category.name, style: TextStyle(fontSize: 20)),
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: TopCard(
                      imgUrl: book.imgUrl,
                      title: book.title,
                      author: book.author,
                      rating: book.rating,
                      // Thêm onTap để chuyển đến màn hình chi tiết sách
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
