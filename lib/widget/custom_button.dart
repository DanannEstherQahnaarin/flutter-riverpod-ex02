import 'package:flutter/material.dart';

/// 버튼 스타일 열거형
///
/// 버튼의 시각적 스타일을 정의합니다.
enum CustomButtonStyle {
  /// 주요 버튼 (강조)
  primary,

  /// 보조 버튼 (일반)
  secondary,

  /// 위험한 작업 버튼 (삭제 등)
  danger,
}

/// 버튼 크기 열거형
///
/// 버튼의 크기를 정의합니다.
enum ButtonSize {
  /// 작은 크기
  small,

  /// 중간 크기 (기본값)
  medium,

  /// 큰 크기
  large,
}

/// 재사용 가능한 커스텀 버튼 위젯
class CustomButton extends StatelessWidget {
  /// 버튼에 표시될 텍스트
  ///
  /// 필수 파라미터입니다.
  final String text;

  /// 버튼 클릭 시 실행될 콜백
  ///
  /// null일 경우 버튼이 비활성화됩니다.
  final VoidCallback? onPressed;

  /// 버튼 스타일
  ///
  /// 기본값은 CustomButtonStyle.primary입니다.
  final CustomButtonStyle style;

  /// 버튼 크기
  ///
  /// 기본값은 ButtonSize.medium입니다.
  final ButtonSize size;

  /// 아이콘 (선택사항)
  ///
  /// 버튼 텍스트 앞에 표시될 아이콘입니다.
  final IconData? icon;

  /// CustomButton 생성자
  ///
  /// [text] 버튼에 표시될 텍스트 (필수)
  /// [onPressed] 버튼 클릭 시 실행될 콜백
  /// [style] 버튼 스타일 (기본값: CustomButtonStyle.primary)
  /// [size] 버튼 크기 (기본값: ButtonSize.medium)
  /// [icon] 버튼 아이콘 (선택사항)
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style = CustomButtonStyle.primary,
    this.size = ButtonSize.medium,
    this.icon,
  });

  /// 버튼 스타일에 따른 색상 반환
  ///
  /// [style] 버튼 스타일
  /// [isEnabled] 버튼 활성화 여부
  ///
  /// Returns 버튼 색상
  Color _getButtonColor(CustomButtonStyle style, bool isEnabled) {
    if (!isEnabled) {
      return Colors.grey;
    }

    switch (style) {
      case CustomButtonStyle.primary:
        return Colors.blue;
      case CustomButtonStyle.secondary:
        return Colors.grey.shade600;
      case CustomButtonStyle.danger:
        return Colors.red;
    }
  }

  /// 버튼 크기에 따른 높이 반환
  ///
  /// [size] 버튼 크기
  ///
  /// Returns 버튼 높이
  double _getButtonHeight(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 36.0;
      case ButtonSize.medium:
        return 48.0;
      case ButtonSize.large:
        return 56.0;
    }
  }

  /// 버튼 크기에 따른 폰트 크기 반환
  ///
  /// [size] 버튼 크기
  ///
  /// Returns 폰트 크기
  double _getFontSize(ButtonSize size) {
    switch (size) {
      case ButtonSize.small:
        return 14.0;
      case ButtonSize.medium:
        return 16.0;
      case ButtonSize.large:
        return 18.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final buttonColor = _getButtonColor(style, isEnabled);
    final buttonHeight = _getButtonHeight(size);
    final fontSize = _getFontSize(size);

    return SizedBox(
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade600,
          padding: EdgeInsets.symmetric(
            horizontal: size == ButtonSize.small ? 16.0 : 24.0,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[Icon(icon, size: fontSize), const SizedBox(width: 8)],
            Text(text, style: TextStyle(fontSize: fontSize)),
          ],
        ),
      ),
    );
  }
}
