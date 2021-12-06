import 'package:flutter/material.dart' hide Colors;
import 'package:lottie/lottie.dart';
import 'package:moniepoint_flutter/core/network/network_bound_resource.dart';
import 'package:moniepoint_flutter/core/network/resource.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/load_state.dart' as loadStates;

import '../colors.dart';
import '../tuple.dart';


class ListViewUtil {

  static Widget defaultLoadingView(AnimationController controller) {
    return Center(
      child: SizedBox(
        height: 30,
        width: 30,
        child: FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(controller),
            child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.darkBlue),
          ),
        ),
      ),
    );
  }

  static Widget _fadeLoadingView(AnimationController controller, Widget loadingWidget) {
    return FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(controller),
        child: loadingWidget,
    );
  }
  
  static Widget makeListViewWithState<T>({
    required BuildContext context, 
    required AsyncSnapshot<Resource<List<T>?>> snapshot, 
    required ListView Function(List<T>? items) listView,
    required AnimationController animationController,
    required List<T> currentList,
    bool displayLocalData = true,
    Widget? loadingView,
    Widget? emptyPlaceholder,
    Widget? errorLayoutView,
    String? moduleName}) {
    
    if(!snapshot.hasData) return Container();

    final resource = snapshot.data;
    final hasData = resource?.data?.isNotEmpty == true;
    bool keepCurrent = false;

    if(resource is Loading && (displayLocalData && !hasData || !displayLocalData)) {
      animationController.forward(from: 0);

      if(loadingView != null) {
        return _fadeLoadingView(animationController, loadingView);
      }
      return defaultLoadingView(animationController);
    }

    if((snapshot.hasError || snapshot.data is Error) && (!displayLocalData || currentList.isEmpty)) {
      return errorLayoutView ?? Container(child: Text('Error'),);
    }

    if(resource == null || resource is Loading && resource.data?.isEmpty == true) {
      return emptyPlaceholder ?? Container(child: Text('Empty'),);
    }

    if(resource is Success && !hasData) {
      return emptyPlaceholder ?? Text('Empty Data');
    }

    //if(resource is !Success) return Container(child: Text('Empty'),);

    // There are currently items displayed hence we don't need to
    // start the animation again
    if(currentList.isEmpty) {
      animationController.forward(from: 0);
    }

    keepCurrent = ((currentList.isNotEmpty && displayLocalData) && resource is Error);

    if(!keepCurrent) {
      currentList.clear();
      currentList.addAll(resource.data ?? []);
    }

    return FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(animationController),
        child: listView.call(keepCurrent ? currentList : resource.data),
    );
  }

  static Widget handleLoadStates({
    required AnimationController animationController,
    required PagingData pagingData,
    required Widget shimmer,
    required Widget Function(PagingData data, bool isEmpty, Tuple<String, String>? errorMessage) listCallback
  }) {
    Tuple<String, String>? error;
    print("Refresh State ===> ${pagingData.loadStates}.");

    if(pagingData.loadStates == null || pagingData.loadStates!.refresh is loadStates.Loading) {
      animationController.forward(from: 0);
      return shimmer;
    } else if(pagingData.loadStates?.refresh is loadStates.Error) {
      print("Error on refresh.....");
      animationController.forward(from: 0);
      final errorState = pagingData.loadStates?.refresh as loadStates.Error;
      error = formatError(errorState.exception.toString(), "Transactions");
    }

    bool _isListEmpty = pagingData.loadStates?.refresh is loadStates.NotLoading && pagingData.data.isEmpty;

    animationController.forward();

    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(animationController),
      child: listCallback(pagingData, _isListEmpty, error),
    );
  }


}

///LoadStatesLoadingIndicator
///
///
class LoadStatesLoadingIndicator extends StatelessWidget {

  final PagingData pagingData;

  LoadStatesLoadingIndicator({required this.pagingData});

  @override
  Widget build(BuildContext context) {
    if(pagingData.loadStates != null && pagingData.loadStates!.mediator?.append is loadStates.Loading)  {
      final mediator = pagingData.loadStates!.mediator;
      if(mediator!.append.endOfPaginationReached == false) {
        return Container(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          child: Lottie.asset('res/drawables/progress_bar_lottie.json', width: 30, height: 30),
        );
      }
    }
    return SizedBox();
  }
}