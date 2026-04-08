import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/user_repository.dart';
import 'package:smart_reader/screens/book_detail/book_detail_screen.dart';
import 'package:smart_reader/screens/home/home_screen.dart';
import 'package:smart_reader/screens/library/bloc/library_bloc.dart';
import 'package:smart_reader/screens/library/bloc/library_event.dart';
import 'package:smart_reader/screens/library/bloc/library_state.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/widgets/book_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Cung cấp Bloc cho màn hình này
    return BlocProvider(
      create: (context) =>
          LibraryBloc(userRepository: context.read<UserRepository>())
            ..add(LoadLibraryEvent(FirebaseAuth.instance.currentUser!.uid)),

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
          title: const Text(
            "Thư viện sách của bạn",
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<LibraryBloc, LibraryState>(
          builder: (context, state) {
            if (state is LibraryLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LibraryError) {
              return Center(child: Text(state.message));
            }

            if (state is LibraryLoaded) {
              if (state.books.isEmpty) {
                return _buildEmptyView();
              }
              return _buildGridView(context, state.books);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Thư viện trống",
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(BuildContext context, List<dynamic> books) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 16,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookCard(book.bookId, book.title, book.imgUrl, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookDetailScreen(bookId: book.bookId),
            ),
          ).then((_) {
            // Khi quay lại, reload lại thư viện (đề phòng xóa sách)
            if (context.mounted) {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              if (uid != null) {
                context.read<LibraryBloc>().add(LoadLibraryEvent(uid));
              }
            }
          });
        });
      },
    );
  }
}
