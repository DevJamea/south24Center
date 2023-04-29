import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/about/first_section.dart';
import 'package:south24/presentation/about/last_section.dart';
import 'package:south24/presentation/about/section_name.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/footer/footer_view.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class AboutView extends StatefulWidget {
  const AboutView({Key? key}) : super(key: key);

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  late final Controller provider;

  @override
  void initState() {
    super.initState();
    provider = context.read<Controller>();
    if (provider.about.isEmpty) provider.getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(
      builder: (context, provider, child) {
        return Scaffold(
          body: !provider.isConnected
              ? ErrorState(
                  StateRendererType.fullScreenErrorState,
                  AppStrings.noInternetConnection.tr(),
                ).getScreenWidget(context)
              : provider.about.isEmpty
                  ? LoadingState(
                      stateRendererType: StateRendererType.fullScreenLoadingState,
                    ).getScreenWidget(context)
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(AppPadding.p12),
                            child: FirstSectionAbout(),
                          ),
                          SectionNameWidget(
                            sectionName: AppStrings.directors.tr(),
                            tag: "1",
                          ),
                          SectionNameWidget(
                            sectionName: AppStrings.editorialTeam.tr(),
                            tag: "2",
                          ),
                          SectionNameWidget(
                            sectionName: AppStrings.correspondents.tr(),
                            tag: "3",
                          ),
                          SectionNameWidget(
                            sectionName: AppStrings.consultants.tr(),
                            tag: "4",
                          ),
                          SectionNameWidget(
                            sectionName: AppStrings.researchersAndExperts.tr(),
                            tag: "5",
                          ),
                          const Divider(),
                          const LastSection(),
                          const FooterView(),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
