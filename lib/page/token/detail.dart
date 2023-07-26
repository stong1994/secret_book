import 'package:flutter/material.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/model/token.dart';
import 'package:secret_book/utils/utils.dart';

class TokenAction extends StatefulWidget {
  final Token token;
  final FocusNode? focusNode;
  final Function(Token) onTokenUpdated;
  final Function(Token) onTokenDeleted;

  const TokenAction({
    Key? key,
    required this.token,
    required this.onTokenUpdated,
    required this.onTokenDeleted,
    this.focusNode,
  }) : super(key: key);

  @override
  _TokenActionState createState() => _TokenActionState();
}

class _TokenActionState extends State<TokenAction> {
  late TextEditingController _titleEditingController;
  late TextEditingController _contentEditingController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController(text: widget.token.title);
    _contentEditingController =
        TextEditingController(text: widget.token.content);
    eventBus.on<int>().listen((hashCode) {
      onOtherTokenEditing(hashCode);
    });
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();
    super.dispose();
  }

  onOtherTokenEditing(int hashCode) {
    if (widget.hashCode != hashCode && _isEditing) {
      _toggleEditing();
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _updateTitle(String newTitle) {
    widget.onTokenUpdated(widget.token.copyWith(title: newTitle));
    _toggleEditing();
  }

  void _updateContent(String newContent) {
    widget.onTokenUpdated(widget.token.copyWith(content: newContent));
    _toggleEditing();
  }

  void _deleteToken() {
    widget.onTokenDeleted(widget.token);
  }

  void onCopy() {
    copyToClipboard(widget.token.content);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pop();
        });
        return const AlertDialog(
          title: Text('已复制'),
        );
      },
    );
  }

  Widget _show() {
    return GestureDetector(
        onTap: () {
          _toggleEditing();
          eventBus.fire(widget.hashCode);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Expanded(
            child: Center(
              child: Text(
                widget.token.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
              child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: onCopy,
                tooltip: '复制内容',
              ),
              IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: _showContent,
                tooltip: '显示内容',
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteToken,
                tooltip: '删除',
                // disabledColor: _isEditing ? Colors.grey : Colors.red,
              ),
            ],
          )),
        ]));
  }

  Widget _edit() {
    return TextFormField(
      controller: _titleEditingController,
      autofocus: true,
      style: TextStyle(fontSize: 18.0, color: Colors.black87),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 0.8,
            color: Colors.grey.shade400,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 0.8,
            color: Colors.grey.shade400,
          ),
        ),
      ),
      onFieldSubmitted: (value) {
        _updateTitle(value);
        _titleEditingController.clear();
      },
      onTapOutside: (event) => _toggleEditing(),
    );
  }

  void _showContent() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('详情',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              )),
          content: SingleChildScrollView(
              child: TextField(
            // focusNode: _focusNode,
            autofocus: true,
            controller: _contentEditingController,
            decoration: const InputDecoration(
              // fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              hintText: 'do something...',
              hintStyle: TextStyle(
                color: Color.fromARGB(255, 235, 186, 186),
                fontSize: 16,
              ),
              border: UnderlineInputBorder(),
            ),
          )),
          actions: [
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('完成'),
              onPressed: () {
                String content = _contentEditingController.text;
                _updateContent(content);
                _contentEditingController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isEditing ? _edit() : _show();
  }
}
