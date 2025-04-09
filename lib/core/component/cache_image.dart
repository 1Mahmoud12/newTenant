import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mamlaka/core/utils/app_icons.dart';
import 'package:mamlaka/core/utils/app_images.dart';

class CacheImage extends StatelessWidget {
  final String? urlImage;
  final bool? profileImage;
  final bool circle;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? errorColor;
  final BoxFit? fit;

  const CacheImage({
    super.key,
    this.urlImage,
    this.profileImage = false,
    this.width,
    this.height,
    this.borderRadius,
    this.errorColor,
    this.circle = false,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipOval(
        clipBehavior: circle ? Clip.hardEdge : Clip.none,
        child: urlImage != null && !urlImage!.contains('.svg')
            ? ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius ?? 8),
                child: CachedNetworkImage(
                  fit: fit ?? BoxFit.cover,
                  imageUrl: urlImage ?? '',
                  width: width,
                  height: height,
                  errorWidget: (context, url, error) => errorColor != null
                      ? Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius ?? 8), color: errorColor),
                        )
                      : profileImage!
                          ? SvgPicture.asset(AppIcons.appLogo)
                          : Image.asset(
                              AppImages.noImage,
                              fit: fit ?? BoxFit.cover,
                            ),
                ),
              )
            : /*SvgPicture.network(
                urlImage ?? '',
                width: width ?? 30,
                height: height ?? 30,
                fit: fit ?? BoxFit.cover,
                placeholderBuilder: (BuildContext context) => SizedBox(
                  width: width ?? 30,
                  height: height ?? 30,
                  child: const Icon(
                    Icons.error,
                    color: Colors.grey,
                  ),
                ),
              ),*/
            SvgPictureNetwork(
                url: urlImage ?? '',
                errorBuilder: (p0) => SizedBox(
                  width: width ?? 30,
                  height: height ?? 30,
                  child: const Icon(
                    Icons.error,
                    color: Colors.grey,
                  ),
                ),
                placeholderBuilder: (p0) => SizedBox(
                  width: width ?? 30,
                  height: height ?? 30,
                  child: const Icon(
                    Icons.error,
                    color: Colors.grey,
                  ),
                ),
              ),
      ),
    );
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
  var _shouldCallErrorBuilder = false;

  @override
  void initState() {
    super.initState();
    _loadSVG();
  }

  Future<void> _loadSVG() async {
    try {
      final svgLoader = SvgNetworkLoader(widget.url);
      final svg = await svgLoader.prepareMessage(context);

      if (!mounted) return;

      setState(() {
        _shouldCallErrorBuilder = svg == null;
        _svgFile = svg;
      });
    } catch (_) {
      setState(() {
        _shouldCallErrorBuilder = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldCallErrorBuilder && widget.errorBuilder != null) {
      return widget.errorBuilder!(context);
    }

    if (_svgFile == null) {
      return widget.placeholderBuilder?.call(context) ?? const SizedBox();
    }

    return SvgPicture.memory(_svgFile!);
  }
}
