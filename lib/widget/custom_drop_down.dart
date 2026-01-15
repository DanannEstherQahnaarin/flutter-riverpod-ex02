import 'package:flutter/material.dart';

/// 재사용 가능한 커스텀 드롭다운 위젯
///
/// Map 구조의 아이템을 받아 드롭다운 메뉴를 생성합니다.
/// 선택 시 콜백 함수를 통해 선택된 값을 전달합니다.
///
/// 주요 특징:
/// - `Map<String, String>` 형태의 아이템 지원
/// - 라벨 및 힌트 텍스트 지원
/// - 에러 메시지 표시
/// - 선택 콜백 함수 지원
/// - 초기값 설정 가능
///
/// 예시:
/// ```dart
/// CustomDropDown(
///   label: '카테고리',
///   hint: '카테고리를 선택하세요',
///   items: {
///     'work': '업무',
///     'personal': '개인',
///     'hobby': '취미',
///   },
///   onChanged: (key, value) {
///     print('선택된 값: $key - $value');
///   },
/// )
/// ```
class CustomDropDown extends StatelessWidget {
  /// 필드 라벨
  ///
  /// 필드 위에 표시될 라벨 텍스트입니다.
  final String? label;

  /// 힌트 텍스트
  ///
  /// 드롭다운이 비어있을 때 표시될 힌트입니다.
  final String? hint;

  /// 드롭다운 아이템
  ///
  /// `Map<String, String>` 형태로 key-value 쌍을 받습니다.
  /// key는 선택 시 콜백에 전달되는 값이고,
  /// value는 드롭다운에 표시되는 텍스트입니다.
  final Map<String, String> items;

  /// 선택 변경 콜백
  ///
  /// 아이템이 선택될 때 호출되는 콜백입니다.
  /// 첫 번째 파라미터는 선택된 아이템의 key,
  /// 두 번째 파라미터는 선택된 아이템의 value입니다.
  final void Function(String key, String value)? onChanged;

  /// 초기 선택 값
  ///
  /// 드롭다운의 초기 선택 값을 설정합니다.
  /// items의 key 중 하나여야 합니다.
  final String? initialValue;

  /// 에러 메시지
  ///
  /// 유효성 검증 실패 시 표시될 에러 메시지입니다.
  /// null이 아닐 경우 에러 스타일로 표시됩니다.
  final String? errorText;

  /// 비활성화 여부
  ///
  /// true일 경우 드롭다운이 비활성화됩니다.
  final bool enabled;

  /// CustomDropDown 생성자
  ///
  /// [label] 필드 라벨 (선택사항)
  /// [hint] 힌트 텍스트 (선택사항)
  /// [items] 드롭다운 아이템 (필수)
  /// [onChanged] 선택 변경 콜백 (선택사항)
  /// [initialValue] 초기 선택 값 (선택사항)
  /// [errorText] 에러 메시지 (선택사항)
  /// [enabled] 비활성화 여부 (기본값: true)
  const CustomDropDown({
    super.key,
    this.label,
    this.hint,
    required this.items,
    this.onChanged,
    this.initialValue,
    this.errorText,
    this.enabled = true,
  });

  /// initialValue가 items의 key 중 하나인지 검증
  ///
  /// 유효하지 않으면 null을 반환합니다.
  String? _getValidatedInitialValue() {
    if (initialValue == null || initialValue!.isEmpty) {
      return null;
    }
    // items의 key 중 하나인지 확인
    if (items.containsKey(initialValue)) {
      return initialValue;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final validatedInitialValue = _getValidatedInitialValue();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: errorText != null ? Colors.red : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
        ],
        DropdownButtonFormField<String>(
          initialValue: validatedInitialValue,
          items: items.entries
              .map(
                (entry) =>
                    DropdownMenuItem<String>(value: entry.key, child: Text(entry.value)),
              )
              .toList(),
          onChanged: enabled
              ? (String? selectedKey) {
                  if (selectedKey != null && onChanged != null) {
                    final selectedValue = items[selectedKey] ?? '';
                    onChanged!(selectedKey, selectedValue);
                  }
                }
              : null,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: errorText != null ? Colors.red : Colors.blue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: enabled ? Colors.white : Colors.grey.shade100,
          ),
        ),
      ],
    );
  }
}
