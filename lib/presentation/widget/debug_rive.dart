import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class DebugRiveInputs extends StatelessWidget {
  const DebugRiveInputs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RiveAnimation.asset(
          'assets/password_input_card.riv',
          fit: BoxFit.contain,
          // penting: tambahkan onInit
          onInit: (artboard) {
            // loop semua state machine di artboard
            for (final animation in artboard.animations) {
              debugPrint('Animation: ${animation.name}');
            }

            // misalnya coba ambil State Machine 1
            final controller = StateMachineController.fromArtboard(
              artboard,
              'State Machine 1', // coba dulu nama default
            );

            if (controller != null) {
              artboard.addController(controller);
              debugPrint('🎉 Controller berhasil ditambahkan');

              for (final input in controller.inputs) {
                debugPrint(
                  '➡️ Input ditemukan: ${input.name}, type: ${input.runtimeType}',
                );
              }
            } else {
              debugPrint('⚠️ Tidak ada controller dengan nama State Machine 1');
            }
          },
        ),
      ),
    );
  }
}
