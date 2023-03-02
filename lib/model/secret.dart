import 'package:flutter/material.dart';

import '../event/event_bus.dart';
import '../utils/utils.dart';

class Secret {
  String id;
  String title;
  String content;

  Secret({
    this.id = "",
    this.title = "",
    this.content = "",
  });

  factory Secret.fromJson(Map<String, dynamic> json) {
    return Secret(
      id: json['id'],
      title: json['title'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'id': id,
      };

  Secret copyWith({
    String? title,
    String? id,
    String? content,
  }) {
    return Secret(
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }
}

class SecretAction extends StatefulWidget {
  final Secret secret;
  final FocusNode? focusNode;
  final Function(Secret) onSecretUpdated;
  final Function(Secret) onSecretDeleted;

  const SecretAction({
    Key? key,
    required this.secret,
    required this.onSecretUpdated,
    required this.onSecretDeleted,
    this.focusNode,
  }) : super(key: key);

  @override
  _SecretActionState createState() => _SecretActionState();
}

class _SecretActionState extends State<SecretAction> {
  late TextEditingController _titleEditingController;
  late TextEditingController _contentEditingController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleEditingController = TextEditingController(text: widget.secret.title);
    _contentEditingController =
        TextEditingController(text: widget.secret.content);
    eventBus.on<int>().listen((hashCode) {
      onOtherSecretEditing(hashCode);
    });
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();
    super.dispose();
  }

  onOtherSecretEditing(int hashCode) {
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
    widget.onSecretUpdated(widget.secret.copyWith(title: newTitle));
    _toggleEditing();
  }

  void _updateContent(String newContent) {
    widget.onSecretUpdated(widget.secret.copyWith(content: newContent));
    _toggleEditing();
  }

  void _deleteSecret() {
    widget.onSecretDeleted(widget.secret);
  }

  Widget _showTitle() {
    return GestureDetector(
      onTap: () {
        _toggleEditing();
        eventBus.fire(widget.hashCode);
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              widget.secret.title,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => copyToClipboard(widget.secret.content),
          ),
          IconButton(
            icon: const Icon(Icons.visibility),
            onPressed: _showContent,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteSecret,
          ),
        ],
      ),
    );
  }

  Widget _editSecret() {
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
    );
  }

  void _showContent() {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(widget.secret.content,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
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
                String content = _titleEditingController.text;
                _updateContent(content);
                _titleEditingController.clear();
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
    return _isEditing ? _editSecret() : _showTitle();
  }
}
