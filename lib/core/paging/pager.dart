
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Page;
import 'package:moniepoint_flutter/core/models/transaction.dart';
import 'package:moniepoint_flutter/core/paging/combined_load_state.dart';
import 'package:moniepoint_flutter/core/paging/load_state.dart';
import 'package:moniepoint_flutter/core/paging/load_states.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/paging/paging_state.dart';
import 'package:moniepoint_flutter/core/paging/remote_mediator.dart';

typedef PagingBuilder<T> = Widget Function(BuildContext context, T value, Widget? child);

class Pager<K, T> extends StatefulWidget {
  Pager({
    Key? key,
    required this.source,
    required this.builder,
    this.pagingConfig = const PagingConfig.fromDefault(),
    this.child
  }) : super(key: key);

  final PagingSource<K, T> source;

  final PagingBuilder<PagingData<T>> builder;

  final PagingConfig pagingConfig;

  final Widget? child;


  @override
  State<StatefulWidget> createState() => _PagerState<K,T>();

}

class _PagerState<K, T> extends State<Pager<K, T>> {

  final List<Page<K, T>> _pages = [];

  int _initialPageIndex = 0;
  int loadId = 0;
  LoadStates _states = LoadStates.idle();
  PagingData<T> snapShot = PagingData([]);
  LoadStates? sourceStates = LoadStates.idle();
  LoadStates? mediatorStates = LoadStates.idle();
  late Stream<Page<K, T>> pagingSource;

  late PagingData<T> value;

  ScrollView? _scrollView;

  LoadParams<K> loadParams(LoadType loadType, K? key) {
    return LoadParams(
        loadType,
        key,
        (loadType == LoadType.REFRESH) ? widget.pagingConfig.initialPageSize : widget.pagingConfig.pageSize
    );
  }

  @override
  void initState() {
    value = PagingData([]);
    widget.source.remoteMediator?.addListener(_remoteValueChanged);
    super.initState();
    requestRemoteLoad(LoadType.REFRESH);
    _doInitialLoad();
  }

  @override
  void dispose() {
    widget.source.remoteMediator?.removeListener(_remoteValueChanged);
    _scrollView?.controller?.dispose();
    super.dispose();
  }

  List<T> transformPages() {
    return _pages.fold(<T>[], (List<T> previousValue, element) {
      previousValue.addAll(element.data);
      return previousValue;
    });
  }

  void updateState() {
    _localValueChanged(PagingData(transformPages(), loadStates: CombinedLoadStates(
      _states.refresh, _states.append, _states.prepend,
        source: sourceStates, mediator:  mediatorStates
    )));
  }

  void setLoading() {
    sourceStates = sourceStates?.modifyState(LoadType.REFRESH, Loading());
    _states = _states.modifyState(LoadType.REFRESH, Loading());
    updateState();
  }

  void _doRemoteLoad(LoadType type) async {
    // if(type == LoadType.REFRESH) {
    //   _loadRefreshRemote(LoadType.REFRESH);
    // }else {
    //   _loadRemoteBoundary();
    // }
  }

  void _loadRefreshRemote(LoadType loadType) async {
    // _states = _states.modifyState(loadType, Loading());
    // updateState();
    // final result = await widget.source.remoteMediator?.load(loadType, PagingState(_pages, widget.pagingConfig));
    // if(result is MediatorSuccess && result.endOfPaginationReached == true) {
    //   _states = _states.modifyState(loadType, NotLoading(true));
    //   updateState();
    // }
    // else if(result is MediatorSuccess && result.endOfPaginationReached == false) {
    //   _states = _states.modifyState(loadType, Loading(endOfPaginationReached: false));
    //   updateState();
    //   print('making request');
    //   _doLoad(LoadType.APPEND);
    // }
    // else if(result is MediatorError) {
    //   _states = _states.modifyState(loadType, Error(result.exception));
    //   updateState();
    // }
  }

  void requestRemoteLoad(LoadType loadType) async {
    mediatorStates = mediatorStates?.modifyState(loadType, Loading());
    updateState();
    print('Request State');
    final result = await widget.source.remoteMediator?.load(loadType, PagingState(_pages, widget.pagingConfig));
    if(result is MediatorSuccess && result.endOfPaginationReached == true) {
      mediatorStates?.modifyState(loadType, NotLoading(true));
      updateState();
    }
  }

  void _doInitialLoad() async {
    final params = loadParams(LoadType.REFRESH, null);
    setLoading();
    await for (Page<K, T> page in  widget.source.localSource(params)) {
      print("DATA ${jsonEncode(page.data)}");
      final insertApplied = insert(loadId++, LoadType.REFRESH, page);
      if(page.nextKey == null) {
        sourceStates = sourceStates?.modifyState(LoadType.REFRESH, Loading(endOfPaginationReached: true))
            .modifyState(LoadType.APPEND, NotLoading(true))
            .modifyState(LoadType.PREPEND, NotLoading(true));
      }

      if(insertApplied) updateState();

      if(widget.source.remoteMediator != null && (page.nextKey == null || page.prevKey == null)) {
        if (page.nextKey == null) {
          requestRemoteLoad(LoadType.APPEND);
          break;
        }
        else break;
      } else break;
    }
  }

  void _doLoad(LoadType type) async {
    switch(type) {
      case LoadType.APPEND : {

        break;
      }
      case LoadType.PREPEND:
        // TODO: Handle this case.
        break;
      case LoadType.REFRESH:
        //Do nothing
        break;
    }
  }

  bool insert(int loadId, LoadType loadType, Page<K, T> page) {
    switch(loadType) {
      case LoadType.REFRESH:
        if(_pages.isNotEmpty) return false;
        if(loadId != 0) return false;

        _pages.add(page);
        _initialPageIndex = 0;

        break;
      case LoadType.APPEND:
        if(_pages.isEmpty) return false;
        if(loadId == 0) return false;
        _pages.add(page);
        _initialPageIndex++;

        break;
      case LoadType.PREPEND:
        break;
    }

    return true;
  }

  @override
  void didUpdateWidget(covariant Pager<K, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    //check if this is a hard refresh

  }


  void _localValueChanged(PagingData<T> event) {
    if(mounted) {
      setState(() { value = event; });
      snapShot = event;
    }
  }
  
  void _remoteValueChanged() {

  }

  void dispatchChanges() {

  }

  void _scrollListener() {

  }
  
  void _registerScrollListener() {
    final scrollController = _scrollView?.controller;
    scrollController?.removeListener(_scrollListener);
    scrollController?.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    Widget builder = widget.builder(context, value, widget.child);
    if (builder is ScrollView) {
      _scrollView = builder;
      if (_scrollView!.controller == null) {
        throw Exception("Specify a scrollController");
      }
      _registerScrollListener();
    }
    return builder;
  }

}