import 'package:flutter/material.dart';
import 'package:flutter_card_ui_app_ex01/logger.dart';
import 'package:flutter_card_ui_app_ex01/provider/card_provider.dart';
import 'package:flutter_card_ui_app_ex01/model/card_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardListScreen extends ConsumerStatefulWidget {
  const CardListScreen({super.key});

  @override
  ConsumerState<CardListScreen> createState() => _CardListScreenState();
}

class _CardListScreenState extends ConsumerState<CardListScreen> {
  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  /// 목업 데이터 초기화
  Future<void> _initializeMockData() async {
    // 위젯이 마운트된 후에 실행되도록 지연
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final cards = ref.read(cardProvider);
      // 이미 데이터가 있으면 추가하지 않음
      if (cards.isNotEmpty) return;

      final mockCards = [
        CardItem(
          id: 'card_001',
          title: '프로젝트 관리',
          category: '업무',
          description: '프로젝트 일정 및 작업 관리를 위한 카드',
          isUse: true,
        ),
        CardItem(
          id: 'card_002',
          title: '개인 일정',
          category: '개인',
          description: '개인 일정 및 약속 관리',
          isUse: true,
        ),
        CardItem(
          id: 'card_003',
          title: '학습 노트',
          category: '교육',
          description: '프로그래밍 학습 내용 정리',
          isUse: false,
        ),
        CardItem(
          id: 'card_004',
          title: '쇼핑 리스트',
          category: '생활',
          description: '필요한 물품 구매 목록',
          isUse: true,
        ),
        CardItem(
          id: 'card_005',
          title: '운동 계획',
          category: '건강',
          description: '주간 운동 스케줄 및 목표',
          isUse: true,
        ),
        CardItem(
          id: 'card_006',
          title: '독서 목록',
          category: '취미',
          description: '읽고 싶은 책 목록',
          isUse: false,
        ),
      ];

      // 목업 데이터 추가
      for (final card in mockCards) {
        await ref.read(cardProvider.notifier).addCard(card);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _addCard() async {}

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Card'), elevation: 2.0),
      body: cards.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.grid_3x3, size: 40, color: Colors.grey.shade600),
                  const SizedBox(height: 16),
                  Text(
                    'Card Item is Empty',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return GridCardItem(card: card);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCard,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class GridCardItem extends StatelessWidget {
  const GridCardItem({super.key, required this.card});

  final CardItem card;

  Future<void> _detailCard() async {}

  Future<void> _delete() async {}

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // isUse 상태 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: card.isUse ? Colors.green.shade100 : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  card.isUse ? '사용중' : '미사용',
                  style: TextStyle(
                    fontSize: 10,
                    color: card.isUse ? Colors.green.shade700 : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Category 표시
          Text(
            card.category,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Title 표시
          Expanded(
            child: Text(
              card.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: _detailCard,
                icon: const Icon(Icons.delete, color: Colors.redAccent, size: 16),
              ),
              const SizedBox(width: 5),
              IconButton(
                onPressed: _detailCard,
                icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 16),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
