import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:intl/intl.dart';
import '../../../data/models/chat_model.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/liquid_glass.dart';
import '../../core/theme/app_theme.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String roomId;
  const ChatScreen({super.key, required this.roomId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider(widget.roomId));
    final currentUser = ref.watch(authProvider).user;
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: LiquidBackground(
        child: Column(
          children: [
            Expanded(
              child: chatState.isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: theme.colorScheme.primary,
                      ),
                    )
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(16),
                      itemCount: chatState.messages.length,
                      itemBuilder: (context, index) {
                        final message = chatState.messages[index];
                        if (message.type == 'system') {
                          return _buildSystemMessage(message, theme);
                        }

                        final isMe =
                            message.senderId == currentUser?.userId;
                        return _buildMessageBubble(message, isMe, theme);
                      },
                    ),
            ),
            _buildInputArea(theme),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ShadThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final barBgColor = isDark
        ? const Color(0x66000000)
        : const Color(0x66FFFFFF);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: AppTheme.glassDecoration(
              borderRadius: 20,
              backgroundColor: barBgColor,
              brightness: theme.brightness,
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.chat_bubble_rounded,
              color: theme.colorScheme.primaryForeground,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text('채팅방'),
        ],
      ),
      centerTitle: false,
    );
  }

  Widget _buildSystemMessage(ChatMessageModel message, ShadThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: GlassCard(
        borderRadius: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          message.content,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
    ChatMessageModel message,
    bool isMe,
    ShadThemeData theme,
  ) {
    final timeFormat = DateFormat('a h:mm', 'ko');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.muted,
                    theme.colorScheme.muted.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  message.sender?.nickname[0] ?? '?',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.foreground,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe && message.sender != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: Text(
                      message.sender!.nickname,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.mutedForeground,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: isMe
                          ? LinearGradient(
                              colors: [
                                theme.colorScheme.primary,
                                theme.colorScheme.primary
                                    .withValues(alpha: 0.8),
                              ],
                            )
                          : null,
                      color: isMe
                          ? null
                          : theme.colorScheme.card
                              .withValues(alpha: 0.8),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft:
                            isMe ? const Radius.circular(18) : Radius.zero,
                        bottomRight:
                            isMe ? Radius.zero : const Radius.circular(18),
                      ),
                      border: isMe
                          ? null
                          : Border.all(
                              color: theme.colorScheme.border
                                  .withValues(alpha: 0.5),
                            ),
                    ),
                    child: Text(
                      message.content,
                      style: TextStyle(
                        color: isMe
                            ? theme.colorScheme.primaryForeground
                            : theme.colorScheme.foreground,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeFormat.format(message.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildInputArea(ShadThemeData theme) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: ShadInput(
                  controller: _textController,
                  placeholder: const Text('메시지 입력...'),
                  onSubmitted: (_) => _sendMessage(),
                  minLines: 1,
                  maxLines: 4,
                ),
              ),
              const SizedBox(width: 8),
              ShadButton(
                size: ShadButtonSize.sm,
                backgroundColor: theme.colorScheme.primary,
                onPressed: _sendMessage,
                child: Icon(
                  Icons.send_rounded,
                  color: theme.colorScheme.primaryForeground,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      ref.read(chatProvider(widget.roomId).notifier).sendMessage(text);
      _textController.clear();
    }
  }
}
