import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/book_detail/book_detail_screen.dart';
import 'package:smart_reader/screens/home/home_screen.dart';
import 'package:smart_reader/screens/search/bloc/search_bloc.dart';
import 'package:smart_reader/screens/search/bloc/search_event.dart';
import 'package:smart_reader/screens/search/bloc/search_state.dart';
import 'package:smart_reader/theme/app_colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SearchBloc(bookRepository: context.read<BookRepository>()),
      child: Scaffold(
        backgroundColor: Colors.white,
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
          title: const Text("Tìm kiếm sách", style: TextStyle(fontSize: 20)),

          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: Colors.grey[200],
              child: _SearchInput(),
            ),
            SizedBox(height: 10),
            Expanded(child: _SearchResults()),
          ],
        ),
      ),
    );
  }
}

// Widget Ô Nhập Liệu
class _SearchInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true, // Tự động bật bàn phím khi vào màn hình
      decoration: InputDecoration(
        hintText: "Nhập tên sách...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.grey[400]),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 18),
      onChanged: (value) {
        // Gửi sự kiện khi gõ
        context.read<SearchBloc>().add(SearchQueryChanged(value));
      },
    );
  }
}

// Widget Kết Quả
class _SearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is SearchError) {
          return Center(child: Text(state.message));
        }

        if (state is SearchLoaded) {
          if (state.books.isEmpty) {
            return const Center(child: Text("Không tìm thấy sách nào"));
          }

          return ListView.builder(
            itemCount: state.books.length,
            itemBuilder: (context, index) {
              final book = state.books[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    book.imgUrl,
                    width: 40,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Container(width: 40, color: Colors.grey),
                  ),
                ),
                title: Text(
                  book.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(book.author.authorName),
                onTap: () {
                  // Vào chi tiết sách
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailScreen(bookId: book.bookId),
                    ),
                  );
                },
              );
            },
          );
        }

        // SearchInitial
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                "Nhập từ khóa để tìm kiếm",
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
