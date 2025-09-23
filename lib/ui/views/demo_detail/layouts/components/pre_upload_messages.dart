import 'dart:async';
import 'package:clones_desktop/ui/components/design_widget/message_box/message_box.dart';
import 'package:clones_desktop/ui/components/pfp.dart';
import 'package:clones_desktop/ui/views/demo_detail/bloc/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PreUploadMessages extends ConsumerStatefulWidget {
  const PreUploadMessages({super.key});

  @override
  ConsumerState<PreUploadMessages> createState() => _PreUploadMessagesState();
}

class _PreUploadMessagesState extends ConsumerState<PreUploadMessages> {
  String _firstMessage = '';
  String _secondMessage = '';
  String _thirdMessage = '';
  bool _showFirstMessage = false;
  bool _showSecondMessage = false;
  bool _showThirdMessage = false;

  final String _fullFirstMessage =
      'Now that your demo has been recorded, feel free to edit out anything you find sensitive. You can also trim parts that feel too long, unnecessary, or where mistakes happened. The more polished your demo is, the better your score will be!';
  final String _fullSecondMessage =
      "Once you're happy with your demo, just click Upload to send it to the Clones Quality Agent for scoring.";
  final String _fullThirdMessage =
      'Your demo is now being uploaded and reviewed by the Clones Quality Agent. This may take a little while...';

  Timer? _typingTimer;
  int _currentIndex = 0;
  int _currentMessageIndex = 0; // 0: first, 1: second, 2: third

  @override
  void initState() {
    super.initState();
    _startTyping();
  }

  @override
  void dispose() {
    _typingTimer?.cancel();
    super.dispose();
  }

  void _startTyping() {
    _currentMessageIndex = 0;
    _currentIndex = 0;
    setState(() {
      _showFirstMessage = true;
    });
    _typeCurrentMessage();
  }

  void _startThirdMessage() {
    _typingTimer?.cancel();
    _currentMessageIndex = 2;
    _currentIndex = 0;
    setState(() {
      _showThirdMessage = true;
    });
    _typeCurrentMessage();
  }

  void _typeCurrentMessage() {
    _typingTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      String fullMessage;

      switch (_currentMessageIndex) {
        case 0:
          fullMessage = _fullFirstMessage;
          break;
        case 1:
          fullMessage = _fullSecondMessage;
          break;
        case 2:
          fullMessage = _fullThirdMessage;
          break;
        default:
          timer.cancel();
          return;
      }

      if (_currentIndex < fullMessage.length) {
        setState(() {
          switch (_currentMessageIndex) {
            case 0:
              _firstMessage = fullMessage.substring(0, _currentIndex + 1);
              break;
            case 1:
              _secondMessage = fullMessage.substring(0, _currentIndex + 1);
              break;
            case 2:
              _thirdMessage = fullMessage.substring(0, _currentIndex + 1);
              break;
          }
          _currentIndex++;
        });
      } else {
        // Current message complete
        timer.cancel();

        if (_currentMessageIndex == 0) {
          // First message done, start second after delay
          Timer(const Duration(milliseconds: 500), () {
            _currentMessageIndex = 1;
            _currentIndex = 0;
            setState(() {
              _showSecondMessage = true;
            });
            _typeCurrentMessage();
          });
        }
        // For message 1 and 2, we stop here (second message waits for user action, third message is final)
      }
    });
  }

  Widget _buildMessage(String content) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: MessageBox(
            messageBoxType: MessageBoxType.talkLeft,
            content: Text(
              content,
              style: const TextStyle(fontSize: 14),
              softWrap: true,
            ),
          ),
        ),
        const Positioned(
          left: 0,
          top: 0,
          child: Pfp(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(demoDetailNotifierProvider, (previous, next) {
      if (next.isUploading) {
        _startThirdMessage();
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_showFirstMessage) _buildMessage(_firstMessage),
        if (_showSecondMessage) ...[
          const SizedBox(height: 20),
          _buildMessage(_secondMessage),
        ],
        if (_showThirdMessage) ...[
          const SizedBox(height: 20),
          _buildMessage(_thirdMessage),
        ],
      ],
    );
  }
}
