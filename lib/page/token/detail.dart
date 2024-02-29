import 'package:flutter/material.dart';
import 'package:secret_book/db/token.dart';
import 'package:secret_book/event/event_bus.dart';
import 'package:secret_book/model/api_client.dart';
import 'package:secret_book/model/event.dart';
import 'package:secret_book/model/token.dart';
import 'package:secret_book/utils/time.dart';
import 'package:secret_book/utils/utils.dart';
import 'package:secret_book/extensions/context_extension.dart';

class EventTokenUpdated {}

class EventTokenDeleted {}

class EventTokenEditing {
  final int hashCode;
  EventTokenEditing({
    required this.hashCode,
  });
}

class TokenAction extends StatefulWidget {
  final Token token;
  final FocusNode? focusNode;

  const TokenAction({
    Key? key,
    required this.token,
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
    eventBus.on<EventTokenEditing>().listen((event) {
      onOtherTokenEditing(event.hashCode);
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

  void _updateTitle(BuildContext context, String newTitle) {
    Token token = widget.token.copyWith(title: newTitle);
    TokenBookData().updateToken(token).then((newToken) {
      if (!context.autoPushEvent) {
        return;
      }
      pushEvent(
          context.serverAddr,
          Event(
            id: token.id,
            name: "update token ${token.title}",
            date: nowStr(),
            data_type: "token",
            event_type: "update",
            content: token.toJson().toString(),
            from: context.name,
          )).then((value) {
        if (value == "") {
          context.showSnackBar("发送事件成功");
        } else {
          context.showSnackBar("发送事件失败, 原因： $value");
        }
      });
    }).then((_) => eventBus.fire(EventTokenUpdated()));
    _toggleEditing();
  }

  void _updateContent(BuildContext context, String newContent) {
    Token token = widget.token.copyWith(content: newContent);
    TokenBookData().updateToken(token).then((newToken) {
      if (!context.autoPushEvent) {
        return;
      }
      pushEvent(
          context.serverAddr,
          Event(
            id: token.id,
            name: "update token ${token.title}",
            date: nowStr(),
            data_type: "token",
            event_type: "update",
            content: token.toJson().toString(),
            from: context.name,
          )).then((value) {
        if (value == "") {
          context.showSnackBar("发送事件成功");
        } else {
          context.showSnackBar("发送事件失败, 原因： $value");
        }
      });
    }).then((_) => eventBus.fire(EventTokenUpdated()));
    _toggleEditing();
  }

  void _deleteToken() {
    TokenBookData()
        .deleteToken(widget.token)
        .then((_) {
          if (!context.autoPushEvent) {
            return;
          }
          pushEvent(
              context.serverAddr,
              Event(
                id: widget.token.id,
                name: "delete token ${widget.token.title}",
                date: nowStr(),
                data_type: "token",
                event_type: "delete",
                content: widget.token.toJson().toString(),
                from: context.name,
              )).then((value) {
            if (value == "") {
              context.showSnackBar("发送事件成功");
            } else {
              context.showSnackBar("发送事件失败, 原因： $value");
            }
          });
        })
        .then((_) => dispose)
        .then((_) => eventBus.fire(EventTokenDeleted()));
  }

  void _uploadToken() {
    pushEvent(
        context.serverAddr,
        Event(
          id: widget.token.id,
          name: "upload token ${widget.token.title}",
          date: nowStr(),
          data_type: "token",
          event_type: "update",
          content: widget.token.toJson().toString(),
          from: context.name,
        )).then((value) {
      if (value == "") {
        context.showSnackBar("上传成功");
      } else {
        context.showSnackBar("上传失败, 原因： $value");
      }
    });
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
    List<Widget> buttons = [
      Expanded(
          child: IconButton(
        icon: const Icon(Icons.copy),
        onPressed: onCopy,
        tooltip: '复制内容',
      )),
      Expanded(
          child: IconButton(
        icon: const Icon(Icons.visibility),
        onPressed: _showContent,
        tooltip: '显示内容',
      )),
      Expanded(
          child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: _deleteToken,
        tooltip: '删除',
        // disabledColor: _isEditing ? Colors.grey : Colors.red,
      )),
    ];
    if (context.canSync) {
      buttons.add(Expanded(
          child: IconButton(
        onPressed: _uploadToken,
        icon: const Icon(Icons.upload),
        tooltip: '上传',
      )));
    }
    return GestureDetector(
        onTap: () {
          _toggleEditing();
          eventBus.fire(EventTokenEditing(hashCode: widget.hashCode));
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(),
              Expanded(
                child: Container(
                  child: Text(
                    widget.token.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                  child: Row(
                children: buttons,
              )),
              Spacer(),
              // Container(),
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
        _updateTitle(context, value);
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
                _updateContent(context, content);
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
