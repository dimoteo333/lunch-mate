import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:intl/intl.dart';
import 'package:app/data/models/party_model.dart';
import 'package:app/providers/party_provider.dart';
import 'package:app/providers/auth_provider.dart';
import 'package:app/core/theme/app_theme.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/kakao_map_widget.dart';

class PartyDetailScreen extends ConsumerWidget {
  final String partyId;

  const PartyDetailScreen({super.key, required this.partyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final partyAsync = ref.watch(partyDetailProvider(partyId));
    final currentUser = ref.watch(authProvider).user;
    final actionState = ref.watch(partyControllerProvider);
    final theme = ShadTheme.of(context);
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: LiquidBackground(
        child: Stack(
          children: [
            // ── Main content ──
            partyAsync.when(
              data: (party) {
                final isCreator = party.creatorId == currentUser?.userId;
                final isParticipant = party.participants.any(
                    (p) => p.userId == currentUser?.userId && p.status == 'joined');
                final isConfirmed = party.status == PartyStatus.confirmed;

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(16, topPadding + 56 + 16, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 제목 및 상태
                            Text(
                              party.title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.foreground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildStatusBadge(party.status, theme),
                            const SizedBox(height: 24),

                            // 정보 카드
                            ShadCard(
                              child: Column(
                                children: [
                                  _buildInfoRow(
                                    Icons.calendar_today,
                                    '일시',
                                    DateFormat('M월 d일 (E) a h:mm', 'ko')
                                        .format(party.startTime),
                                    theme,
                                  ),
                                  Divider(color: theme.colorScheme.border),
                                  _buildInfoRow(
                                    Icons.location_on,
                                    '장소',
                                    party.locationName ?? '미정',
                                    theme,
                                  ),
                                  Divider(color: theme.colorScheme.border),
                                  _buildInfoRow(
                                    Icons.person,
                                    '인원',
                                    '${party.currentParticipants} / ${party.maxParticipants}명',
                                    theme,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 지도
                            if (party.locationLat != null &&
                                party.locationLon != null) ...[
                              Text(
                                '위치',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.foreground,
                                ),
                              ),
                              const SizedBox(height: 8),
                              KakaoMapWidget(
                                latitude: party.locationLat!,
                                longitude: party.locationLon!,
                                height: 180,
                                zoomLevel: 3,
                                interactive: false,
                                markers: [
                                  MapMarkerData(
                                    lat: party.locationLat!,
                                    lon: party.locationLon!,
                                    label: party.locationName ?? party.title,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],

                            // 설명
                            if (party.description != null) ...[
                              Text(
                                '상세 내용',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.foreground,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                party.description!,
                                style: TextStyle(
                                  color: theme.colorScheme.foreground,
                                ),
                              ),
                              const SizedBox(height: 24),
                            ],

                            // 참여자 목록
                            Text(
                              '참여자',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.foreground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: party.participants.length,
                              itemBuilder: (context, index) {
                                final p = party.participants[index];
                                if (p.status != 'joined') {
                                  return const SizedBox.shrink();
                                }
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: theme.colorScheme.muted,
                                    child: Text(
                                      p.user.nickname[0],
                                      style: TextStyle(
                                        color: theme.colorScheme.foreground,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    p.user.nickname,
                                    style: TextStyle(
                                      color: theme.colorScheme.foreground,
                                    ),
                                  ),
                                  subtitle: Text(
                                    p.user.companyName ?? '',
                                    style: TextStyle(
                                      color: theme.colorScheme.mutedForeground,
                                    ),
                                  ),
                                  trailing: p.userId == party.creatorId
                                      ? ShadBadge.outline(
                                          child: const Text('방장'),
                                        )
                                      : null,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 하단 액션 버튼
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SafeArea(
                        child: SizedBox(
                          width: double.infinity,
                          child: _buildActionButton(
                            context,
                            ref,
                            party,
                            isCreator,
                            isParticipant,
                            isConfirmed,
                            actionState.isLoading,
                            theme,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              error: (err, stack) => Padding(
                padding: EdgeInsets.only(top: topPadding + 56 + 16),
                child: Center(
                  child: Text(
                    '오류: $err',
                    style: TextStyle(color: theme.colorScheme.destructive),
                  ),
                ),
              ),
              loading: () => Padding(
                padding: EdgeInsets.only(top: topPadding + 56 + 16),
                child: Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),

            // ── Glass AppBar ──
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _GlassAppBar(topPadding: topPadding),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value, ShadThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.mutedForeground),
          const SizedBox(width: 12),
          Text(label,
              style: TextStyle(color: theme.colorScheme.mutedForeground)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(PartyStatus status, ShadThemeData theme) {
    String text;
    Color color;
    switch (status) {
      case PartyStatus.recruiting:
        text = '모집중';
        color = theme.colorScheme.primary;
      case PartyStatus.confirmed:
        text = '확정됨';
        color = const Color(0xFF34D399);
      case PartyStatus.completed:
        text = '종료됨';
        color = theme.colorScheme.mutedForeground;
      case PartyStatus.cancelled:
        text = '취소됨';
        color = theme.colorScheme.destructive;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    WidgetRef ref,
    PartyModel party,
    bool isCreator,
    bool isParticipant,
    bool isConfirmed,
    bool isLoading,
    ShadThemeData theme,
  ) {
    if (isLoading) {
      return ShadButton(
        enabled: false,
        onPressed: () {},
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: theme.colorScheme.primaryForeground,
        ),
      );
    }

    if (isConfirmed && isParticipant) {
      return ShadButton(
        onPressed: () => context.push('/chat/${party.partyId}'),
        child: const Text('채팅방 입장'),
      );
    }

    if (isCreator) {
      return ShadButton.outline(
        onPressed: () {
          ShadSonner.of(context).show(
            const ShadToast(
              title: Text('파티 취소 기능은 준비 중입니다'),
            ),
          );
        },
        child: const Text('파티 취소'),
      );
    }

    if (isParticipant) {
      return ShadButton.outline(
        onPressed: () =>
            ref.read(partyControllerProvider.notifier).leaveParty(partyId),
        child: const Text('파티 나가기'),
      );
    }

    if (party.status == PartyStatus.recruiting) {
      return ShadButton(
        onPressed: () =>
            ref.read(partyControllerProvider.notifier).joinParty(partyId),
        child: const Text('참여하기'),
      );
    }

    return ShadButton(
      enabled: false,
      onPressed: () {},
      child: const Text('마감되었습니다'),
    );
  }
}

class _GlassAppBar extends StatelessWidget {
  final double topPadding;

  const _GlassAppBar({required this.topPadding});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final barBgColor =
        isDark ? const Color(0x66000000) : const Color(0x66FFFFFF);

    return Column(
      children: [
        SizedBox(height: topPadding),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
              child: Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: AppTheme.glassDecoration(
                  borderRadius: 100,
                  backgroundColor: barBgColor,
                  brightness: theme.brightness,
                ),
                child: Row(
                  children: [
                    ShadButton.ghost(
                      size: ShadButtonSize.sm,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 18,
                        color: theme.colorScheme.foreground,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '파티 상세',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.foreground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
