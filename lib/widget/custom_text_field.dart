import 'package:flutter/material.dart';

/// 재사용 가능한 커스텀 텍스트 필드 위젯
///
/// 라벨, 힌트, 에러 메시지를 지원하는 텍스트 입력 필드입니다.
/// 유효성 검증 상태를 시각적으로 표시합니다.
///
/// 주요 특징:
/// - 라벨 및 힌트 텍스트 지원
/// - 에러 메시지 표시
/// - 유효성 검증 상태 시각화
/// - Props 기반 설계로 재사용성 높음
///
/// 예시:
/// ```dart
/// CustomTextField(
///   label: '제목',
///   hint: '할일 제목을 입력하세요',
///   controller: titleController,
///   errorText: validationError,
///   onChanged: (value) => validateTitle(value),
/// )
/// ```
class CustomTextField extends StatelessWidget {
  /// 필드 라벨
  ///
  /// 필드 위에 표시될 라벨 텍스트입니다.
  final String? label;

  /// 힌트 텍스트
  ///
  /// 필드가 비어있을 때 표시될 힌트입니다.
  final String? hint;

  /// 텍스트 컨트롤러
  ///
  /// 텍스트 필드의 값을 제어하는 컨트롤러입니다.
  final TextEditingController? controller;

  /// 에러 메시지
  ///
  /// 유효성 검증 실패 시 표시될 에러 메시지입니다.
  /// null이 아닐 경우 에러 스타일로 표시됩니다.
  final String? errorText;

  /// 텍스트 변경 콜백
  ///
  /// 텍스트가 변경될 때마다 호출되는 콜백입니다.
  final ValueChanged<String>? onChanged;

  /// 최대 라인 수
  ///
  /// 여러 줄 입력을 지원하는 경우 최대 라인 수입니다.
  /// 기본값은 1입니다.
  final int maxLines;

  /// 최대 문자 수
  ///
  /// 입력 가능한 최대 문자 수입니다.
  final int? maxLength;

  /// 읽기 전용 여부
  ///
  /// true일 경우 입력이 불가능합니다.
  final bool readOnly;

  /// 탭 이벤트 콜백
  ///
  /// 필드를 탭했을 때 호출되는 콜백입니다.
  /// 주로 날짜 선택 등에 사용됩니다.
  final VoidCallback? onTap;

  /// CustomTextField 생성자
  ///
  /// [label] 필드 라벨 (선택사항)
  /// [hint] 힌트 텍스트 (선택사항)
  /// [controller] 텍스트 컨트롤러 (선택사항)
  /// [errorText] 에러 메시지 (선택사항)
  /// [onChanged] 텍스트 변경 콜백 (선택사항)
  /// [maxLines] 최대 라인 수 (기본값: 1)
  /// [maxLength] 최대 문자 수 (선택사항)
  /// [readOnly] 읽기 전용 여부 (기본값: false)
  /// [onTap] 탭 이벤트 콜백 (선택사항)
  const CustomTextField({
    super.key,
    this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.onChanged,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Column(
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
      GestureDetector(
        onTap: onTap,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          maxLines: maxLines,
          maxLength: maxLength,
          readOnly: readOnly,
          enabled: onTap == null, // onTap이 있으면 enabled를 false로 설정하여 키보드 표시 방지
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
            fillColor: readOnly || onTap != null ? Colors.grey.shade100 : Colors.white,
            suffixIcon: onTap != null ? const Icon(Icons.calendar_today, size: 20) : null,
          ),
        ),
      ),
    ],
  );
}
