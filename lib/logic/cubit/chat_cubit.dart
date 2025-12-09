import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit({
    required this.chatId,
    required this.adminId,
    required this.recipientId,
  }) : super(ChatInitial());

  final String chatId;

  final supabase = Supabase.instance.client;
  RealtimeChannel? _channel;
  final String adminId;
  final String recipientId;

  List<Map<String, dynamic>> _messages = [];

  /// تحميل الشات + تفعيل الريل تايم
  Future<void> loadChat() async {
    emit(ChatLoading());

    try {
      final response = await supabase
          .from('chats')
          .select()
          .eq('id', chatId)
          .maybeSingle();

      // ✅ إنشاء الشات لأول مرة
      if (response == null) {
        await supabase.from('chats').insert({
          'id': chatId,
          'user_one_id': supabase.auth.currentUser!.id,
          'user_two_id': recipientId,
          'messages': [],
        });

        _messages = [];
      } else {
        _messages = List<Map<String, dynamic>>.from(response['messages'] ?? []);
      }

      emit(ChatLoaded(List.from(_messages)));
      _listenRealtime();
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  /// إرسال رسالة
  Future<void> sendMessage(String message) async {
    final senderId = supabase.auth.currentUser!.id;

    final newMessage = {
      'id': senderId,
      'message': message,
      'created_at': DateTime.now().toIso8601String(),
    };

    _messages.add(newMessage);

    await supabase
        .from('chats')
        .update({'messages': _messages})
        .eq('id', chatId);

    emit(ChatLoaded(List.from(_messages)));
  }

  /// Realtime listener
  void _listenRealtime() {
    _channel?.unsubscribe();

    _channel = supabase
        .channel('chat_$chatId')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'chats',
          callback: (payload) {
            final newMessages = payload.newRecord['messages'];
            _messages = List<Map<String, dynamic>>.from(newMessages ?? []);
            emit(ChatLoaded(List.from(_messages)));
          },
        )
        .subscribe();
  }

  @override
  Future<void> close() {
    _channel?.unsubscribe();
    return super.close();
  }
}
