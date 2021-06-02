import 'package:flutter/material.dart' hide ScrollView;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/onboarding/viewmodel/onboarding_view_model.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/selfie_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/signature_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/new/ussd_view.dart';
import 'package:moniepoint_flutter/app/onboarding/views/profile_view.dart';
import 'package:moniepoint_flutter/core/views/pie_progress_bar.dart';
import 'package:provider/provider.dart';

class DetailCollectionScreen extends StatefulWidget {
  late final GlobalKey<ScaffoldState> _scaffoldKey;

  DetailCollectionScreen(this._scaffoldKey);

  @override
  State<StatefulWidget> createState() {
    return _CreateNewAccountState();
  }

}

class _CreateNewAccountState extends State<DetailCollectionScreen> {

  final _pageController = PageController();

  void _onLandScapeMode() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]
    );
  }

  void _onPortraitMode() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OnBoardingViewModel>(context, listen: false);

    viewModel.setIsNewAccount(true);

    final List<Widget> pages = [];

    VoidCallback callback = () {
      final currentPage = _pageController.page;
      if(currentPage != pages.length -1)  {
        _pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      }
    };

    pages.add(SelfieView(widget._scaffoldKey, onCompleted: callback));
    pages.add(SignatureView(widget._scaffoldKey, onCompleted: callback));
    pages.add(USSDView(widget._scaffoldKey, onCompleted: callback));
    pages.add(ProfileScreen(widget._scaffoldKey));

    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: Future.value(true),
            builder: (BuildContext mContext, AsyncSnapshot<void> snap) {
              return (snap.hasData) ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: PieProgressBar(
                    viewPager: _pageController,
                    totalItemCount: pages.length,
                    pageTitles: ["Selfie", "Signature", "USSD", "Profile"],
                ),
              ) : SizedBox();
            },
          ),
          Expanded(child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: pages,
            onPageChanged: (page) {
              if(page != 1) _onPortraitMode();
            },
          ))
        ],
      ),
    );
  }

}