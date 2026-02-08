import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:intl/intl.dart';
import 'package:app/providers/party_provider.dart';
import '../widgets/liquid_glass.dart';

class PartyCreateScreen extends ConsumerStatefulWidget {
  const PartyCreateScreen({super.key});

  @override
  ConsumerState<PartyCreateScreen> createState() => _PartyCreateScreenState();
}

class _PartyCreateScreenState extends ConsumerState<PartyCreateScreen> {
  final _formKey = GlobalKey<ShadFormState>();

  // Date/time state managed separately (no ShadDatePicker form field)
  DateTime _startTime = DateTime.now().add(const Duration(minutes: 30));

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

                  ShadInputFormField(
                    id: 'location_name',
                    label: const Text('장소명 (선택)'),
                    placeholder: const Text('장소명을 입력하세요'),
                  ),
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
