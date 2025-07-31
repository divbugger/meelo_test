// lib/widgets/language_selector.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meelo/services/language_service.dart';
import 'package:meelo/l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return PopupMenuButton<String>(
          icon: const Icon(Icons.language),
          tooltip: l10n.selectLanguage,
          onSelected: (String languageCode) async {
            await languageService.changeLanguage(languageCode);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.languageChanged),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          itemBuilder: (BuildContext context) {
            return languageService.getSupportedLanguages().map((language) {
              final isSelected =
                  languageService.currentLocale.languageCode ==
                  language['code'];

              return PopupMenuItem<String>(
                value: language['code'],
                child: Row(
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      language['nativeName']!,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color:
                            isSelected
                                ? Theme.of(context).colorScheme.primary
                                : null,
                      ),
                    ),
                  ],
                ),
              );
            }).toList();
          },
        );
      },
    );
  }
}

class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => const LanguageSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<LanguageService>(
      builder: (context, languageService, child) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.language),
              const SizedBox(width: 8),
              Text(l10n.selectLanguage),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                languageService.getSupportedLanguages().map((language) {
                  final isSelected =
                      languageService.currentLocale.languageCode ==
                      language['code'];

                  return ListTile(
                    leading: Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color:
                          isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                    ),
                    title: Text(
                      language['nativeName']!,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(language['name']!),
                    onTap: () async {
                      await languageService.changeLanguage(language['code']!);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.languageChanged),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  );
                }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }
}