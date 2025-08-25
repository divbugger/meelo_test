import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meelo/models/figure_status.dart';
import 'package:meelo/services/figure_status_service.dart';
import 'package:meelo/l10n/app_localizations.dart';

class FigureConnectionScreen extends StatefulWidget {
  const FigureConnectionScreen({super.key});

  @override
  State<FigureConnectionScreen> createState() => _FigureConnectionScreenState();
}

class _FigureConnectionScreenState extends State<FigureConnectionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FigureStatusService>(context, listen: false).loadFigureStatuses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF040506)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Figures',
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF040506),
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<FigureStatusService>(
        builder: (context, figureStatusService, child) {
          if (figureStatusService.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF483FA9),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.boxConnectionStatus,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF040506),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  localizations.boxConnectionDescription,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    children: [
                      _buildFigureStatusCard(context, FigureType.lifeStory, figureStatusService, localizations),
                      const SizedBox(height: 16),
                      _buildFigureStatusCard(context, FigureType.familyAndFriends, figureStatusService, localizations),
                      const SizedBox(height: 16),
                      _buildFigureStatusCard(context, FigureType.music, figureStatusService, localizations),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  Widget _buildFigureStatusCard(
    BuildContext context,
    FigureType figureType,
    FigureStatusService figureStatusService,
    AppLocalizations localizations,
  ) {
    final isConnected = figureStatusService.isFigureConnected(figureType);
    final displayName = figureStatusService.getFigureTypeDisplayName(figureType, localizations);
    
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            _getFigureIcon(figureType),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF040506),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isConnected ? localizations.connectedToBox : localizations.notConnected,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      color: isConnected ? Colors.green : Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: isConnected,
              onChanged: (value) async {
                try {
                  await figureStatusService.toggleFigureConnection(figureType);
                } catch (error) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(localizations.failedToUpdateConnectionStatus),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              activeColor: const Color(0xFF483FA9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFigureIcon(FigureType type) {
    IconData iconData;
    Color iconColor = const Color(0xFF483FA9);

    switch (type) {
      case FigureType.lifeStory:
        iconData = Icons.auto_stories;
        break;
      case FigureType.familyAndFriends:
        iconData = Icons.people;
        break;
      case FigureType.music:
        iconData = Icons.music_note;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

}