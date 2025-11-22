import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/models/author.dart';
import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/author_detail/bloc/author_detail_bloc.dart';
import 'package:smart_reader/screens/author_detail/bloc/author_detail_state.dart';
import 'package:smart_reader/screens/author_detail/bloc/author_detail_event.dart';
import 'package:smart_reader/screens/book_detail/book_detail_screen.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'package:smart_reader/widgets/top_card.dart';

class AuthorDetailScreen extends StatelessWidget {
  final String authorId;
  const AuthorDetailScreen({Key? key, required this.authorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AuthorDetailBloc(repository: BookRepository())
            ..add(LoadAuthorDetailEvent(authorId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<AuthorDetailBloc, AuthorDetailState>(
          builder: (context, state) {
            if (state is AuthorDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is AuthorDetailLoaded) {
              return _buildContent(context, state.author, state.books);
            } else if (state is AuthorDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Author author, List<Book> books) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(
              author.avatarUrl.isNotEmpty
                  ? author.avatarUrl
                  : "https://via.placeholder.com/150",
            ),
          ),
          SizedBox(height: 10),

          Text(
            author.authorName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 0, 0, 0.867),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            author.authorBio.isNotEmpty
                ? author.authorBio
                : "Chưa có thông tin tiểu sử cho tác giả này.",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          // const SizedBox(height: 10),
          Divider(color: Colors.grey, thickness: 1),
          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sách của tác giả ${author.authorName}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(0, 0, 0, 0.867),
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (books.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Chưa có sách nào của tác giả này."),
            )
          else
            ListView.builder(
              // padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
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
                    child: TopCard(
                      bookId: book.bookId,
                      imgUrl: book.imgUrl,
                      title: book.title,
                      author: author.authorName,
                      rating: book.rating,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
