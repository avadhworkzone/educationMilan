import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:octo_image/octo_image.dart';
import 'package:sizer/sizer.dart';
import 'package:EduPulse/utils/color_utils.dart';

class LocalAssets extends StatelessWidget {
  const LocalAssets(
      {Key? key,
      required this.imagePath,
      this.height,
      this.width,
      this.imgColor,
      this.scaleSize})
      : super(key: key);
  final String imagePath;
  final double? height, width, scaleSize;
  final Color? imgColor;
  @override
  Widget build(BuildContext context) {
    return imagePath.split('.').last != 'svg'
        ? Image.asset(
            imagePath,
            height: height,
            width: width,
            scale: scaleSize,
            color: imgColor,
          )
        : SvgPicture.asset(
            imagePath,
            height: height,
            width: width,
            color: imgColor,
          );
  }
}

// class NetWorkAssets extends StatelessWidget {
//   const NetWorkAssets(
//       {Key? key,
//         required this.imageUrl,
//         this.height,
//         this.width,
//         this.scaleSize,
//         this.boxFit,
//         this.radius})
//       : super(key: key);
//   final String imageUrl;
//   final double? height, width, scaleSize, radius;
//   final BoxFit? boxFit;
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(radius ?? 100),
//       child: imageUrl.contains('.svg')
//           ? SvgPicture.network(imageUrl)
//           : OctoImage(
//         height: height ?? 10.w,
//         width: width ?? 10.w,
//         image: CachedNetworkImageProvider(imageUrl),
//         placeholderBuilder: OctoPlaceholder.blurHash(
//           'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
//         ),
//         errorBuilder: OctoError.icon(color: ColorUtils.red),
//         fit: boxFit ?? BoxFit.contain,
//       ),
//     );
//   }
// }
