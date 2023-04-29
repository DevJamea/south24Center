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
import 'package:south24/presentation/resources/routs_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowPublicationsDetails extends StatefulWidget {
  const ShowPublicationsDetails({super.key, required this.arabicVersions});

  final ArabicVersions arabicVersions;

  @override
  State<ShowPublicationsDetails> createState() =>
      _ShowPublicationsDetailsState();
}

class _ShowPublicationsDetailsState extends State<ShowPublicationsDetails> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
            primary: true,
            title: Image(
              image: const AssetImage(ImageAssets.splashLogo),
              height: AppBar().preferredSize.height - AppSize.s18,
            )),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
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
                ),
                Padding(
                  padding: const EdgeInsets.all(
                    AppPadding.p12,
                  ),
                  child: Text(
                    widget.arabicVersions.docSubject!.trim(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p12),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppStrings.author.tr(),
                          style: getSemiBoldStyle(
                            color: Colors.black,
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
                ),
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p12),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppStrings.publishDate.tr(),
                          style: getSemiBoldStyle(
                            color: Colors.black,
                            fontSize: FontSizeManager.s16,
                          ),
                        ),
                        TextSpan(
                          text: " " +
                              widget.arabicVersions.docDatetime!.split(' ')[0],
                          style: getMediumStyle(
                            color: ColorManager.darkGrey,
                            fontSize: FontSizeManager.s16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        launchUrl(Uri.parse(widget.arabicVersions.docPdf!),
                            mode: LaunchMode.externalApplication);
                      },
                      child: Text(AppStrings.View.tr()),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var storagePermissionStatus =
                            await Permission.storage.status;
                        if (storagePermissionStatus.isGranted) {
                          provider
                              .downloadPdfFile(widget.arabicVersions.docPdf!);
                        } else {
                          var result = await Permission.storage.request();
                          if (result.isGranted) {
                            provider
                                .downloadPdfFile(widget.arabicVersions.docPdf!);
                          } else {
                            // Permission has been denied
                            // Show an error message or handle the situation accordingly
                          }
                        }
                      },
                      child: Text(AppStrings.Download.tr()),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
