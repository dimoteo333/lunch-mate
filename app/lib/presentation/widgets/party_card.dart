import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/party_model.dart';
import '../../core/theme/app_theme.dart';

class PartyCard extends StatelessWidget {
  final PartyModel party;
  final VoidCallback? onTap;

  const PartyCard({
    super.key,
    required this.party,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('M월 d일 (E) a h:mm', 'ko');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: AppTheme.glassDecoration(borderRadius: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Title + Status Badge ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          party.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildStatusBadge(),
                    ],
                  ),

                  // ── Description ──
                  if (party.description != null &&
                      party.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      party.description!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMuted,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 12),

                  // ── Time + Location row ──
                  Row(
                    children: [
                      const Icon(Icons.access_time_rounded,
                          size: 14, color: AppTheme.textSubtle),
                      const SizedBox(width: 4),
                      Text(
                        dateFormat.format(party.startTime),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.location_on_rounded,
                          size: 14, color: AppTheme.textSubtle),
                      const SizedBox(width: 4),
                      Text(
                        '${party.distanceKm?.toStringAsFixed(1) ?? '-'}km',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Divider ──
                  Container(
                    height: 1,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          AppTheme.glassBorder,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── Creator + Participant count ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppTheme.glassBg,
                              border:
                                  Border.all(color: AppTheme.glassBorder),
                            ),
                            child: Center(
                              child: Text(
                                party.creator.nickname[0],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            party.creator.nickname,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: AppTheme.blue500.withValues(alpha: 0.15),
                          border: Border.all(
                            color: AppTheme.blue500.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          '${party.currentParticipants}/${party.maxParticipants}명',
                          style: const TextStyle(
                            color: AppTheme.blue400,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    String text;
    Color color;

    switch (party.status) {
      case PartyStatus.recruiting:
        text = '모집중';
        color = AppTheme.blue400;
        break;
      case PartyStatus.confirmed:
        text = '확정';
        color = const Color(0xFF34D399); // green-400
        break;
      case PartyStatus.completed:
        text = '완료';
        color = AppTheme.textSubtle;
        break;
      case PartyStatus.cancelled:
        text = '취소';
        color = const Color(0xFFF87171); // red-400
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
