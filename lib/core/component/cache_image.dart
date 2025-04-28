import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dobzz_seller/core/themes/colors.dart';
import 'package:dobzz_seller/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CacheImage extends StatelessWidget {
  final String? urlImage;
  final String? assetImage;
  final bool? profileImage;
  final bool circle;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? errorColor;
  final BoxFit? fit;
  final File? fileImage;

  const CacheImage({
    super.key,
    this.urlImage,
    this.assetImage,
    this.profileImage = false,
    this.width,
    this.height,
    this.borderRadius,
    this.errorColor,
    this.circle = false,
    this.fit,
    this.fileImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipOval(
        clipBehavior: circle ? Clip.hardEdge : Clip.none,
        child: _buildImageWidget(context),
      ),
    );
  }

  Widget _buildImageWidget(BuildContext context) {
    // Priority order: fileImage -> assetImage -> urlImage
    if (fileImage != null) {
      return _buildFileImage();
    } else if (assetImage != null) {
      return _buildAssetImage();
    } else if (urlImage != null) {
      return urlImage!.contains('.svg') ? _buildSvgNetworkImage() : _buildNetworkImage(context);
    } else {
      // Fallback for no image source provided
      return _buildErrorImage();
    }
  }

  Widget _buildFileImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      child: Image.file(
        fileImage!,
        fit: fit ?? BoxFit.cover,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
        // loadingBuilder: (context, child, loadingProgress) {
        //   if (loadingProgress == null) return child;
        //   return _buildLoadingIndicator();
        // },
      ),
    );
  }

  Widget _buildAssetImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      child: assetImage!.endsWith('.svg')
          ? SvgPicture.asset(
              assetImage!,
              width: width,
              height: height,
              fit: fit ?? BoxFit.cover,
              placeholderBuilder: (context) => _buildLoadingIndicator(),
            )
          : Image.asset(
              assetImage!,
              width: width,
              height: height,
              fit: fit ?? BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => _buildErrorImage(),
              // loadingBuilder: (context, child, loadingProgress) {
              //   if (loadingProgress == null) return child;
              //   return _buildLoadingIndicator();
              // },
            ),
    );
  }

  Widget _buildNetworkImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 8),
      child: CachedNetworkImage(
        fit: fit ?? BoxFit.cover,
        imageUrl: urlImage ?? '',
        width: width,
        height: height,
        errorWidget: (context, url, error) => _buildErrorImage(),
        placeholder: (context, url) => _buildLoadingIndicator(),
      ),
    );
  }

  Widget _buildSvgNetworkImage() {
    return SvgPictureNetwork(
      url: urlImage ?? '',
      placeholderBuilder: (context) => _buildLoadingIndicator(),
      errorBuilder: (context) => SizedBox(
        width: width ?? 30,
        height: height ?? 30,
        child: _buildErrorImage(),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        color: Colors.grey[200],
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorImage() {
    // When errorColor is provided, use it for the background
    if (errorColor != null) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          color: errorColor,
        ),
      );
    }
    // For profile images
    else if (profileImage == true) {
      return Image.asset(AppImages.appLogo);
    }
    // Default fallback
    else {
      return Image.asset(
        AppImages.noImage,
        fit: fit ?? BoxFit.cover,
      );
    }
  }
}

class SvgPictureNetwork extends StatefulWidget {
  const SvgPictureNetwork({
    super.key,
    required this.url,
    this.placeholderBuilder,
    this.errorBuilder,
  });

  final String url;
  final Widget Function(BuildContext)? placeholderBuilder;
  final Widget Function(BuildContext)? errorBuilder;

  @override
  State<SvgPictureNetwork> createState() => _SvgPictureNetworkState();
}

class _SvgPictureNetworkState extends State<SvgPictureNetwork> {
  Uint8List? _svgFile;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadSVG();
  }

  Future<void> _loadSVG() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final svgLoader = SvgNetworkLoader(widget.url);
      final svg = await svgLoader.prepareMessage(context);

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = svg == null;
        _svgFile = svg;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.placeholderBuilder != null) {
      return widget.placeholderBuilder!(context);
    }

    if (_hasError && widget.errorBuilder != null) {
      return widget.errorBuilder!(context);
    }

    if (_svgFile == null) {
      return widget.placeholderBuilder?.call(context) ?? const SizedBox();
    }

    return SvgPicture.memory(_svgFile!);
  }
}
