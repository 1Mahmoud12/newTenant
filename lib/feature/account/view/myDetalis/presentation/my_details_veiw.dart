import 'dart:io';
import 'package:dobzz_seller/core/component/cache_image.dart';
import 'package:dobzz_seller/core/component/loadsErros/loading_widget.dart';
import 'package:dobzz_seller/core/utils/constants_models.dart';
import 'package:dobzz_seller/core/utils/file.dart';
import 'package:dobzz_seller/core/utils/utils.dart';
import 'package:dobzz_seller/feature/account/view/myDetalis/presentation/manager/editProfile/cubit/edit_profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dobzz_seller/core/component/buttons/custom_text_button.dart';
import 'package:dobzz_seller/core/component/custom_app_bar.dart';
import 'package:dobzz_seller/core/component/custom_drop_down_menu.dart';
import 'package:dobzz_seller/core/component/fields/custom_text_form_field.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/constant_gaping.dart';
import 'package:dobzz_seller/core/utils/constants.dart';

class MyDetailsView extends StatefulWidget {
  const MyDetailsView({super.key});

  @override
  State<MyDetailsView> createState() => _MyDetailsViewState();
}

class _MyDetailsViewState extends State<MyDetailsView> {
  @override
  void initState() {
    editProfileCubit.getUserData(context: context);
    getImage();
    super.initState();
  }

  EditProfileCubit editProfileCubit = EditProfileCubit();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _profileImage;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  void getImage() async {
    _profileImage = await FileDetails.urlToFile(url: ConstantsModels.editProfileModel?.data?.avatarPath ?? '', nameFile: 'avatar');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, title: 'My Details'),
      body: SingleChildScrollView(
        child: BlocProvider.value(
          value: editProfileCubit,
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
                _firstNameController.text = ConstantsModels.editProfileModel?.data?.firstName ?? 'N/A';
                _lastNameController.text = ConstantsModels.editProfileModel?.data?.lastName ?? 'N/A';
                _emailController.text = ConstantsModels.editProfileModel?.data?.email ?? 'N/A';
                _phoneController.text = ConstantsModels.editProfileModel?.data?.phone ?? 'N/A';

                return Column(
                  children: [
                    h20,
                    _buildProfileImage(),
                    h20,
                    _buildTextFields(),
                    h30,
                    _buildSubmitButton(),
                    h20,
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            CacheImage(
              urlImage: _profileImage != null ? _profileImage!.path : ConstantsModels.editProfileModel?.data?.avatarPath,
              fileImage: _profileImage,
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

  Widget _buildTextFields() {
    return Column(
      children: [
        CustomTextFormField(
          nameField: 'First Name',
          controller: _firstNameController,
          hintText: 'Enter your first name',
        ),
        h10,
        CustomTextFormField(
          nameField: 'Last Name',
          controller: _lastNameController,
          hintText: 'Enter your last name',
        ),
        h10,
        CustomTextFormField(
          nameField: 'Email Address',
          controller: _emailController,
          hintText: 'Enter your email address',
          textInputType: TextInputType.emailAddress,
        ),
        h10,
        CustomTextFormField(
          textInputType: TextInputType.phone,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 7),
          outPadding: const EdgeInsets.symmetric(horizontal: 20),
          controller: _phoneController,
          hintText: 'Enter your phone number',
          nameField: 'Phone Number',
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SizedBox(
              width: 70,
              child: Row(
                children: [
                  Expanded(child: _buildCountryDropDown()),
                  const SizedBox(width: 4),
                  Container(
                    height: 40,
                    width: 1,
                    color: AppColors.grey.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ),
        ),
        h10,
        // CustomTextFormField(
        //   nameField: 'Edit password',
        //   controller: TextEditingController(),
        //   enable: false,
        //   hintText: '*********',
        //   suffixIcon: const Icon(Icons.edit, color: AppColors.primaryColor),
        // ),
        h10,
      ],
    );
  }

  Widget _buildCountryDropDown() {
    return CustomDropDownMenu(
      fillColor: AppColors.transparent,
      borderColor: AppColors.transparent,
      selectedItem: DropDownModel(
        name: countriesflage.first.name,
        value: countriesflage.first.id,
        showName: false,
        showImage: true,
        image: countriesflage.first.image,
      ),
      items: countriesflage
          .map(
            (e) => DropDownModel(
              name: e.name,
              value: e.id,
              showName: false,
              showImage: true,
              image: e.image,
            ),
          )
          .toList(),
    );
  }

  Widget _buildSubmitButton() {
    return BlocProvider.value(
      value: editProfileCubit,
      child: BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextButton(
              borderRadius: 10,
              onPress: () {
                editProfileCubit.updateUserData(
                  context: context,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                  image: _profileImage, 
                );
              },
              child: state is UpdateProfileLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        'Submit',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}
