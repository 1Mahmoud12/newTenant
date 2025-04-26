import 'dart:io';
import 'package:dobzz_seller/core/component/phone_number_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/custom_drop_down_menu.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/file.dart';
import 'package:dobzz_seller/feature/account/view/myDetalis/presentation/manager/editProfile/cubit/edit_profile_cubit.dart';

class MyDetailsView extends StatefulWidget {
  const MyDetailsView({super.key});

  @override
  State<MyDetailsView> createState() => _MyDetailsViewState();
}

class _MyDetailsViewState extends State<MyDetailsView> {
  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // State variables
  final ImagePicker _picker = ImagePicker();
  File? _profileImage;
  late final EditProfileCubit _editProfileCubit;

  @override
  void initState() {
    super.initState();
    _editProfileCubit = EditProfileCubit();
    _loadUserData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Methods
  Future<void> _loadUserData() async {
    await _editProfileCubit.getUserData(context: context);
    await _loadProfileImage();
    _populateFormFields();
  }

  Future<void> _loadProfileImage() async {
    final avatarPath = ConstantsModels.editProfileModel?.data?.avatarPath ?? '';
    if (avatarPath.isNotEmpty) {
      _profileImage = await FileDetails.urlToFile(url: avatarPath, nameFile: 'avatar');
      if (mounted) setState(() {});
    }
  }

  void _populateFormFields() {
    if (ConstantsModels.editProfileModel?.data != null) {
      final userData = ConstantsModels.editProfileModel!.data!;
      _firstNameController.text = userData.firstName ?? 'N/A';
      _lastNameController.text = userData.lastName ?? 'N/A';
      _emailController.text = userData.email ?? 'N/A';
      _phoneController.text = userData.phone ?? 'N/A';
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() => _profileImage = File(image.path));
    }
  }

  void _handleSubmit() {
    _editProfileCubit.updateUserData(
      context: context,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      image: _profileImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'My Details'),
      body: BlocProvider.value(
        value: _editProfileCubit,
        child: DetailViewBody(
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          profileImage: _profileImage,
          onPickImage: _pickImage,
          onSubmit: _handleSubmit,
          editProfileCubit: _editProfileCubit,
        ),
      ),
    );
  }
}

class DetailViewBody extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final File? profileImage;
  final VoidCallback onPickImage;
  final VoidCallback onSubmit;
  final EditProfileCubit editProfileCubit;

  const DetailViewBody({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.profileImage,
    required this.onPickImage,
    required this.onSubmit,
    required this.editProfileCubit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: BlocBuilder<EditProfileCubit, EditProfileState>(
        buildWhen: (previous, current) => current is EditProfileLoading || current is EditProfileError || current is EditProfileSuccess,
        builder: (context, state) {
          if (state is EditProfileLoading) {
            return const Center(child: LoadingWidget());
          }
          if (state is EditProfileError) {
            return Center(child: Text(state.e));
          }
          if (state is EditProfileSuccess) {
            return Column(
              children: [
                h20,
                ProfileImageWidget(
                  profileImage: profileImage,
                  onPickImage: onPickImage,
                ),
                h20,
                UserDetailsForm(
                  firstNameController: firstNameController,
                  lastNameController: lastNameController,
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
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class ProfileImageWidget extends StatelessWidget {
  final File? profileImage;
  final VoidCallback onPickImage;

  const ProfileImageWidget({
    super.key,
    required this.profileImage,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPickImage,
        child: Stack(
          children: [
            CacheImage(
              urlImage: profileImage != null ? profileImage!.path : ConstantsModels.editProfileModel?.data?.avatarPath,
              fileImage: profileImage,
              width: 100,
              height: 100,
              circle: true,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDetailsForm extends StatelessWidget {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const UserDetailsForm({
    super.key,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          nameField: 'First Name',
          controller: firstNameController,
          hintText: 'Enter your first name',
        ),
        h10,
        CustomTextFormField(
          nameField: 'Last Name',
          controller: lastNameController,
          hintText: 'Enter your last name',
        ),
        h10,
        CustomTextFormField(
          nameField: 'Email Address',
          controller: emailController,
          hintText: 'Enter your email address',
          textInputType: TextInputType.emailAddress,
        ),
        h10,
        PhoneNumberField(controller: phoneController),
        h10,
      ],
    );
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
                      'Submit',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                    ),
                  ),
          );
        },
      ),
    );
  }
}
