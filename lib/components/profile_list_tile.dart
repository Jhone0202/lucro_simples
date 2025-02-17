import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lucro_simples/themes/app_theme.dart';

class ProfileListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData? icon;
  final String? svgIcon;
  final Color? iconColor;
  final Color? backgroundColor;
  final String title;
  final String subtitle;
  final bool showDivider;

  const ProfileListTile({
    super.key,
    this.onTap,
    this.icon,
    this.svgIcon,
    this.iconColor,
    this.backgroundColor,
    required this.title,
    required this.subtitle,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: backgroundColor ??
                  AppTheme.colors.primary.withValues(alpha: 0.1),
            ),
            child: svgIcon != null
                ? SvgPicture.asset(svgIcon!, width: 24)
                : Icon(
                    icon,
                    color: iconColor ?? AppTheme.colors.primary,
                    size: 24,
                  ),
          ),
          title: Text(
            title,
            style: AppTheme.textStyles.titleSmall,
          ),
          subtitle: Text(
            subtitle,
            style: AppTheme.textStyles.caption.copyWith(color: Colors.black54),
          ),
          trailing: onTap != null
              ? Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppTheme.colors.stroke,
                )
              : null,
        ),
        if (showDivider) const Divider(),
      ],
    );
  }
}
