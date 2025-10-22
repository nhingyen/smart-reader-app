import 'package:smart_reader/models/author.dart';
import 'package:smart_reader/models/book.dart';
import 'package:smart_reader/models/chapter.dart';
// import các model khác nếu cần

// Dữ liệu Chapters chi tiết mẫu (dùng chung cho các cuốn sách)
final List<Chapter> sampleChapters = [
  Chapter(
    id: "c1",
    title: "Chương 1: Những Nguyên Tắc Cơ Bản",
    content: "Nội dung chương 1...",
  ),
  Chapter(
    id: "c2",
    title: "Chương 2: Bốn Quy Tắc Thay Đổi Hành Vi",
    content: "Nội dung chương 2...",
  ),
  Chapter(
    id: "c3",
    title: "Chương 3: Làm cho nó Hiển Nhiên",
    content: "Nội dung chương 3...",
  ),
  Chapter(
    id: "c4",
    title: "Chương 4: Làm cho nó Hấp Dẫn",
    content: "Nội dung chương 4...",
  ),
];

final List<Author> mockAuthors = [
  Author(
    authorId: "h1",
    authorName: "Hector Malot",
    authorBio: "Hector Malot là một nhà văn nổi tiếng người Pháp...",
    avatarUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcStC3hdUdJ2xkTml0xQRc5bIdTzrU88IXPBsw&s",
  ),
  Author(
    authorId: "n2",
    authorName: "Nam Cao",
    authorBio: "Nam Cao là một trong những nhà văn lớn của văn học Việt Nam...",
    avatarUrl:
        "https://upload.wikimedia.org/wikipedia/commons/b/b0/Portrait_of_Nam_Cao.jpg",
  ),
  Author(
    authorId: "t3",
    authorName: "Tố Hữu",
    authorBio: "Tố Hữu là một nhà thơ lớn của Việt Nam...",
    avatarUrl: "https://upload.wikimedia.org/wikipedia/vi/1/18/To_Huu.jpg",
  ),
  Author(
    authorId: "j4",
    authorName: "James Clear",
    authorBio: "James Clear is an American author and speaker...",
    avatarUrl:
        "https://bookbins.b-cdn.net/wp-content/uploads/2024/04/Bookbins-Authors-James-Clear-1.jpeg",
  ),
  Author(
    authorId: "e5",
    authorName: "Ernest Hemingway",
    authorBio: "Ernest Hemingway was an American novelist...",
    avatarUrl:
        "https://revelogue.com/wp-content/uploads/2021/06/Enest-Hemingway-hinh-anh-1-1-e1624294493693.jpg",
  ),
];

// Dữ liệu giả lập tất cả sách
final List<Book> mockBooks = [
  // --- Sách 1: ATOMIC HABITS (Today's Pick) ---
  Book(
    bookId: "100",
    title: "Atomic Habits",
    authorId: "a1",
    authorName: "James Clear",
    imgUrl:
        "https://static.oreka.vn/800-800_2a51b6cf-f9d0-4afa-a6c0-8fa6a89986cf.webp",
    rating: 4.8,
    description:
        "Tác phẩm bán chạy toàn cầu về cách xây dựng thói quen tốt và phá bỏ thói quen xấu. Atomic Habits là khung sườn thực tế để bạn cải thiện mỗi ngày, đạt được những kết quả phi thường.",
    chapters: sampleChapters,
    ratingCount: 5200,
    chapterCount: 320,
    genres: ["science", "self_help", "short_stories"], // Gán nhiều thể loại
    isAddedToLibrary: true,
  ),

  Book(
    bookId: "1",
    title: "Trong Gia Đình",
    authorId: "a2",
    authorName: "Hector Malot",
    imgUrl:
        "https://product.hstatic.net/200000343865/product/trong-gia-dinh_bia_tb2019_0_3fc0a81ef5474430a9a8d2076547f31b_c3cd8396cec1487e8fe2cea594bdb685_master.jpg",
    rating: 4.5,
    description:
        "Câu chuyện cảm động về tình thân và sự hy sinh. Một tác phẩm kinh điển cho mọi thế hệ.",
    chapters: [],
    ratingCount: 850,
    chapterCount: 650,
    genres: ["literature"],
    isAddedToLibrary: false,
  ),

  Book(
    bookId: "2",
    title: "Ông Già và Biển Cả",
    authorId: "a3",
    authorName: "Ernest Hemingway",
    imgUrl:
        "https://product.hstatic.net/200000017360/product/ong-gia-va-bien-ca_tai-ban_375cab96d9054c439075213931b21e3b_master.jpg",
    rating: 4.6,
    description:
        "Tác phẩm vĩ đại về sự kiên cường của con người trước thiên nhiên. Một kiệt tác văn học hiện đại.",
    chapters: sampleChapters,
    ratingCount: 1200,
    chapterCount: 120,
    genres: ["literature", "short_stories"],
    isAddedToLibrary: true,
  ),

  Book(
    bookId: "3",
    title: "Lão Hạc",
    authorId: "a4",
    authorName: "Nam Cao",
    imgUrl:
        "https://sach.baikiemtra.com/uploads/book/lao-hac/lao-hac-nam-cao.jpg",
    rating: 4.7,
    description:
        "Truyện ngắn kinh điển về số phận người nông dân nghèo Việt Nam trước cách mạng.",
    chapters: [],
    ratingCount: 920,
    chapterCount: 80,
    genres: ["literature", "short_stories"],
    isAddedToLibrary: true,
  ),

  Book(
    bookId: "4",
    title: "Hai số phận",
    authorId: "a5",
    authorName: "Nguyễn Nhật Ánh",
    imgUrl:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRezvyxp5-kuUyiFIJMjRmVulX6yqdnx4kU5w&s",
    rating: 4.3,
    description: "Câu chuyện lãng mạn, nhẹ nhàng, đậm chất tuổi học trò.",
    chapters: [],
    ratingCount: 2000,
    chapterCount: 300,
    genres: ["romance", "children"],
    isAddedToLibrary: true,
  ),

  Book(
    bookId: "5",
    title: "Harry Potter và Hòn Đá Phù Thủy",
    authorId: "a6",
    authorName: "J.K. Rowling",
    imgUrl:
        "https://play-lh.googleusercontent.com/xo2HfLoAszntYndTjrUhZXqa7xCmeSkSXxcsPPeQx3-cRrzYSGmbjSwKO2F7o-RWuJhy",
    rating: 4.9,
    description: "Khởi đầu của series huyền thoại về thế giới phép thuật.",
    chapters: [],
    ratingCount: 15000,
    chapterCount: 450,
    genres: ["children", "fantasy", "mystery"],
    isAddedToLibrary: true,
  ),

  Book(
    bookId: "6",
    title: "Truyện Kiều",
    authorId: "a7",
    authorName: "Stephen Hawking",
    imgUrl:
        "https://product.hstatic.net/200000017360/product/truyenkieutb2_0ee50ff34c9547f89e51f41987adecaf_master.jpg",
    rating: 4.7,
    description:
        "Giải thích các khái niệm phức tạp của vật lý lý thuyết và vũ trụ học.",
    chapters: [],
    ratingCount: 3500,
    chapterCount: 400,
    genres: ["science"],
    isAddedToLibrary: true,
  ),

  Book(
    bookId: "7",
    title: "Sherlock Holmes: Nghiên Cứu Màu Đỏ",
    authorId: "a8",
    authorName: "Arthur Conan Doyle",
    imgUrl:
        "https://file.hstatic.net/200000090875/file/sher1_5844446110bb45cba8cfb086e3066ed3_grande.jpg",
    rating: 4.6,
    description:
        "Vụ án đầu tiên của bộ đôi thám tử huyền thoại Sherlock Holmes và Dr. Watson.",
    chapters: [],
    ratingCount: 5000,
    chapterCount: 350,
    genres: ["mystery", "short_stories"],
    isAddedToLibrary: true,
  ),

  Book(
    bookId: "12",
    title: "Không gia đình",
    authorId: "a10",
    authorName: "Hector Malot",
    imgUrl:
        "https://cdn1.fahasa.com/media/flashmagazine/images/page_images/khong_gia_dinh_tai_ban_2024/2024_11_05_16_37_52_1-390x510.jpg",
    rating: 4.8,
    description: "Tác phẩm kinh điển về cuộc phiêu lưu của cậu bé mồ côi Remi.",
    chapters: sampleChapters,

    // Thuộc tính REQUIRED mới
    ratingCount: 3000.0,
    chapterCount: 750.0,
    genres: ["literature", "children"],
    isAddedToLibrary: true,
  ),
];
