import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:intl/intl.dart';
import 'package:app/providers/party_provider.dart';
import 'package:app/data/repositories/kakao_repository.dart';
import '../widgets/liquid_glass.dart';
import '../widgets/kakao_map_widget.dart';

class PartyCreateScreen extends ConsumerStatefulWidget {
  const PartyCreateScreen({super.key});

  @override
  ConsumerState<PartyCreateScreen> createState() => _PartyCreateScreenState();
}

class _PartyCreateScreenState extends ConsumerState<PartyCreateScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  // Date/time state managed separately (no ShadDatePicker form field)
  DateTime _startTime = DateTime.now().add(const Duration(minutes: 30));

  // Selected restaurant location
  double? _selectedLat;
  double? _selectedLon;
  String? _selectedLocationName;

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(partyControllerProvider).isLoading;
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('파티 만들기')),
      body: LiquidBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: GlassCard(
            child: ShadForm(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ShadInputFormField(
                    id: 'title',
                    label: const Text('제목'),
                    placeholder: const Text('파티 제목을 입력하세요'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '제목을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date/Time picker (dialog-based)
                  Text(
                    '일시',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ShadButton.outline(
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _startTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (date != null && context.mounted) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(_startTime),
                        );
                        if (time != null) {
                          setState(() {
                            _startTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                    leading: const Icon(Icons.calendar_today, size: 16),
                    child: Text(
                      DateFormat('yyyy-MM-dd HH:mm').format(_startTime),
                    ),
                  ),
                  const SizedBox(height: 16),

                  ShadSelectFormField<String>(
                    id: 'location_type',
                    label: const Text('장소 유형'),
                    placeholder: const Text('장소 유형을 선택하세요'),
                    initialValue: 'company_nearby',
                    options: const [
                      ShadOption(value: 'company_nearby', child: Text('회사 근처')),
                      ShadOption(value: 'midpoint', child: Text('중간 지점')),
                      ShadOption(value: 'specific', child: Text('직접 입력')),
                    ],
                    selectedOptionBuilder: (context, value) {
                      final labels = {
                        'company_nearby': '회사 근처',
                        'midpoint': '중간 지점',
                        'specific': '직접 입력',
                      };
                      return Text(labels[value] ?? value);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 장소 검색 필드
                  Text(
                    '장소명',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.foreground,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final result = await context.push<KakaoPlace>(
                        '/party/create/search-restaurant',
                      );
                      if (result != null) {
                        setState(() {
                          _selectedLat = result.lat;
                          _selectedLon = result.lon;
                          _selectedLocationName = result.placeName;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.colorScheme.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 18,
                            color: theme.colorScheme.mutedForeground,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _selectedLocationName ?? '장소를 검색하세요',
                              style: TextStyle(
                                color: _selectedLocationName != null
                                    ? theme.colorScheme.foreground
                                    : theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ),
                          if (_selectedLocationName != null)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedLat = null;
                                  _selectedLon = null;
                                  _selectedLocationName = null;
                                });
                              },
                              child: Icon(
                                Icons.close_rounded,
                                size: 18,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // 지도 미리보기
                  if (_selectedLat != null && _selectedLon != null) ...[
                    const SizedBox(height: 12),
                    KakaoMapWidget(
                      latitude: _selectedLat!,
                      longitude: _selectedLon!,
                      height: 160,
                      zoomLevel: 3,
                      interactive: false,
                      markers: [
                        MapMarkerData(
                          lat: _selectedLat!,
                          lon: _selectedLon!,
                          label: _selectedLocationName ?? '',
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Max participants select (replacing slider)
                  ShadSelectFormField<double>(
                    id: 'max_participants',
                    label: const Text('최대 인원'),
                    placeholder: const Text('인원을 선택하세요'),
                    initialValue: 4.0,
                    options: List.generate(7, (i) {
                      final val = (i + 2).toDouble();
                      return ShadOption(
                        value: val,
                        child: Text('${val.toInt()}명'),
                      );
                    }),
                    selectedOptionBuilder: (context, value) {
                      return Text('${value.toInt()}명');
                    },
                  ),
                  const SizedBox(height: 16),

                  ShadInputFormField(
                    id: 'description',
                    label: const Text('상세 설명'),
                    placeholder: const Text('파티에 대해 설명해주세요'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '설명을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  ShadButton(
                    enabled: !isLoading,
                    onPressed: _submit,
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primaryForeground,
                            ),
                          )
                        : const Text('파티 생성'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final formData =
          Map<String, dynamic>.from(_formKey.currentState!.value);

      // Add manually managed date/time
      formData['start_time'] = _startTime.toIso8601String();

      // Add selected location coordinates
      if (_selectedLat != null) formData['location_lat'] = _selectedLat;
      if (_selectedLon != null) formData['location_lon'] = _selectedLon;
      if (_selectedLocationName != null) {
        formData['location_name'] = _selectedLocationName;
      }

      try {
        await ref.read(partyControllerProvider.notifier).createParty(formData);
        if (mounted) {
          context.pop();
          ShadSonner.of(context).show(
            const ShadToast(
              title: Text('파티가 생성되었습니다!'),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ShadSonner.of(context).show(
            ShadToast.destructive(
              title: Text('생성 실패: $e'),
            ),
          );
        }
      }
    }
  }
}
