import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucro_simples/utils/feedback_user.dart';

class SecondaryButton extends StatefulWidget {
  final String title;
  final Function? onPressed;
  final bool expanded;
  final EdgeInsets? margin;
  final IconData? iconData;
  final String loadingTitle;
  final String? successMsg;
  final GlobalKey<FormState>? formKey;
  final bool small;
  final Color? contentColor;

  const SecondaryButton({
    super.key,
    required this.title,
    this.onPressed,
    this.expanded = true,
    this.margin,
    this.iconData,
    this.loadingTitle = 'Carregando...',
    this.successMsg,
    this.formKey,
    this.small = false,
    this.contentColor,
  });

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isLoading = false;

  Future<void> _handleOnPressed() async {
    try {
      _isLoading = true;
      setState(() {});

      if (_validateAndSave()) {
        if (widget.onPressed is Future Function()) {
          await widget.onPressed!();
        } else if (widget.onPressed != null) {
          widget.onPressed!();
        }

        if (widget.successMsg?.isNotEmpty == true) {
          FeedbackUser.toast(msg: widget.successMsg!);
        }
      }
    } catch (e) {
      if (kDebugMode) print(e);
      if (mounted) FeedbackUser.toast(msg: e.toString());
    } finally {
      _isLoading = false;
      setState(() {});
    }
  }

  bool _validateAndSave() {
    final form = widget.formKey?.currentState;

    if (form == null) return true;

    if (form.validate()) {
      form.save();
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.expanded ? double.maxFinite : null,
      margin: widget.margin,
      child: OutlinedButton(
        onPressed:
            _isLoading || widget.onPressed == null ? null : _handleOnPressed,
        style: OutlinedButton.styleFrom(
          visualDensity: widget.small ? VisualDensity.compact : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          disabledBackgroundColor: Colors.grey.shade400,
          disabledForegroundColor: Colors.grey.shade100,
          padding: widget.small
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
              : const EdgeInsets.all(12),
          foregroundColor: widget.contentColor,
          iconColor: widget.contentColor,
          side: BorderSide(
            color: widget.contentColor ?? Theme.of(context).primaryColor,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isLoading) ...[
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: Colors.grey.shade100,
                ),
              ),
              const SizedBox(width: 8),
              Text(widget.loadingTitle),
            ] else ...[
              if (widget.iconData != null) ...[
                Icon(widget.iconData, size: widget.small ? 14 : 20),
                SizedBox(width: widget.small ? 4 : 8),
              ],
              Flexible(
                child: Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: widget.small ? 12 : null),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
