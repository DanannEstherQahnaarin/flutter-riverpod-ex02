import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_ui_app_ex01/model/card_item.dart';
import 'package:flutter_card_ui_app_ex01/widget/custom_button.dart';
import 'package:flutter_card_ui_app_ex01/widget/custom_drop_down.dart';
import 'package:flutter_card_ui_app_ex01/widget/custom_radios.dart';
import 'package:flutter_card_ui_app_ex01/widget/custom_text_field.dart';

class CardForm extends StatefulWidget {
  final CardItem? initalCi;

  final Future<void> Function({
    required String title,
    required String category,
    String? description,
    bool isUse,
  })
  onSubmit;

  final VoidCallback? onCancel;

  final bool isReadOnly;

  const CardForm({
    super.key,
    this.initalCi,
    this.onCancel,
    required this.onSubmit,
    this.isReadOnly = false,
  });

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  late final TextEditingController _txtTitleController;
  late final EditorState _editorState;
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  bool _isUse = true;

  @override
  void initState() {
    super.initState();
    _txtTitleController = TextEditingController(text: widget.initalCi?.title ?? '');
    _editorState = EditorState.blank();
    _selectedCategory = widget.initalCi?.category;
    _isUse = widget.initalCi?.isUse ?? true;
  }

  @override
  void dispose() {
    _txtTitleController.dispose();
    _editorState.dispose();
    super.dispose();
  }

  String _getDescriptionText() {
    final buffer = StringBuffer();
    for (final node in _editorState.document.root.children) {
      if (node.type == 'paragraph' || node.type == 'heading') {
        final delta = node.delta;
        if (delta != null) {
          for (final operation in delta.toJson()) {
            if (operation is Map && operation['insert'] is String) {
              buffer.write(operation['insert']);
            }
          }
        }
      }
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    const textStyleConfig = TextStyleConfiguration(
      text: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
    );

    Map<String, String> category() => {
      'cate1': '업무',
      'cate2': '개인',
      'cate3': '교육',
      'cate4': '생활',
      'cate5': '건강',
      'cate6': '취미',
    };

    Map<String, String> using() => {'is_use': '사용', 'is_not_use': '미사용'};

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Title',
                hint: 'input title text...',
                controller: _txtTitleController,
                readOnly: widget.isReadOnly,
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: CustomDropDown(
                      items: category(),
                      label: 'Category',
                      hint: 'select category...',
                      enabled: !widget.isReadOnly,
                      initialValue: widget.initalCi?.category,
                      onChanged: (key, value) {
                        setState(() {
                          _selectedCategory = key;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: CustomRadios(
                      items: using(),
                      label: 'Use',
                      direction: RadioDirection.horizontal,
                      enabled: !widget.isReadOnly,
                      initialValue: widget.initalCi?.isUse == true
                          ? 'is_use'
                          : 'is_not_use',
                      onChanged: (key, value) {
                        setState(() {
                          _isUse = key == 'is_use';
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SafeArea(
                child: Container(
                  height: 300,
                  // 시각적 디버깅을 위해 테두리 추가
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.white,
                  ),
                  child: AppFlowyEditor(
                    editorState: _editorState,
                    editable: !widget.isReadOnly,
                    editorStyle: EditorStyle.desktop(
                      cursorColor: Colors.blue,
                      selectionColor: Colors.blue.shade300,
                      padding: const EdgeInsets.all(10.0),
                      textStyleConfiguration: textStyleConfig, // 공통 스타일 적용
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (!widget.isReadOnly) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      text: 'Cancel',
                      style: CustomButtonStyle.secondary,
                      onPressed: widget.onCancel ?? () {},
                    ),
                    const SizedBox(width: 20),
                    CustomButton(
                      text: 'Add',
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final title = _txtTitleController.text.trim();
                          if (title.isEmpty) {
                            return;
                          }
                          if (_selectedCategory == null) {
                            return;
                          }
                          final description = _getDescriptionText().trim();
                          widget.onSubmit(
                            title: title,
                            category: _selectedCategory!,
                            description: description.isEmpty ? null : description,
                            isUse: _isUse,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
