import 'package:flutter/material.dart';
import '../widget/custom_button.dart';

/// 확인/취소 다이얼로그 위젯
///
/// 사용자에게 확인을 요청하는 다이얼로그입니다.
class ConfirmDialog extends StatelessWidget {
  /// 다이얼로그 제목
  ///
  /// 다이얼로그 상단에 표시될 제목입니다.
  final String title;

  /// 다이얼로그 메시지
  ///
  /// 사용자에게 표시될 메시지입니다.
  final String message;

  /// 확인 버튼 텍스트
  ///
  /// 기본값은 '확인'입니다.
  final String confirmText;

  /// 취소 버튼 텍스트
  ///
  /// 기본값은 '취소'입니다.
  final String cancelText;

  /// 확인 버튼 클릭 시 실행될 콜백
  ///
  /// 필수 파라미터입니다.
  final VoidCallback onConfirm;

  /// 취소 버튼 클릭 시 실행될 콜백
  ///
  /// null일 경우 다이얼로그만 닫습니다.
  final VoidCallback? onCancel;

  /// ConfirmDialog 생성자
  ///
  /// [title] 다이얼로그 제목 (필수)
  /// [message] 다이얼로그 메시지 (필수)
  /// [confirmText] 확인 버튼 텍스트 (기본값: '확인')
  /// [cancelText] 취소 버튼 텍스트 (기본값: '취소')
  /// [onConfirm] 확인 버튼 클릭 콜백 (필수)
  /// [onCancel] 취소 버튼 클릭 콜백 (선택사항)
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = '확인',
    this.cancelText = '취소',
    required this.onConfirm,
    this.onCancel,
  });

  /// 취소 처리
  ///
  /// onCancel 콜백이 있으면 호출하고, 다이얼로그를 닫습니다.
  void _handleCancel(BuildContext context) {
    onCancel?.call();
    Navigator.of(context).pop();
  }

  /// 확인 처리
  ///
  /// onConfirm 콜백을 호출하고, 다이얼로그를 닫습니다.
  void _handleConfirm(BuildContext context) {
    onConfirm();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      CustomButton(
        text: cancelText,
        style: CustomButtonStyle.secondary,
        size: ButtonSize.small,
        onPressed: () => _handleCancel(context),
      ),
      const SizedBox(width: 8),
      CustomButton(
        text: confirmText,
        size: ButtonSize.small,
        onPressed: () => _handleConfirm(context),
      ),
    ],
  );
}
