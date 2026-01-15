import 'package:flutter/material.dart';

/// 라디오 버튼 배치 방향
enum RadioDirection {
  /// 가로 배치
  horizontal,

  /// 세로 배치
  vertical,
}

/// 재사용 가능한 커스텀 라디오 버튼 그룹 위젯
///
/// Map 구조의 아이템을 받아 라디오 버튼 그룹을 생성합니다.
/// 선택 시 콜백 함수를 통해 선택된 값을 전달합니다.
///
/// 주요 특징:
/// - `Map<String, String>` 형태의 아이템 지원
/// - 최소 2개 이상의 라디오 버튼 필요
/// - 가로/세로 배치 선택 가능
/// - 라벨 및 에러 메시지 지원
/// - 선택 콜백 함수 지원
/// - 초기값 설정 가능
///
/// 예시:
/// ```dart
/// CustomRadios(
///   label: '사용 여부',
///   items: {
///     'true': '사용중',
///     'false': '미사용',
///   },
///   direction: RadioDirection.horizontal,
///   onChanged: (key, value) {
///     print('선택된 값: $key - $value');
///   },
/// )
/// ```
class CustomRadios extends StatefulWidget {
  /// 필드 라벨
  ///
  /// 필드 위에 표시될 라벨 텍스트입니다.
  final String? label;

  /// 라디오 버튼 아이템
  ///
  /// `Map<String, String>` 형태로 key-value 쌍을 받습니다.
  /// key는 선택 시 콜백에 전달되는 값이고,
  /// value는 라디오 버튼에 표시되는 텍스트입니다.
  /// 최소 2개 이상의 아이템이 필요합니다.
  final Map<String, String> items;

  /// 선택 변경 콜백
  ///
  /// 라디오 버튼이 선택될 때 호출되는 콜백입니다.
  /// 첫 번째 파라미터는 선택된 아이템의 key,
  /// 두 번째 파라미터는 선택된 아이템의 value입니다.
  final void Function(String key, String value)? onChanged;

  /// 초기 선택 값
  ///
  /// 라디오 버튼 그룹의 초기 선택 값을 설정합니다.
  /// items의 key 중 하나여야 합니다.
  final String? initialValue;

  /// 에러 메시지
  ///
  /// 유효성 검증 실패 시 표시될 에러 메시지입니다.
  /// null이 아닐 경우 에러 스타일로 표시됩니다.
  final String? errorText;

  /// 배치 방향
  ///
  /// 라디오 버튼을 가로로 배치할지 세로로 배치할지 결정합니다.
  /// 기본값은 세로(vertical)입니다.
  final RadioDirection direction;

  /// 비활성화 여부
  ///
  /// true일 경우 라디오 버튼이 비활성화됩니다.
  final bool enabled;

  /// 라디오 버튼 간 간격
  ///
  /// 라디오 버튼 사이의 간격을 설정합니다.
  /// 기본값은 16.0입니다.
  final double spacing;

  /// CustomRadios 생성자
  ///
  /// [label] 필드 라벨 (선택사항)
  /// [items] 라디오 버튼 아이템 (필수, 최소 2개 이상)
  /// [onChanged] 선택 변경 콜백 (선택사항)
  /// [initialValue] 초기 선택 값 (선택사항)
  /// [errorText] 에러 메시지 (선택사항)
  /// [direction] 배치 방향 (기본값: RadioDirection.vertical)
  /// [enabled] 비활성화 여부 (기본값: true)
  /// [spacing] 라디오 버튼 간 간격 (기본값: 16.0)
  const CustomRadios({
    super.key,
    this.label,
    required this.items,
    this.onChanged,
    this.initialValue,
    this.errorText,
    this.direction = RadioDirection.vertical,
    this.enabled = true,
    this.spacing = 16.0,
  }) : assert(items.length >= 2, '라디오 버튼은 최소 2개 이상이어야 합니다.');

  @override
  State<CustomRadios> createState() => _CustomRadiosState();
}

class _CustomRadiosState extends State<CustomRadios> {
  late String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(CustomRadios oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedValue = widget.initialValue;
    }
  }

  void _handleChanged(String? value) {
    if (value != null && widget.enabled) {
      setState(() {
        _selectedValue = value;
      });

      if (widget.onChanged != null) {
        final selectedText = widget.items[value] ?? '';
        widget.onChanged!(value, selectedText);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final radioWidgets = widget.items.entries
        .map(
          (entry) => RadioListTile<String>(
            title: Text(entry.value),
            value: entry.key,
            // ignore: deprecated_member_use
            groupValue: _selectedValue,
            // ignore: deprecated_member_use
            onChanged: widget.enabled ? _handleChanged : null,
            contentPadding: EdgeInsets.zero,
            dense: true,
            visualDensity: VisualDensity.compact,
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: widget.errorText != null ? Colors.red : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
        ],
        widget.direction == RadioDirection.horizontal
            ? Row(
                children: [
                  for (int i = 0; i < radioWidgets.length; i++) ...[
                    Expanded(child: radioWidgets[i]),
                    if (i < radioWidgets.length - 1) SizedBox(width: widget.spacing),
                  ],
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < radioWidgets.length; i++) ...[
                    radioWidgets[i],
                    if (i < radioWidgets.length - 1) SizedBox(height: widget.spacing),
                  ],
                ],
              ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            widget.errorText!,
            style: const TextStyle(fontSize: 12, color: Colors.red),
          ),
        ],
      ],
    );
  }
}
