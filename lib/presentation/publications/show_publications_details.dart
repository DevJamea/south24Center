import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/domain/modela/arabic_versions.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowPublicationsDetails extends StatefulWidget {
  const ShowPublicationsDetails({
    Key? key,
    required this.arabicVersions,
  }) : super(key: key);

  final ArabicVersions arabicVersions;

  @override
  State<ShowPublicationsDetails> createState() =>
      _ShowPublicationsDetailsState();
}

class _ShowPublicationsDetailsState extends State<ShowPublicationsDetails> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<Controller>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            primary: true,
            title: Image(
              image: const AssetImage(ImageAssets.splashLogo),
              height: AppBar().preferredSize.height - AppSize.s18,
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPublicationImage(size),
                  _buildPublicationTitle(),
                  _buildPublicationAuthor(),
                  _buildPublicationDate(),
                  _buildPublicationButtons(provider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPublicationImage(Size size) {
    return CachedNetworkImage(
      height: size.height > size.width
          ? size.height * AppSize.s_5
          : size.width * AppSize.s_5,
      width: double.infinity,
      fit: BoxFit.fitHeight,
      imageUrl: widget.arabicVersions.docPic!,
      placeholder: (context, url) =>
          SvgPicture.asset(ImageAssets.imagePhaceholder),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
    );
  }

  Widget _buildPublicationTitle() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: Text(
        widget.arabicVersions.docSubject!.trim(),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Widget _buildPublicationAuthor() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppStrings.author.tr(),
              style: getSemiBoldStyle(
                color: ColorManager.black,
                fontSize: FontSizeManager.s16,
              ),
            ),
            TextSpan(
              text: " " + widget.arabicVersions.docAuth!,
              style: getMediumStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSizeManager.s16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicationDate() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p12),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: AppStrings.publishDate.tr(),
              style: getSemiBoldStyle(
                color: ColorManager.black,
                fontSize: FontSizeManager.s16,
              ),
            ),
            TextSpan(
              text: " " + widget.arabicVersions.docDatetime!.split(' ')[0],
              style: getMediumStyle(
                color: ColorManager.darkGrey,
                fontSize: FontSizeManager.s16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicationButtons(Controller provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16, vertical: AppPadding.p8),
      child: ElevatedButton(
        onPressed: () async {
          launchUrl(Uri.parse(widget.arabicVersions.docPdf!),
              mode: LaunchMode.externalApplication);
        },
        child: Text(AppStrings.View.tr()),
      ),
    );
  }
}
