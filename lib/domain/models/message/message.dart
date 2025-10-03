import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

enum MessageType {
  text,
  image,
  recording,
  uploadButton,
  loading,
  start,
  end,
  action,
}

@freezed
class Message with _$Message {
  const factory Message({
    required String role,
    required String content,
    int? timestamp,
    @Default(MessageType.text) MessageType type,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

Message generateAssistantMessage(
  String content, {
  int? timestamp,
  MessageType type = MessageType.text,
}) {
  return Message(
    role: 'assistant',
    content: content,
    timestamp: timestamp,
    type: type,
  );
}

Message generateUserMessage(
  String content, {
  int? timestamp,
  MessageType type = MessageType.text,
}) {
  return Message(
    role: 'user',
    content: content,
    timestamp: timestamp,
    type: type,
  );
}
