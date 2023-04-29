import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/home/search_news_widget.dart';
import 'package:south24/presentation/home/search_text_field.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void deactivate() {
    final provider = Provider.of<Controller>(context, listen: false);
    provider.searchController.text = "";
    provider.searchList = [];
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<Controller>(builder: (context, provider, child) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
              primary: true,
              title: Image(
                image: const AssetImage(ImageAssets.splashLogo),
                height: AppBar().preferredSize.height - AppSize.s18,
              )),
          body: SafeArea(
            child: Column(
              children: [
                SearchTextField(),
                const Divider(
                  thickness: AppSize.s2,
                ),
                SizedBox(
                  height: AppSize.s28,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      child: provider.searchList == null
                          ? LoadingState(
                                  stateRendererType:
                                      StateRendererType.fullScreenLoadingState)
                              .getScreenWidget(context)
                          : provider.searchList!.isEmpty
                              ? NoDataState(
                                      stateRendererType: StateRendererType
                                          .fullScreenNoDataState)
                                  .getScreenWidget(context)
                              : ListView.builder(
                                  itemCount: provider.searchList!.length,
                                  itemBuilder: (context, index) {
                                    return SearchNewsWidget(
                                        size: size,
                                        news: provider.searchList![index]);
                                  },
                                )),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
