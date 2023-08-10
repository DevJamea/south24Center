import 'dart:ui' as UI;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html_unescape/html_unescape_small.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/news_details/social_media_widget.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class TranslatedNewsDetailsView extends StatefulWidget {
  final String? newsId;

  const TranslatedNewsDetailsView({Key? key, required this.newsId})
      : super(key: key);

  @override
  State<TranslatedNewsDetailsView> createState() =>
      _TranslatedNewsDetailsViewState();
}

class _TranslatedNewsDetailsViewState extends State<TranslatedNewsDetailsView> {
  late final Controller provider;

  @override
  initState() {
    super.initState();
    provider = context.read<Controller>();
    provider.getTranslartedNewsById(widget.newsId!);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      if (!provider.isConnected) {
        return NoConnectionState(StateRendererType.fullScreenNoConnectionState,
                AppStrings.noInternetConnection.tr())
            .getScreenWidget(context);
      }

      if (provider.translatedNews == null) {
        return LoadingState(
                stateRendererType: StateRendererType.fullScreenLoadingState)
            .getScreenWidget(context);
      }

      if (provider.translatedNews!.newsId == "0") {
        return ErrorState(
            stateRendererType: StateRendererType.fullScreenErorr,
            retryActionFunction: () {
              provider.translatedNews = null;
              provider.notifyListeners();
              provider.getTranslartedNewsById(widget.newsId!);
            }).getScreenWidget(context);
      }

      return Directionality(
        textDirection:
            provider.EnTopicId.contains(provider.translatedNews!.newsTopicid)
                ? UI.TextDirection.ltr
                : UI.TextDirection.rtl,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CachedNetworkImage(
                height: size.height > size.width
                    ? size.height * AppSize.s_3
                    : size.width * AppSize.s_5,
                width: double.infinity,
                fit: BoxFit.cover,
                imageUrl: provider.translatedNews!.newsPic!.trim(),
                placeholder: (context, url) =>
                    SvgPicture.asset(ImageAssets.imagePhaceholder),
                errorWidget: (context, url, error) =>
                    const Center(child: Icon(Icons.error)),
              ),
              Padding(
                padding: const EdgeInsets.all(AppPadding.p12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.translatedNews!.newsSubject!.trim(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.watch_later_outlined,
                          color: ColorManager.lightPrimary,
                          size: AppSize.s14,
                        ),
                        SizedBox(
                          width: AppSize.s4,
                        ),
                        Text(
                          provider.EnTopicId.contains(
                                  provider.translatedNews!.newsTopicid)
                              ? provider.formatDate(
                                  provider.translatedNews!.newsDatetime!,
                                  AppStrings.englishLanguage)
                              : provider.formatDate(
                                  provider.translatedNews!.newsDatetime!,
                                  AppStrings.arabicLanguage),
                          style: getMediumStyle(color: ColorManager.lightBlack),
                        ),
                      ],
                    ),
                    SocialMediaIcons(
                        newsId: provider.translatedNews!.newsId,
                        text: null,
                        transletedNewsId: null),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppPadding.p8,
                      ),
                      child: Html(
                        data: HtmlUnescape().convert(provider.translatedNews!.newsBudy!.trim()),
                        onLinkTap:(url, context, attributes, element) =>
                            launchUrl(Uri.parse(url!),
                                mode: LaunchMode.externalApplication),
                        style: {
                          'html': Style(
                              color: ColorManager.black,
                              fontSize: FontSize(FontSizeManager.s14),
                              fontFamily: FontConstants.fontFamily,
                              textAlign: TextAlign.justify),
                        },
                      ),
                    ),
                    Html(
                      data: provider.translatedNews!.newsAuth!.trim(),
                      onLinkTap:(url, context, attributes, element) =>
                          launchUrl(Uri.parse(url!),
                              mode: LaunchMode.externalApplication),
                      style: {
                        'html': Style(
                            color: ColorManager.black,
                            fontSize: FontSize(FontSizeManager.s12),
                            fontFamily: FontConstants.fontFamily,
                            textAlign: TextAlign.justify),
                      },
                    ),
                    SizedBox(
                      height: AppSize.s12,
                    ),
                    Html(
                      data: provider.translatedNews!.newsRef!.trim(),
                      onLinkTap:(url, context, attributes, element) =>
                          launchUrl(Uri.parse(url!),
                              mode: LaunchMode.externalApplication),
                      style: {
                        'html': Style(
                            color: ColorManager.black,
                            fontSize: FontSize(FontSizeManager.s12),
                            fontFamily: FontConstants.fontFamily,
                            textAlign: TextAlign.justify),
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
