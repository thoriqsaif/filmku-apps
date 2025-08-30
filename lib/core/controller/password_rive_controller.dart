class PasswordRiveController {
  void Function(bool)? _toggleEyeCallback;

  void attach(void Function(bool) callback) {
    _toggleEyeCallback = callback;
  }

  void toggleEye(bool isVisible) {
    _toggleEyeCallback?.call(isVisible);
  }
}
