import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/custom_drop_down_menu.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_images.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:flutter/material.dart';

class AddAddressView extends StatelessWidget {
  const AddAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'New Address'),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset(AppImages.actionBlocked, fit: BoxFit.cover)),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AddAddressBottomSheet(),
          ),
        ],
      ),
    );
  }
}

class AddAddressBottomSheet extends StatefulWidget {
  const AddAddressBottomSheet({Key? key}) : super(key: key);

  @override
  State<AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  List<DropDownModel> addressList = [
    DropDownModel(name: 'Asyut', value: 0),
    DropDownModel(name: 'California', value: 1),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(20)),
              height: 7,
              width: 90,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Address',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                splashRadius: 24,
              ),
            ],
          ),
          Divider(
            thickness: 0.9,
            color: Colors.grey.withOpacity(0.2),
          ),
          h10,
          CustomDropDownMenu(
            nameField: 'Address Nickname',
            borderColor: Colors.grey.withOpacity(0.2),
            selectedItem: DropDownModel(name: 'Choose your address', value: 0),
            items: addressList,
          ),
          h10,
          CustomTextFormField(
            outPadding: EdgeInsets.zero,
            controller: TextEditingController(),
            hintText: 'Enter your full address',
            nameField: 'Full Address',
          ),
          h10,
          LabeledCheckButton(
            onChanged: (value) {
              // Handle the checkbox state change
              print('Checkbox is now: $value');
            },
          ),
          h20,
          CustomTextButton(
            onPress: () {},
            childText: 'Add',
            borderRadius: 8,
          ),
        ],
      ),
    );
  }
}

class TrackOrderItem extends StatelessWidget {
  final String status;
  final String address;
  final bool isCompleted;
  final bool showConnector;

  const TrackOrderItem({
    Key? key,
    required this.status,
    required this.address,
    required this.isCompleted,
    required this.showConnector,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status indicator column (dot and connector line)
        SizedBox(
          width: 24,
          child: Column(
            children: [
              // Status dot indicator
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? Colors.black : Colors.white,
                  border: Border.all(
                    color: isCompleted ? Colors.black : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
              ),

              // Connector line
              if (showConnector)
                Container(
                  width: 2,
                  height: 65,
                  color: Colors.grey.shade300,
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Status text info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                status,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isCompleted ? Colors.black : Colors.grey,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                address,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class LabeledCheckButton extends StatefulWidget {
  final String label;
  final bool initialValue;
  final ValueChanged<bool>? onChanged;

  const LabeledCheckButton({
    Key? key,
    this.label = 'Make this as a default address',
    this.initialValue = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<LabeledCheckButton> createState() => _LabeledCheckButtonState();
}

class _LabeledCheckButtonState extends State<LabeledCheckButton> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Custom checkbox
        GestureDetector(
          onTap: () {
            setState(() {
              _isChecked = !_isChecked;
              if (widget.onChanged != null) {
                widget.onChanged!(_isChecked);
              }
            });
          },
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isChecked ? AppColors.primaryColor : Colors.grey.shade300,
              ),
              color: _isChecked ? AppColors.primaryColor : Colors.white,
            ),
            child: _isChecked
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 8),
        // Label
        Text(
          widget.label,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

// Example usage:
// LabeledCheckButton(
//   label: "Make this as a default address",
//   initialValue: false,
//   onChanged: (value) {
//     print("Checkbox is now: $value");
//   },
// )