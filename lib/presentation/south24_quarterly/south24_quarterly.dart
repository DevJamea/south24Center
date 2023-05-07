import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/publications/publications_widget.dart';
import 'package:south24/presentation/resources/color_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/styles_manager.dart';
import 'package:south24/presentation/resources/values_manager.dart';

class South24QuarterlyView extends StatefulWidget {
  const South24QuarterlyView({Key? key}) : super(key: key);

  @override
  _South24QuarterlyViewState createState() => _South24QuarterlyViewState();
}

class _South24QuarterlyViewState extends State<South24QuarterlyView> {

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<Controller>(context, listen: false);
  if (provider.quarterly.isEmpty) {
          provider.getQuarterlyNews();
        }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait = size.height > size.width;
    final textStyle = getMediumStyle(color: ColorManager.black);

    return Consumer<Controller>(
      builder: (context, provider, child) {

        if (!provider.isConnected) {
          return ErrorState(
            StateRendererType.fullScreenErrorState,
            AppStrings.noInternetConnection.tr(),
          ).getScreenWidget(context);
        }

        if (provider.quarterly.isEmpty) {
          return LoadingState(
            stateRendererType: StateRendererType.fullScreenLoadingState,
          ).getScreenWidget(context);
        }

        return Scaffold(
            body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppPadding.p12),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isPortrait ? 1 : 2,
              crossAxisSpacing: AppSize.s12,
              mainAxisExtent:
                  size.height / 2 + AppSize.s8 + textStyle.fontSize!,
            ),
            itemCount: provider.quarterly.length,
            padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
            itemBuilder: (context, index) {
              return PublicationsWidget(
                versions: provider.quarterly[index],
              );
            },
          ),
        ));
      },
    );
  }
}
