import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:south24/app/provider_controller.dart';
import 'package:south24/data/network/data_source.dart';
import 'package:south24/presentation/common/state_renderer.dart';
import 'package:south24/presentation/common/state_renderer_impl.dart';
import 'package:south24/presentation/resources/assets_manager.dart';
import 'package:south24/presentation/resources/strings_mangaer.dart';
import 'package:south24/presentation/resources/values_manager.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerWidget extends StatefulWidget {
  final String url;

  const PdfViewerWidget({Key? key, required this.url}) : super(key: key);

  @override
  _PdfViewerWidgetState createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  File? _localFile;
  @override
  void initState() {
    DataSource.instance.loadPDF(widget.url).then((value) {
      setState(() {
        _localFile = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Controller>(builder: (context, provider, child) {
      return Scaffold(
          appBar: AppBar(
              primary: true,
              title: Image(
                image: const AssetImage(ImageAssets.splashLogo),
                height: AppBar().preferredSize.height - AppSize.s18,
              )),
          body: !provider.isConnected
              ? ErrorState(StateRendererType.fullScreenErrorState,
                      AppStrings.noInternetConnection.tr())
                  .getScreenWidget(context)
              : _localFile == null
                  ? LoadingState(
                          stateRendererType:
                              StateRendererType.fullScreenLoadingState)
                      .getScreenWidget(context)
                  : SfPdfViewer.file(_localFile!)
                  );
    });
  }
}
