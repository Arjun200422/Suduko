import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: Provider.of<GameProvider>(context, listen: false).getStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No statistics available yet.'));
          }
          
          final stats = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatisticsCard(
                  context,
                  'Games Overview',
                  [
                    _buildStatRow('Total Games', '${stats['totalGames']}'),
                    _buildStatRow('Completed Games', '${stats['completedGames']}'),
                    _buildStatRow(
                      'Completion Rate', 
                      stats['totalGames'] > 0
                        ? '${(stats['completedGames'] / stats['totalGames'] * 100).toStringAsFixed(1)}%'
                        : '0%'
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildStatisticsCard(
                  context,
                  'Games by Difficulty',
                  [
                    _buildStatRow('Easy Games', '${stats['easyGames']}'),
                    _buildStatRow('Medium Games', '${stats['mediumGames']}'),
                    _buildStatRow('Hard Games', '${stats['hardGames']}'),
                  ],
                ),
                const SizedBox(height: 16),
                _buildStatisticsCard(
                  context,
                  'Best Times',
                  [
                    _buildStatRow(
                      'Easy', 
                      stats['bestTimeEasy'] > 0
                        ? _formatTime(stats['bestTimeEasy'])
                        : 'N/A'
                    ),
                    _buildStatRow(
                      'Medium', 
                      stats['bestTimeMedium'] > 0
                        ? _formatTime(stats['bestTimeMedium'])
                        : 'N/A'
                    ),
                    _buildStatRow(
                      'Hard', 
                      stats['bestTimeHard'] > 0
                        ? _formatTime(stats['bestTimeHard'])
                        : 'N/A'
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildStatisticsCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}