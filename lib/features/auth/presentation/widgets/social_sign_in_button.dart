import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum SocialProvider {
  google,
  facebook,
  apple,
}

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    required this.provider,
    required this.onPressed,
    super.key,
    this.isLoading = false,
  });

  final SocialProvider provider;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // Get the icon data that corresponds to each provider
    IconData? iconData;
    Widget? customIcon;

    switch (provider) {
      case SocialProvider.google:
        customIcon = CircleAvatar(
          radius: 12,
          backgroundColor: Colors.white,
          child: SvgPicture.asset(
            'assets/icons/google_logo.svg',
            width: 18,
            height: 18,
            placeholderBuilder: (BuildContext context) => const Icon(
              Icons.g_mobiledata,
              size: 24,
            ),
          ),
        );
      case SocialProvider.facebook:
        iconData = Icons.facebook;
      case SocialProvider.apple:
        iconData = Icons.apple;
    }

    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else if (customIcon != null)
            customIcon
          else if (iconData != null)
            Icon(iconData),
          const SizedBox(width: 8),
          Text(_getProviderText()),
        ],
      ),
    );
  }

  String _getProviderText() {
    switch (provider) {
      case SocialProvider.google:
        return 'Continuar con Google';
      case SocialProvider.facebook:
        return 'Continuar con Facebook';
      case SocialProvider.apple:
        return 'Continuar con Apple';
    }
  }
}
