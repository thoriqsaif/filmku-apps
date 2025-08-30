import 'package:aplikasi_film/core/controller/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BounceSplashScreen extends StatefulWidget {
  const BounceSplashScreen({super.key});

  @override
  State<BounceSplashScreen> createState() => _BounceSplashScreenState();
}

class _BounceSplashScreenState extends State<BounceSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _scaleXAnimation;
  late Animation<double> _scaleYAnimation;
  late Animation<double> _positionAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    // Curved controller sekali saja
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // bisa diganti elastic/bounce untuk keseluruhan
    );

    // Stretch (X)
    _scaleXAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 0.8), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.8, end: 1.0), weight: 30),
    ]).animate(curved);

    // Squash (Y)
    _scaleYAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.7), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.3), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 30),
    ]).animate(curved);

    // Position Bounce
    _positionAnimation = Tween<double>(
      begin: 0.0,
      end: -80.0, // geser ke atas
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    // Color Change
    _colorAnimation = ColorTween(
      begin: Colors.purple,
      end: Colors.orange,
    ).animate(curved);

    _controller.repeat(reverse: true);

    _controller.forward().whenComplete(() {
      if (mounted) {
        Get.offAll(() => const AuthWrapper());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _positionAnimation.value),
              child: Transform(
                transform: Matrix4.diagonal3Values(
                  _scaleXAnimation.value,
                  _scaleYAnimation.value,
                  1.0,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.music_note,
                  size: 120,
                  color: _colorAnimation.value,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
