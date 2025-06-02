import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'injection.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  final List<String> _chats = [];
  List<String> _filteredChats = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  late Box _box;
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  String? _newChatName;
  int? _animatingChatIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late bool _isDarkTheme;

  @override
  void initState() {
    super.initState();
    _box = Hive.box('chatBox');
    final savedChats = _box.get('chatList', defaultValue: []);
    _chats.addAll(List<String>.from(savedChats));
    _filteredChats = List.from(_chats);

    _isDarkTheme = _box.get('isDarkTheme', defaultValue: true);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _searchController.addListener(_filterChats);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterChats() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChats = _chats.where((chat) => chat.toLowerCase().contains(query)).toList();
    });
  }

  void _createChat() {
    setState(() {
      int index = 1;
      String newChat;
      do {
        newChat = 'Новый чат ($index)';
        index++;
      } while (_chats.contains(newChat));

      _chats.add(newChat);
      _filteredChats = List.from(_chats);
      _box.put('chatList', _chats);
      _box.put(newChat, []);
      _newChatName = newChat;
    });

    _controller.forward(from: 0);
    Future.delayed(const Duration(milliseconds: 300), () => _openChat(_newChatName!));
  }

  void _openChat(String chatName) {
    _controller.forward(from: 0);
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const SizedBox(), // Placeholder
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0.0, 0.2),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ));
        return SlideTransition(position: offsetAnimation, child: ChatDetailPage(chatName: chatName));
      },
    ));
  }

  void _deleteChat(int index) {
    final chatName = _filteredChats[index];
    setState(() {
      _chats.remove(chatName);
      _filteredChats = List.from(_chats);
      _box.put('chatList', _chats);
      _box.delete(chatName);
    });
  }

  void _renameChat(int index) async {
    final oldName = _filteredChats[index];
    final TextEditingController controller = TextEditingController(text: oldName);

    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить название чата'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Новое название'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена')),
          TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text('Сохранить')),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty && !_chats.contains(newName)) {
      final messages = _box.get(oldName);
      setState(() {
        int fullIndex = _chats.indexOf(oldName);
        _chats[fullIndex] = newName;
        _filteredChats = List.from(_chats);
        _box.put('chatList', _chats);
        _box.put(newName, messages);
        _box.delete(oldName);
      });
    }
  }

  void _showChatMenu(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Переименовать чат'),
              onTap: () {
                Navigator.pop(context);
                _renameChat(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Удалить чат', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteChat(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
      _box.put('isDarkTheme', _isDarkTheme);
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _filteredChats = List.from(_chats);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatCardColor = _isDarkTheme ? const Color(0xFF3A3A3A) : const Color(0xFFE3F2FD);
    final chatTextColor = _isDarkTheme ? Colors.white : Colors.black87;

    return MaterialApp(
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Builder(
        builder: (context) => Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text('Настройки', style: TextStyle(color: Colors.white, fontSize: 26)),
                ),
                SwitchListTile(
                  title: const Text('Темная тема', style: TextStyle(fontSize: 18)),
                  value: _isDarkTheme,
                  onChanged: (value) => _toggleTheme(),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.menu, size: 28),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            title: _isSearching
                ? TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Поиск чатов...',
                      hintStyle: TextStyle(color: _isDarkTheme ? Colors.white70 : Colors.black54),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: _isDarkTheme ? Colors.white : Colors.black, fontSize: 20),
                  )
                : const Text("GigaChat", style: TextStyle(fontSize: 24)),
            actions: [
              _isSearching
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 30),
                      onPressed: _stopSearch,
                    )
                  : IconButton(
                      icon: const Icon(Icons.search, size: 30),
                      onPressed: _startSearch,
                    )
            ],
            centerTitle: true,
          ),
          body: _filteredChats.isEmpty
              ? const Center(child: Text("Создай чат", style: TextStyle(fontSize: 22)))
              : ListView.builder(
                  itemCount: _filteredChats.length,
                  itemBuilder: (context, index) {
                    final chatTile = Card(
                      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: chatCardColor,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        title: Text(
                          _filteredChats[index],
                          style: TextStyle(fontSize: 22, color: chatTextColor),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert, color: chatTextColor, size: 28),
                          onPressed: () => _showChatMenu(index),
                        ),
                        onTap: () => _openChat(_filteredChats[index]),
                      ),
                    );

                    return _animatingChatIndex == index
                        ? SlideTransition(position: _offsetAnimation, child: chatTile)
                        : chatTile;
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: _createChat,
            child: const Icon(Icons.add, size: 30),
          ),
        ),
      ),
    );
  }
}

class ChatDetailPage extends StatefulWidget {
  final String chatName;
  const ChatDetailPage({super.key, required this.chatName});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late Box _box;
  late bool _isDarkTheme;

  late final SendMessageUseCase _sendMessageUseCase;

  @override
  void initState() {
    super.initState();
    _box = Hive.box('chatBox');
    _messages = List<String>.from(_box.get(widget.chatName, defaultValue: []));
    _isDarkTheme = _box.get('isDarkTheme', defaultValue: true);

    _sendMessageUseCase = sl<SendMessageUseCase>(); // <-- инициализация через GetIt
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(text);
        _controller.clear();
        _box.put(widget.chatName, _messages);
      });

      // Отправка сообщения через usecase и добавление ответа ассистента
      if (_sendMessageUseCase != null) {
        final aiMessages = await _sendMessageUseCase.call(text);
        if (aiMessages.isNotEmpty) {
          setState(() {
            // Добавляем только текст ответа ассистента
            _messages.addAll(
              aiMessages
                  .where((msg) => msg.role == 'assistant')
                  .map((msg) => msg.content),
            );
            _box.put(widget.chatName, _messages);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageBubbleColor = _isDarkTheme ? const Color(0xFF2A2A2A) : const Color(0xFFD7EAFB);
    final inputBackgroundColor = _isDarkTheme ? const Color(0xFF2C2C2C) : const Color(0xFFE3F2FD);
    final textColor = _isDarkTheme ? Colors.white : Colors.black87;

    return Theme(
      data: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(widget.chatName, style: const TextStyle(fontSize: 22))),
        body: Column(
          children: [
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Text(
                        'Начни диалог с ИИ-помощником',
                        style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) => Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: messageBubbleColor,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: MarkdownBody(
                            data: _messages[index],
                            styleSheet: MarkdownStyleSheet.fromTheme(
                              Theme.of(context).copyWith(
                                textTheme: Theme.of(context).textTheme.apply(
                                      bodyColor: textColor,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                color: inputBackgroundColor,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        onTap: () => _focusNode.requestFocus(),
                        style: TextStyle(color: textColor, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: "Напишите сообщение...",
                          hintStyle: TextStyle(color: _isDarkTheme ? Colors.white70 : Colors.black54, fontSize: 18),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: textColor, size: 28),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}