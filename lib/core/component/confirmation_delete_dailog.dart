import 'dart:async';

import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfirmationDeleteDialog extends StatefulWidget {
  final String title;
  final String message;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool initialLoadingState;
  final Stream<dynamic>? stateStream;
  final bool Function(dynamic state)? loadingStateCheck;

  const ConfirmationDeleteDialog({
    Key? key,
    this.title = 'Confirm Deletion',
    this.message = 'Are you sure you want to delete this item?',
    this.cancelText = 'Cancel',
    this.confirmText = 'Delete',
    required this.onConfirm,
    this.onCancel,
    this.initialLoadingState = false,
    this.stateStream,
    this.loadingStateCheck,
  }) : super(key: key);

  /// Static method to easily show the dialog
  static Future<bool?> show({
    required BuildContext context,
    String title = 'Confirm Deletion',
    String message = 'Are you sure you want to delete this item?',
    String cancelText = 'Cancel',
    String confirmText = 'Delete',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isLoading = false,
    Stream<dynamic>? stateStream,
    bool Function(dynamic state)? loadingStateCheck,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: !isLoading,
      builder: (BuildContext context) => ConfirmationDeleteDialog(
        title: title.tr(),
        message: message.tr(),
        cancelText: cancelText.tr(),
        confirmText: confirmText.tr(),
        onConfirm: onConfirm,
        onCancel: onCancel ?? () => Navigator.of(context).pop(false),
        initialLoadingState: isLoading,
        stateStream: stateStream,
        loadingStateCheck: loadingStateCheck,
      ),
    );
  }

  @override
  State<ConfirmationDeleteDialog> createState() => _ConfirmationDeleteDialogState();
}

class _ConfirmationDeleteDialogState extends State<ConfirmationDeleteDialog> {
  late bool isLoading;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    isLoading = widget.initialLoadingState;

    // Listen to the state stream if provided
    if (widget.stateStream != null && widget.loadingStateCheck != null) {
      _subscription = widget.stateStream!.listen((state) {
        final newLoadingState = widget.loadingStateCheck!(state);
        if (newLoadingState != isLoading) {
          setState(() {
            isLoading = newLoadingState;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back button dismissal during loading
      onWillPop: () async => !isLoading,
      child: AlertDialog(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Text(
          widget.message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          // Cancel button (disabled during loading)
          TextButton(
            onPressed: isLoading ? null : (widget.onCancel ?? () => Navigator.of(context).pop(false)),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
            child: Text(widget.cancelText),
          ),
          // Confirm/Delete button with loading indicator
          ElevatedButton(
            onPressed: isLoading ? null : widget.onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
            ),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(widget.confirmText),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
