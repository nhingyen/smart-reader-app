import 'dart:math';

import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/models/author.dart';
import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/categories.dart';
import 'package:smart_reader/repositories/book_repository.dart';
import 'package:smart_reader/screens/home/bloc/home_event.dart';
import 'package:smart_reader/screens/home/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final BookRepository repository;
  HomeBloc({required this.repository}) : super(HomeInitial()) {
    on<LoadHomeDataEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        //giả lập dữ liệu (sau này thay bằng MongoDB / API call)
        await Future.delayed(Duration(seconds: 1));

        final continueReading = [
          Book(
            id: "1",
            title: "Trong gia đình",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000343865/product/trong-gia-dinh_bia_tb2019_0_3fc0a81ef5474430a9a8d2076547f31b_c3cd8396cec1487e8fe2cea594bdb685_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
          Book(
            id: "2",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),

          Book(
            id: "3",
            title: "Lão Hạc",
            author: "Nam Cao",
            imgUrl:
                "https://sach.baikiemtra.com/uploads/book/lao-hac/lao-hac-nam-cao.jpg",
            description: "Tác phẩm nổi bật của Nam Cao",
            rating: 4.0,
            chapters: [],
          ),
          Book(
            id: "4",
            title: "Không gia đình",
            author: "Hector Malot",
            imgUrl:
                "https://cdn1.fahasa.com/media/flashmagazine/images/page_images/khong_gia_dinh_tai_ban_2024/2024_11_05_16_37_52_1-390x510.jpg",
            description: "Tác phẩm nổi bật của Nam Cao",
            rating: 4.0,
            chapters: [],
          ),
        ];

        final authors = [
          Author(
            id: "1",
            name: "Hector Malot",
            bio: "Hector Malot là một nhà văn nổi tiếng người Pháp...",
            avatarUrl:
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStC3hdUdJ2xkTml0xQRc5bIdTzrU88IXPBsw&s",
          ),
          Author(
            id: "2",
            name: "Nam Cao",
            bio:
                "Nam Cao là một trong những nhà văn lớn của văn học Việt Nam...",
            avatarUrl:
                "https://upload.wikimedia.org/wikipedia/commons/b/b0/Portrait_of_Nam_Cao.jpg",
          ),
          Author(
            id: "3",
            name: "Tố Hữu",
            bio: "Tố Hữu là một nhà thơ lớn của Việt Nam...",
            avatarUrl:
                "https://upload.wikimedia.org/wikipedia/vi/1/18/To_Huu.jpg",
          ),
          Author(
            id: "4",
            name: "Jame Clear",
            bio: "James Clear is an American author and speaker...",
            avatarUrl:
                "https://bookbins.b-cdn.net/wp-content/uploads/2024/04/Bookbins-Authors-James-Clear-1.jpeg",
          ),
          Author(
            id: "5",
            name: "Ernest Hemingway",
            bio: "Ernest Hemingway was an American novelist...",
            avatarUrl:
                "https://revelogue.com/wp-content/uploads/2021/06/Enest-Hemingway-hinh-anh-1-1-e1624294493693.jpg",
          ),
        ];

        final newBooks = [
          Book(
            id: "1",
            title: "Trong gia đình",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000343865/product/trong-gia-dinh_bia_tb2019_0_3fc0a81ef5474430a9a8d2076547f31b_c3cd8396cec1487e8fe2cea594bdb685_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
        ];

        final specialBooks = [
          Book(
            id: "1",
            title: "Trong gia đình",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000343865/product/trong-gia-dinh_bia_tb2019_0_3fc0a81ef5474430a9a8d2076547f31b_c3cd8396cec1487e8fe2cea594bdb685_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
          Book(
            id: "1",
            title: "Ông già và biển cả",
            author: "Hector Malot",
            imgUrl:
                "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
            rating: 4.5,
            description: "Một tác phẩm kinh điển về tình cảm gia đình.",
            chapters: [], // có thể để rỗng
          ),
        ];

        final List<BookCategory> categories = [
          BookCategory(id: "1", name: "Văn học", endpoint: "literature"),
          BookCategory(id: "2", name: "Lãng mạn", endpoint: "romance"),
          BookCategory(id: "3", name: "Thiếu nhi", endpoint: "children"),
          BookCategory(id: "5", name: "Khoa học", endpoint: "science"),
          BookCategory(id: "5", name: "Truyện ngắn", endpoint: "short_stories"),
          BookCategory(id: "6", name: "Trinh thám", endpoint: "mystery"),
        ];

        emit(
          HomeLoaded(
            continueReading: continueReading,
            authors: authors,
            newBooks: newBooks,
            specialBooks: specialBooks,
            categories: categories,
          ),
        );
      } catch (e) {
        emit(HomeError("Lỗi load dữ liệu: $e"));
      }
    });
    on<CategorySelectedEvent>((event, emit) async {
      emit(HomeLoading());
      try {
        final books = await repository.fetchBooksByCategory(
          event.category.endpoint,
        );
        if (state is HomeLoaded) {
          final currentState = state as HomeLoaded;
          emit(
            HomeLoaded(
              continueReading: currentState.continueReading,
              authors: currentState.authors,
              newBooks: books, // cập nhật newBooks theo category
              specialBooks: currentState.specialBooks,
              categories: currentState.categories,
              selectedCategory: event.category,
            ),
          );
        }
      } catch (e) {
        emit(HomeError("Lỗi khi load sách theo thể loại: $e"));
      }
    });
  }
}
