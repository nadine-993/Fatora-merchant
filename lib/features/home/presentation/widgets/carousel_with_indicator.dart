import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fatora/core/utils/launchers.dart';
import 'package:fatora/features/advertisment/data/advertisement_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/api/http/api_urls.dart';
import '../../../../core/constants/app_colors.dart';



class CarouselWithIndicator extends StatefulWidget {
  final List<Advertisement?>? imgList;

  const CarouselWithIndicator({Key? key, this.imgList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final CarouselController _controller = CarouselController();


  @override
  Widget build(BuildContext context) {
    if (widget.imgList!.isEmpty) return const SizedBox.shrink();
    List imageSliders = widget.imgList!
        .map((item) => InkWell(
      onTap: () {
        Launchers.launchWebUrl(item?.link ?? 'fatora.com');
      },
          child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: MediaQuery.of(context).size.width,
      decoration:   BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)), color: AppColors.white,
          image: DecorationImage(image:
          CachedNetworkImageProvider(
               '${ApiURLs.getAdImage}${item?.image!}'
          ),
              fit: BoxFit.fill)
      ),

    ),
        ))
        .toList();

    return Column(children: [
      CarouselSlider(
        items: imageSliders as List<Widget>?,
        carouselController: _controller,
        options: CarouselOptions(
            viewportFraction: 0.95,
            enlargeCenterPage:true ,
            enlargeStrategy:CenterPageEnlargeStrategy.height,
            autoPlay: true,
            height: 130.0.h,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
    ]);
  }
}
