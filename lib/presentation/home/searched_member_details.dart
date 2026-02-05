import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/font_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchedMemberDetails extends StatefulWidget {
  const SearchedMemberDetails({Key? key, required this.memberId})
      : super(key: key);

  final String memberId;

  @override
  State<SearchedMemberDetails> createState() => _SearchedMemberDetailsState();
}

class _SearchedMemberDetailsState extends State<SearchedMemberDetails> {
  late final Controller provider;
  @override
  void initState() {
    super.initState();
    provider = context.read<Controller>();
    provider.getNewsById(widget.memberId);
  }

  Style _getHTMLStyle() {
    return Style(
        fontSize: FontSize(FontSizeManager.s14),
        fontWeight: FontWeightManager.semiBold,
        fontFamily: FontConstants.fontFamily,
        color: ColorManager.darkPrimary,
        textAlign: TextAlign.justify);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Controller>(context);

    if (!provider.isConnected) {
      return Scaffold(
        appBar: AppBar(
            primary: true,
            title: Image(
              image: const AssetImage(ImageAssets.splashLogo),
              height: AppBar().preferredSize.height - AppSize.s18,
            )),
        body: NoConnectionState(StateRendererType.fullScreenNoConnectionState,
                AppStrings.noInternetConnection.tr())
            .getScreenWidget(context),
      );
    }

    if (provider.searchedNews == null) {
      return Scaffold(
        appBar: AppBar(
            primary: true,
            title: Image(
              image: const AssetImage(ImageAssets.splashLogo),
              height: AppBar().preferredSize.height - AppSize.s18,
            )),
        body: LoadingState(
                stateRendererType: StateRendererType.fullScreenLoadingState)
            .getScreenWidget(context),
      );
    }

    if (provider.searchedNews!.newsId == "0") {
      return Scaffold(
        appBar: AppBar(
            primary: true,
            title: Image(
              image: const AssetImage(ImageAssets.splashLogo),
              height: AppBar().preferredSize.height - AppSize.s18,
            )),
        body: ErrorState(
            stateRendererType: StateRendererType.fullScreenErorr,
            retryActionFunction: () {
              provider.searchedNews = null;
              provider.notifyListeners();
              provider.getNewsById(widget.memberId);
            }).getScreenWidget(context),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          ImageAssets.splashLogo,
          height: AppBar().preferredSize.height - AppSize.s18,
        ),
      ),
      body: Stack(
        children: [
          CachedNetworkImage(
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
            imageUrl: provider.searchedNews!.newsPic!,
            placeholder: (context, url) =>
                SvgPicture.asset(ImageAssets.imagePhaceholder),
            errorWidget: (context, url, error) =>
                const Center(child: Icon(Icons.error)),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            color: ColorManager.white70,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSize.s28),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.s64),
                      child: CachedNetworkImage(
                        height: AppSize.s128,
                        width: AppSize.s128,
                        fit: BoxFit.cover,
                        imageUrl: provider.searchedNews!.newsPic!,
                        placeholder: (context, url) =>
                            SvgPicture.asset(ImageAssets.imagePhaceholder),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                  SizedBox(height: AppSize.s16),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppPadding.p12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.isArabic()
                              ? provider.searchedNews!.newsSubject!.trim()
                              : provider.searchedNews!.newsEsubject!.trim(),
                          style: getBoldStyle(
                              color: ColorManager.darkGrey,
                              fontSize: FontSizeManager.s28),
                        ),
                        SizedBox(height: AppSize.s8),
                        Html(
                          data: provider.isArabic()
                              ? provider.searchedNews!.newsBudy!.trim()
                              : provider.searchedNews!.newsEbudy!.trim(),
                          style: {
                            'body': _getHTMLStyle(),
                            'span': _getHTMLStyle(),
                            'font': _getHTMLStyle()
                          },
                           onLinkTap: (url, attributes, element) {
                            launchUrl(Uri.parse(url!),
                                mode: LaunchMode.externalApplication);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
