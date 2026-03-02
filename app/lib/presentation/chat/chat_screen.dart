import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/models/user_brief_model.dart';
import '../../../providers/chat_provider.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/liquid_glass.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/debouncer.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String roomId;
  const ChatScreen({super.key, required this.roomId});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 75));

  bool _showAutocomplete = false;
  String _mentionQuery = '';
  List<UserBriefModel> _filteredMembers = [];

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _textController.text;
    final cursorPosition = _textController.selection.baseOffset;

    if (cursorPosition < 0 || cursorPosition > text.length) return;

    final textBeforeCursor = text.substring(0, cursorPosition);
    final lastAtPos = textBeforeCursor.lastIndexOf('@');

    if (lastAtPos >= 0) {
      if (lastAtPos == 0 ||
          textBeforeCursor[lastAtPos - 1] == ' ' ||
          textBeforeCursor[lastAtPos - 1] == '\n') {
        final query = textBeforeCursor.substring(lastAtPos + 1);
        if (!query.contains(' ') && !query.contains('\n')) {
          _mentionQuery = query;
          // Debounce the filtering to reduce rebuilds during rapid typing
          _debouncer.run(_filterMembers);
          return;
        }
      }
    }

    // Hide autocomplete immediately (no debounce needed for hiding)
    if (_showAutocomplete) {
      setState(() => _showAutocomplete = false);
    }
  }

  void _filterMembers() {
    final chatState = ref.read(chatProvider(widget.roomId));
    final members = chatState.members ?? [];
    final currentUser = ref.read(authProvider).user;

    setState(() {
      _filteredMembers = members
          .where(
            (m) =>
                m.userId != currentUser?.userId &&
                m.nickname.toLowerCase().contains(_mentionQuery.toLowerCase()),
          )
          .toList();
      _showAutocomplete = _filteredMembers.isNotEmpty;
    });
  }

  void _insertMention(UserBriefModel user) {
    final text = _textController.text;
    final cursorPosition = _textController.selection.baseOffset;
    final textBeforeCursor = text.substring(0, cursorPosition);
    final textAfterCursor = text.substring(cursorPosition);

    final lastAtPos = textBeforeCursor.lastIndexOf('@');
    final beforeAt = textBeforeCursor.substring(0, lastAtPos);

    final newText = '$beforeAt@${user.nickname} $textAfterCursor';
    final newCursorPos = beforeAt.length + user.nickname.length + 2;

    _textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newCursorPos),
    );

    setState(() => _showAutocomplete = false);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

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

                        final isMe = message.senderId == currentUser?.userId;
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
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
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
                  (message.sender?.nickname.isNotEmpty ?? false)
                      ? message.sender!.nickname[0]
                      : '?',
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
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
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
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: isMe
                        ? LinearGradient(
                            colors: [
                              theme.colorScheme.primary,
                              theme.colorScheme.primary.withValues(alpha: 0.8),
                            ],
                          )
                        : null,
                    color: isMe
                        ? null
                        : theme.colorScheme.card.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: isMe
                          ? const Radius.circular(18)
                          : Radius.zero,
                      bottomRight: isMe
                          ? Radius.zero
                          : const Radius.circular(18),
                    ),
                    border: isMe
                        ? null
                        : Border.all(
                            color: theme.colorScheme.border.withValues(
                              alpha: 0.5,
                            ),
                          ),
                  ),
                  child: _buildMessageText(message.content, theme, isMe),
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

  Widget _buildMessageText(String content, ShadThemeData theme, bool isMe) {
    // Match @mentions with alphanumeric, underscore, and Korean characters
    final RegExp mentionRegex = RegExp(r'@([a-zA-Z0-9_가-힣]+)');
    final Iterable<RegExpMatch> matches = mentionRegex.allMatches(content);

    if (matches.isEmpty) {
      return Text(
        content,
        style: TextStyle(
          color: isMe
              ? theme.colorScheme.primaryForeground
              : theme.colorScheme.foreground,
        ),
      );
    }

    final List<InlineSpan> spans = [];
    int start = 0;
    for (final match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: content.substring(start, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(
            color: isMe ? Colors.white : theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      start = match.end;
    }
    if (start < content.length) {
      spans.add(TextSpan(text: content.substring(start)));
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: isMe
              ? theme.colorScheme.primaryForeground
              : theme.colorScheme.foreground,
          fontSize: 14,
        ),
        children: spans,
      ),
    );
  }

  Widget _buildAutocompleteList(ShadThemeData theme) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 150),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.border.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredMembers.length,
        itemBuilder: (context, index) {
          final user = _filteredMembers[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              child: Text(
                user.nickname.isNotEmpty ? user.nickname[0] : '?',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
            title: Text(user.nickname),
            dense: true,
            onTap: () => _insertMention(user),
          );
        },
      ),
    );
  }

  Widget _buildInputArea(ShadThemeData theme) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showAutocomplete) _buildAutocompleteList(theme),
          Padding(
            padding: const EdgeInsets.all(16),
            child: GlassCard(
              borderRadius: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: ShadInput(
                      focusNode: _focusNode,
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
        ],
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
