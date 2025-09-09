import 'package:clones_desktop/domain/models/factory/factory_app.dart';
import 'package:clones_desktop/domain/models/supported_token.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

enum GenerateFactoryStep {
  input,
  generating,
  preview,
}

@freezed
class GenerateFactoryState with _$GenerateFactoryState {
  const factory GenerateFactoryState({
    String? skills,
    String? error,
    String? factoryName,
    List<FactoryApp>? apps,
    @Default(false) bool showJsonEditor,
    @Default(GenerateFactoryStep.input) GenerateFactoryStep currentStep,
    @Default(false) bool isCreating,
    @Default(false) bool isCreated,
    List<SupportedToken>? supportedTokens,
    String? selectedTokenSymbol,
    String? predictedPoolAddress,
    String? fundingAmount,
    String? estimatedGasCost,
    bool? gasExceedsReward,
    String? transactionStatus,
  }) = _GenerateFactoryState;
  const GenerateFactoryState._();

  List<Map<String, String>> get examplePrompts => [
        {
          'label': 'AI Chat Interfaces',
          'text':
              'Navigating and using ChatGPT, Claude, Perplexity web interfaces for document uploads and conversations',
        },
        {
          'label': 'Social Commerce',
          'text':
              'Using TikTok Shop Creator Center, Instagram Business Suite, and YouTube Studio interfaces',
        },
        {
          'label': 'Design Tools',
          'text':
              'Creating designs in Figma web app, Canva browser interface, and Midjourney Discord commands',
        },
        {
          'label': 'Web3 Interfaces',
          'text':
              'Using MetaMask extension, Uniswap interface, OpenSea marketplace for wallet and trading operations',
        },
        {
          'label': 'Productivity Apps',
          'text':
              'Managing projects in Notion web app, Linear interface, and Obsidian desktop application',
        },
        {
          'label': 'Modern Social Platforms',
          'text':
              'Posting and managing content on X.com, Meta Threads, Discord desktop app, and LinkedIn',
        },
        {
          'label': 'Video Editing',
          'text':
              'Editing videos in browser-based editors like CapCut, DaVinci Resolve, and Premiere Pro web interfaces',
        },
        {
          'label': 'E-commerce Management',
          'text':
              'Managing online stores through Shopify, Amazon Seller Central, and Etsy shop interfaces',
        },
        {
          'label': 'Code Development',
          'text':
              'Using GitHub web interface, VS Code browser version, and online IDEs like CodePen and Replit',
        },
        {
          'label': 'Content Creation',
          'text':
              'Creating and managing content using YouTube Studio, Twitch Creator Dashboard, and podcast platforms',
        },
      ];
}
