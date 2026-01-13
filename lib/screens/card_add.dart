import 'package:flutter/material.dart';
import 'package:flutter_card_ui_app_ex01/model/card_item.dart';
import 'package:flutter_card_ui_app_ex01/provider/card_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardAddScreen extends ConsumerStatefulWidget {
  const CardAddScreen({super.key});

  @override
  ConsumerState<CardAddScreen> createState() => _CardAddScreenState();
}

class _CardAddScreenState extends ConsumerState<CardAddScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submitItem({
    required String title,
    required String category,
    String? description,
    bool isUse = true,
  }) async {
    final newItem = CardItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      category: category,
      isUse: isUse || false,
    );

    final ({bool success, String message}) result = await ref
        .read(cardProvider.notifier)
        .addCard(newItem);

    if (mounted) {
      if (result.success) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message)));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(result.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cards = ref.watch(cardProvider);
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Card'), elevation: 2.0),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: []),
        ),
      ),
    );
  }
}
