import 'package:moniepoint_flutter/app/dashboard/views/custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moniepoint_flutter/app/dashboard/viewmodels/dashboard_view_model.dart';
import 'package:moniepoint_flutter/core/colors.dart';
typedef DashboardRefreshIndicatorBuilder = Widget Function(BuildContext context, IndicatorController controller);


class DashboardRefreshIndicator extends StatefulWidget {
  final DashboardViewModel viewModel;
  final DashboardRefreshIndicatorBuilder builder;
  final double indicatorOffset;

  const DashboardRefreshIndicator(
      {Key? key,
      required this.viewModel, required this.builder, required this.indicatorOffset})
      : super(key: key);

  @override
  _DashboardRefreshIndicatorState createState() =>
      _DashboardRefreshIndicatorState();
}

class _DashboardRefreshIndicatorState extends State<DashboardRefreshIndicator>
    with SingleTickerProviderStateMixin {
  final _helper = IndicatorStateHelper();
  var showLoadingIndicator = false;

  ScrollDirection prevScrollDirection = ScrollDirection.idle;


  @override
  Widget build(BuildContext context) {
    final _indicatorOffset = widget.indicatorOffset;
    return CustomRefreshIndicator(
      offsetToArmed: _indicatorOffset,
      onRefresh: () async{
        widget.viewModel.startRefresh();
        await for (var _ in widget.viewModel.refreshDoneStream){
          await Future.delayed(Duration(seconds: 1));
          return null;
        }
      },
      childBuilder: widget.builder,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return Stack(
          children: <Widget>[
            child,
            AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final indicatorOffsetValue = controller.value * widget.indicatorOffset;
                return Container(
                  child: SvgPicture.asset(
                      "res/drawables/refresh_indicator_bg.svg",
                      fit: BoxFit.fill,
                      color: Colors.black.withOpacity(0.75)),
                  height: indicatorOffsetValue,
                  width: double.infinity,
                );
              },
            ),
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                _helper.update(controller.state);

                /// When the state changes to [idle]
                if (_helper.didStateChange(to: IndicatorState.idle)) {
                  showLoadingIndicator = false;
                }

                if (_helper.didStateChange(to: IndicatorState.dragging)) {
                  showLoadingIndicator = false;
                }

                if (_helper.didStateChange(to: IndicatorState.armed)) {
                  showLoadingIndicator = true;
                }

                final containerHeight = controller.value * widget.indicatorOffset;


                return !showLoadingIndicator
                    ? SizedBox()
                    : Container(
                        alignment: Alignment.center,
                        height: containerHeight,
                        child: OverflowBox(
                          maxHeight: 120,
                          minHeight: 120,
                          maxWidth: 120,
                          minWidth: 120,
                          child: Column(
                            children: [
                              SizedBox(height: 35),
                              AnimatedContainer(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                duration: const Duration(milliseconds: 150),
                                alignment: Alignment.center,
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 4,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.primaryColor),
                                    value: null,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                                Text(
                                "Fetching Updates...",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.4),
                                    fontSize: 11.4,
                                    fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                        ),
                      );
              },
            )
          ],
        );
      },
    );
  }
}
