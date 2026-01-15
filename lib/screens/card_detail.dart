import 'package:flutter/material.dart';
import 'package:flutter_card_ui_app_ex01/logger.dart';
import 'package:flutter_card_ui_app_ex01/model/card_item.dart';
import 'package:flutter_card_ui_app_ex01/widget/card_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardDetailScreen extends ConsumerStatefulWidget {
  final CardItem cardItem;
  const CardDetailScreen({super.key, required this.cardItem});

  @override
  ConsumerState<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends ConsumerState<CardDetailScreen> {
  @override
  Widget build(BuildContext context) {
    logger.i('CardItem Detail Form');
    return Scaffold(
      appBar: AppBar(title: const Text('Card'), elevation: 2.0),
      body: CardForm(
        initalCi: widget.cardItem,
        isReadOnly: true,
        onSubmit:
            ({required category, description, isUse = false, required title}) async {
              logger.i('card form submit');
            },
        onCancel: () {
          Navigator.of(context).pop();
          return;
        },
      ),
    );
  }
}
