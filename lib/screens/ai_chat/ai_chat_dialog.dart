import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/repositories/ai_chat_repository.dart';
import 'package:smart_reader/theme/app_colors.dart';
import 'bloc/ai_chat_bloc.dart';
import 'bloc/ai_chat_event.dart';
import 'bloc/ai_chat_state.dart';

class AIChatDialog extends StatefulWidget {
  final String bookId;
  final String? chapterId;
  final String bookTitle;
  final String chapterTitle;
  final String chapterContent; // Nội dung chương để AI sử dụng

  const AIChatDialog({
    super.key,
    required this.bookId,
    this.chapterId,
    required this.bookTitle,
    required this.chapterTitle,
    required this.chapterContent,
  });

  @override
  State<AIChatDialog> createState() => _AIChatDialogState();
}

class _AIChatDialogState extends State<AIChatDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AIChatBloc(
        repository: AIChatRepository(),
        bookId: widget.bookId,
        chapterId: widget.chapterId,
      )..add(
          InitializeChat(bookId: widget.bookId, chapterId: widget.chapterId)),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color(0xFF5A3BA3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🤖 AI Assistant',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.bookTitle} • ${widget.chapterTitle}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Chat messages
            Expanded(
              child: BlocBuilder<AIChatBloc, AIChatState>(
                builder: (context, state) {
                  if (state is AIChatInitial) {
                    return _buildEmptyState();
                  }

                  final messages = state.messages;

                  if (messages.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      if (message.isLoading) {
                        return _buildLoadingBubble();
                      }

                      return _buildMessageBubble(message);
                    },
                  );
                },
              ),
            ),
            // Error state
            BlocBuilder<AIChatBloc, AIChatState>(
              builder: (context, state) {
                if (state is AIChatError) {
                  return Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      border: Border.all(color: Colors.red.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.error,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            // Input field
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Hỏi AI về nội dung...',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      onSubmitted: (_) => _sendMessage(context),
                    ),
                  ),
                  const SizedBox(width: 8),
                  BlocBuilder<AIChatBloc, AIChatState>(
                    builder: (context, state) {
                      final isLoading = state is AIChatLoading;
                      return GestureDetector(
                        onTap: isLoading ? null : () => _sendMessage(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, Color(0xFF5A3BA3)],
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🤖',
            style: TextStyle(fontSize: 64),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chào bạn! 👋',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy hỏi AI về nội dung chương này',
            style: TextStyle(
              color: Colors.grey.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickQuestion('Tóm tắt chương này'),
              _buildQuickQuestion('Giải thích nhân vật'),
              _buildQuickQuestion('Chủ đề chính là gì?'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickQuestion(String question) {
    return GestureDetector(
      onTap: () {
        _controller.text = question;
        _sendMessage(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          question,
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(dynamic message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF5A3BA3)],
                ),
              ),
              child: const Center(
                child: Text('🤖', style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser
                    ? AppColors.primary.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                message.text,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: const Center(
                child: Text('👤', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, Color(0xFF5A3BA3)],
              ),
            ),
            child: const Center(
              child: Text('🤖', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: AnimatedOpacity(
                    opacity: 0.6,
                    duration: Duration(milliseconds: 300 + (index * 200)),
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(BuildContext context) {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    context.read<AIChatBloc>().add(
          SendChatMessage(
            question: question,
            context: widget.chapterContent,
          ),
        );

    _controller.clear();
  }
}
