import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/phone_number_field.dart';
import 'package:dobzz_seller/core/network/local/cache.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/navigate.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/account/view/myDetalis/presentation/manager/editProfile/cubit/edit_profile_cubit.dart';
import 'package:dobzz_seller/feature/navigation/view/presentation/navigation_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDetailsView extends StatefulWidget {
  const MyDetailsView({super.key, required this.editProfileCubit});

  final EditProfileCubit editProfileCubit;

  @override
  State<MyDetailsView> createState() => _MyDetailsViewState();
}

class _MyDetailsViewState extends State<MyDetailsView> {
  // Controllers
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateFormFields();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Methods
  void _populateFormFields() {
    if (loginCacheValue?.data != null) {
      final userData = loginCacheValue!.data!;
      _firstNameController.text = userData.name;
      _emailController.text = userData.email;
      _phoneController.text = userData.mobile;
    }
  }

  void _handleSubmit() async {
    if (loginCacheValue?.data?.email != Constants.demoAccount) {
      await widget.editProfileCubit.updateUserData(
        context: context,
        name: _firstNameController.text,
        phone: _phoneController.text,
      );
      context.navigateToPage(
        const NavigationViewWithThemes(
          initialIndex: 3,
        ),
      );
    } else {
      Utils.showToast(title: 'This is demo account you can not change user data', state: UtilState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'My Details'.tr()),
      body: BlocProvider.value(
        value: widget.editProfileCubit,
        child: DetailViewBody(
          firstNameController: _firstNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          onSubmit: _handleSubmit,
          editProfileCubit: widget.editProfileCubit,
        ),
      ),
    );
  }
}

class DetailViewBody extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final VoidCallback onSubmit;
  final EditProfileCubit editProfileCubit;

  const DetailViewBody({
    super.key,
    required this.firstNameController,
    required this.emailController,
    required this.phoneController,
    required this.onSubmit,
    required this.editProfileCubit,
  });

  @override
  Widget build(BuildContext context) {
    // Check if we have cached user data
    if (loginCacheValue?.data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No user data available'.tr(),
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          h20,
          // Vector Avatar
          const VectorAvatarWidget(),
          h20,
          UserDetailsForm(
            firstNameController: firstNameController,
            emailController: emailController,
            phoneController: phoneController,
          ),
          h30,
          SubmitButtonWidget(
            onSubmit: onSubmit,
            editProfileCubit: editProfileCubit,
          ),
          h20,
        ],
      ),
    );
  }
}

class VectorAvatarWidget extends StatelessWidget {
  const VectorAvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = loginCacheValue?.data?.name ?? '';
    final initials = _getInitials(userName);

    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        child: Center(
          child: initials.isNotEmpty
              ? Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.primaryColor,
                ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }
}

class UserDetailsForm extends StatefulWidget {
  final TextEditingController firstNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const UserDetailsForm({
    super.key,
    required this.firstNameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  State<UserDetailsForm> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  @override
  void initState() {
    getCountryCode(number: loginCacheValue?.data?.mobile ?? '+966');
    super.initState();
  }

  String initialCountryCode = '+966';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          nameField: 'Name'.tr(),
          controller: widget.firstNameController,
          hintText: 'Enter your first name'.tr(),
        ),
        h10,
        CustomTextFormField(
          nameField: 'Email Address'.tr(),
          controller: widget.emailController,
          hintText: 'Email address'.tr(),
          textInputType: TextInputType.emailAddress,
          enable: false, // Disabled as per user requirement
        ),
        h10,
        PhoneNumberField(
          initialCountryCode: initialCountryCode,
          controller: formatPhone(
            number: loginCacheValue?.data?.mobile ?? '',
            initialCountryCode: initialCountryCode,
          ),
        ),
        h10,
      ],
    );
  }

  void getCountryCode({required String number}) {
    if (number.isEmpty) return;
    if (number.substring(0, 3) == '+20') {
      initialCountryCode = '+2';
    } else if (number.length >= 3) {
      initialCountryCode = number.substring(0, 3);
    }
  }

  TextEditingController formatPhone({
    required String number,
    required String initialCountryCode,
  }) {
    final TextEditingController phone = TextEditingController(text: '');

    if (number.isEmpty) return phone;

    if (initialCountryCode == '+2') {
      if (number.length >= 2) {
        phone.text = number.substring(2);
      }
    } else {
      if (number.length >= 3) {
        phone.text = number.substring(3);
      }
    }

    return phone;
  }
}

class SubmitButtonWidget extends StatelessWidget {
  final VoidCallback onSubmit;
  final EditProfileCubit editProfileCubit;

  const SubmitButtonWidget({
    super.key,
    required this.onSubmit,
    required this.editProfileCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
          return CustomTextButton(
            borderRadius: 10,
            onPress: onSubmit,
            child: state is UpdateProfileLoading
                ? const SizedBox(
                    width: 27,
                    height: 27,
                    child: Center(
                      child: FittedBox(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text(
                      'Submit'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
