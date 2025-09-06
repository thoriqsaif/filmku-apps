import 'package:aplikasi_film/core/controller/password_rive_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class PasswordRiveAnimation extends StatefulWidget {
  final TextEditingController controller;
  final PasswordRiveController riveController;

  const PasswordRiveAnimation({
    super.key,
    required this.controller,
    required this.riveController,
  });

  @override
  State<PasswordRiveAnimation> createState() => _PasswordRiveAnimationState();
}

class _PasswordRiveAnimationState extends State<PasswordRiveAnimation> {
  Artboard? _riveArtboard;
  StateMachineController? _controller;
  SMIBool? _eyeClosed; // Boolean 1 di Rive
  SMITrigger? _highlight; // Trigger 1 di Rive (opsional)

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/password_input_card.riv').then((data) async {
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      _controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine 1', // sesuai nama state machine di Rive
      );

      if (_controller != null) {
        artboard.addController(_controller!);
        _eyeClosed = _controller!.findSMI<SMIBool>('Boolean 1');
        _highlight = _controller!.findSMI<SMITrigger>('Trigger 1');
      }

      setState(() => _riveArtboard = artboard);
    });

    widget.controller.addListener(_onTextChange);
  }

  void _onTextChange() {
    // contoh: kalau ada teks, highlight animasi
    if (_highlight != null && widget.controller.text.isNotEmpty) {
      _highlight!.fire();
    }
  }

  /// Fungsi toggle show/hide password
  void toggleEye(bool isVisible) {
    if (_eyeClosed != null) {
      // kalau `isVisible = true`, berarti password kelihatan → mata terbuka
      // jadi eyeClosed harus false
      _eyeClosed!.value = !isVisible;
    }

    // trigger callback opsional
    widget.riveController.toggleEye(isVisible);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _riveArtboard == null
        ? const SizedBox.shrink()
        : Rive(artboard: _riveArtboard!);
  }
}
