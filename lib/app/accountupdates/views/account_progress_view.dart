import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/services.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/account_update_flag.dart';
import 'package:moniepoint_flutter/app/accounts/model/data/tier.dart';
import 'package:moniepoint_flutter/core/colors.dart';
import 'package:moniepoint_flutter/core/styles.dart';
import 'package:moniepoint_flutter/core/tuple.dart';
import 'dart:ui' as ui;
import 'package:moniepoint_flutter/core/extensions/text_utils.dart';

import 'colored_linear_progress_bar.dart';

class AccountProgressView extends StatefulWidget {

  final double progress;
  final List<Tier> tiers;

  AccountProgressView(this.progress, this.tiers);

  @override
  State<StatefulWidget> createState() => _AccountProgressState();

}

class _AccountProgressState extends State<AccountProgressView> with TickerProviderStateMixin {

  ui.Image? _checkMarkIcon;
  bool _isImageLoaded = false;
  double _previousProgressValue = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future <Null> init() async {
    final ByteData data = await rootBundle.load('res/drawables/ic_check_mark_progress.png');
    _checkMarkIcon = await loadImage(new Uint8List.view(data.buffer));
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        _isImageLoaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final tween = Tween<double>(begin: _previousProgressValue, end: widget.progress);
    return Column(
      children: [
        if(_isImageLoaded)
          SizedBox(
            width: double.infinity,
            child: TweenAnimationBuilder(
                tween: tween,
                curve: Curves.decelerate,
                duration: Duration(seconds: 3),
                builder: (mContext, double value, _) {
                  return CustomPaint(
                      size: Size(double.infinity, 60),
                      painter: ColoredLinearProgressBar(
                          progress: value,
                          tiers: widget.tiers,
                          checkMarkIcon: _checkMarkIcon,
                          tierPositionCallback: (tier, width) {
                            final sumOfNotRequiredWeight = tier.alternateSchemeRequirement?.toAccountUpdateFlag().fold(0, (int previousValue, element) {
                              if(!element.required && element.flagName != Flags.BVN_VERIFIED) previousValue += element.weight;
                              return previousValue;
                            });
                            final percentageValue = 100 - (sumOfNotRequiredWeight ?? 0);
                            return (percentageValue / 100) * width;
                          }
                      )
                  );
                }
            ),
          )
      ],
    );
  }

  @override
  void didUpdateWidget(covariant AccountProgressView oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

}