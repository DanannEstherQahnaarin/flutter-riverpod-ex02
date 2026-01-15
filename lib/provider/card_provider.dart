import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_card_ui_app_ex01/logger.dart';
import 'package:flutter_card_ui_app_ex01/model/card_item.dart';
import 'package:flutter_card_ui_app_ex01/exceptions/card_item_exception.dart';

/// CardProvider의 상태를 관리하는 Notifier
class CardNotifier extends Notifier<List<CardItem>> {
  @override
  List<CardItem> build() {
    logger.i('카드 프로바이더 초기화');
    return [];
  }

  /// 카드 목록 조회
  List<CardItem> getList() {
    logger.i('카드 목록 조회: ${state.length}개');
    return List.unmodifiable(state);
  }

  /// 카드 추가
  Future<({bool success, String message})> addCard(CardItem card) async {
    try {
      // 카드 검증
      card.validate();

      // 중복 체크
      if (state.any((item) => item.id == card.id)) {
        throw CardItemDuplicateException(card.id);
      }

      // 카드 추가
      state = [...state, card];
      logger.i('카드 추가 성공: ${card.id}');
      return (success: true, message: '카드가 성공적으로 추가되었습니다.');
    } on CardItemIdEmptyException catch (e, stackTrace) {
      logger.e('카드 추가 실패 - ID 비어있음: ${e.message}', error: e, stackTrace: stackTrace);
      return (success: false, message: e.message);
    } on CardTitleEmptyException catch (e, stackTrace) {
      logger.e('카드 추가 실패 - 제목 비어있음: ${e.message}', error: e, stackTrace: stackTrace);
      return (success: false, message: e.message);
    } on CardItemDuplicateException catch (e, stackTrace) {
      logger.e('카드 추가 실패 - 중복: ${e.message}', error: e, stackTrace: stackTrace);
      return (success: false, message: e.message);
    } catch (e, stackTrace) {
      logger.e('카드 추가 실패 - 알 수 없는 오류', error: e, stackTrace: stackTrace);
      return (success: false, message: '카드 추가 중 오류가 발생했습니다.');
    }
  }

  /// 카드 수정
  Future<({bool success, String message})> updateCard(CardItem card) async {
    try {
      // 카드 검증
      card.validate();

      // 카드 존재 여부 확인
      final index = state.indexWhere((item) => item.id == card.id);
      if (index == -1) {
        throw CardItemNotFoundException(card.id);
      }

      // 카드 수정
      final updatedList = List<CardItem>.from(state);
      updatedList[index] = card;
      state = updatedList;
      logger.i('카드 수정 성공: ${card.id}');
      return (success: true, message: '카드가 성공적으로 수정되었습니다.');
    } on CardItemIdEmptyException catch (e, stackTrace) {
      logger.e('카드 수정 실패 - ID 비어있음: ${e.message}', error: e, stackTrace: stackTrace);
      return (success: false, message: e.message);
    } on CardTitleEmptyException catch (e, stackTrace) {
      logger.e('카드 수정 실패 - 제목 비어있음: ${e.message}', error: e, stackTrace: stackTrace);
      return (success: false, message: e.message);
    } on CardItemNotFoundException catch (e, stackTrace) {
      logger.e('카드 수정 실패 - 카드 없음: ${e.message}', error: e, stackTrace: stackTrace);
      return (success: false, message: e.message);
    } catch (e, stackTrace) {
      logger.e('카드 수정 실패 - 알 수 없는 오류', error: e, stackTrace: stackTrace);
      return (success: false, message: '카드 수정 중 오류가 발생했습니다.');
    }
  }

  /// 카드 삭제
  Future<({bool success, String message})> deleteCard(String id) async {
    try {
      // ID 검증
      if (id.isEmpty) {
        throw CardItemIdEmptyException();
      }

      // 카드 존재 여부 확인
      final index = state.indexWhere((item) => item.id == id);
      if (index == -1) {
        throw CardItemNotFoundException(id);
      }

      // 카드 삭제
      state = (List<CardItem>.from(state)..removeAt(index));
      logger.i('카드 삭제 성공: $id');
      return (success: true, message: '카드가 성공적으로 삭제되었습니다.');
    } on CardItemIdEmptyException catch (e, stackTrace) {
      logger.e('카드 삭제 실패 - ID 비어있음: ${e.message}', error: e, stackTrace: stackTrace);
      return (success: false, message: e.message);
    } on CardItemNotFoundException catch (e, stackTrace) {
      logger.e('카드 삭제 실패 - 카드 없음: ${e.message}', error: e, stackTrace: stackTrace);
      return (success: false, message: e.message);
    } catch (e, stackTrace) {
      logger.e('카드 삭제 실패 - 알 수 없는 오류', error: e, stackTrace: stackTrace);
      return (success: false, message: '카드 삭제 중 오류가 발생했습니다.');
    }
  }
}

/// CardProvider의 Provider 정의
final cardProvider = NotifierProvider<CardNotifier, List<CardItem>>(() => CardNotifier());
