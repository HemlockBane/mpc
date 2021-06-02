import 'package:flutter/material.dart' hide Colors;
import 'package:moniepoint_flutter/core/network/resource.dart';

import '../colors.dart';


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
    String? emptyMessage,
    String? moduleName}) {
    
    if(!snapshot.hasData) return Container();

    final resource = snapshot.data;
    final hasData = resource?.data?.isNotEmpty == true;

    if(resource is Loading) {
      animationController.forward(from: 0);
      if(loadingView != null) {
        return _fadeLoadingView(animationController, loadingView);
      }
      return defaultLoadingView(animationController);
    }

    if(snapshot.hasError || snapshot.data is Error) return Container(child: Text('Error'),);

    if(resource == null  || resource is Loading && resource.data?.isEmpty == true) {
      return Container(child: Text('Empty'),);
    }

    if(resource is !Success) return Container(child: Text('Empty'),);

    //There are currently items displayed hence we don't need to
    // start the animation again
    if(currentList.isEmpty) {
      animationController.forward(from: 0);
    }

    currentList.clear();
    currentList.addAll(resource.data ?? []);

    return FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(animationController),
        child: listView.call(resource.data),
    );
  }
  
}