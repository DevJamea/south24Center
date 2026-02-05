import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/home/search_news_widget.dart';
import 'package:south24/presentation/home/search_text_field.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {  
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;


  @override
  void deactivate() {
    super.deactivate();
    final provider = Provider.of<Controller>(context, listen: false);
    provider.searchController.text = "";
    provider.searchList = [];
  }

  @override
  Widget build(BuildContext context) {
        analytics.logScreenView(screenName: 'Search');

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
            child: Column(
              children: [
                SearchTextField(),
                const Divider(thickness: AppSize.s2),
                const SizedBox(height: AppSize.s28),
                Expanded(
                  flex: 1,
                  child: _buildSearchResults(size, provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(Size size, Controller provider) {
    if (!provider.isConnected) {
      return NoConnectionState(StateRendererType.fullScreenNoConnectionState,
              AppStrings.noInternetConnection.tr())
          .getScreenWidget(context);
    }

    if (provider.searchList == null) {
      return LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
      ).getScreenWidget(context);
    }

    if (provider.searchList!.isEmpty) {
      return NoDataState(
        stateRendererType: StateRendererType.fullScreenNoDataState,
      ).getScreenWidget(context);
    }

    return ListView.builder(
      itemCount: provider.searchList!.length,
      addAutomaticKeepAlives: false,
      itemBuilder: (context, index) {
        return SearchNewsWidget(
          size: size,
          news: provider.searchList![index],
        );
      },
    );
  }
}
