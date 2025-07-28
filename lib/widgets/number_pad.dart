import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import 'animated_number_button.dart';

class NumberPad extends StatelessWidget {
  const NumberPad({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(9, (index) => Expanded(
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: AnimatedNumberButton(
                number: (index + 1).toString(),
                isSelected: context.watch<GameProvider>().selectedNumber == (index + 1).toString(),
                onPressed: () => context.read<GameProvider>().selectNumber((index + 1).toString()),
              ),
            ),
          )),
          
      ),
    );
  }

  Widget _buildNumberButton(BuildContext context, int number) {
    final gameProvider = Provider.of<GameProvider>(context);
    final isSelected = gameProvider.selectedNumber == number;

    return AnimatedNumberButton(
      number: number,
      isSelected: isSelected,
      onPressed: () => gameProvider.selectNumber(number),
    );
  }
}