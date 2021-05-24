
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Page;
import 'package:moniepoint_flutter/core/paging/combined_load_state.dart';
import 'package:moniepoint_flutter/core/paging/load_state.dart';
import 'package:moniepoint_flutter/core/paging/load_states.dart';
import 'package:moniepoint_flutter/core/paging/page_config.dart';
import 'package:moniepoint_flutter/core/paging/paging_data.dart';
import 'package:moniepoint_flutter/core/paging/paging_source.dart';
import 'package:moniepoint_flutter/core/paging/paging_state.dart';
import 'package:moniepoint_flutter/core/paging/remote_mediator.dart';

typedef PagingBuilder<T> = ScrollView Function(BuildContext context, T value, Widget? child);

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
  LoadStates? sourceStates;
  LoadStates? mediatorStates;
  late Stream<Page<K, T>> pagingSource;

  late PagingData<T> value;
  // late PagingData<T> previousValue;

  ScrollView? _scrollView;

  void _scrollListener() {
    print('scrollUpdate');
  }

  @override
  void initState() {
    pagingSource = widget.source.localSource();
    value = PagingData([]);
    widget.source.remoteMediator?.addListener(_remoteValueChanged);
    super.initState();
    _doRemoteLoad(LoadType.REFRESH);
    _doInitialLoad();
  }

  @override
  void dispose() {
    widget.source.remoteMediator?.removeListener(_remoteValueChanged);
    _scrollView?.controller?.dispose();
    super.dispose();
  }



  void updateState() {
    _localValueChanged(PagingData(snapShot.data, loadStates: CombinedLoadStates(
      _states.refresh, _states.append, _states.prepend,
        source: sourceStates, mediator:  mediatorStates
    )));
  }

  void _doRemoteLoad(LoadType type) async {
    if(type == LoadType.REFRESH) {
      _loadRefreshRemote(LoadType.REFRESH);
    }else {
      _loadRemoteBoundary();
    }
  }

  void _loadRefreshRemote(LoadType loadType) async {
    _states = _states.modifyState(loadType, Loading());
    updateState();
    final result = await widget.source.remoteMediator?.load(loadType, PagingState(_pages, widget.pagingConfig));
    if(result is MediatorSuccess && result.endOfPaginationReached == true) {
      _states = _states.modifyState(loadType, NotLoading(true));
      updateState();
    }
    else if(result is MediatorSuccess && result.endOfPaginationReached == false) {
      _states = _states.modifyState(loadType, Loading(endOfPaginationReached: false));
      updateState();
      print('making request');
      _doLoad(LoadType.APPEND);
    }
    else if(result is MediatorError) {
      _states = _states.modifyState(loadType, Error(result.exception));
      updateState();
    }
  }

  void _loadRemoteBoundary() async {
    _loadRefreshRemote(LoadType.APPEND);
  }

  void _doInitialLoad() async {
    _states = _states.modifyState(LoadType.REFRESH, Loading());
    updateState();
    await for (Page<K, T> page in pagingSource) {

      final insertApplied = insert(0, LoadType.REFRESH, page);

      if(page.prevKey == null) {
        _states = _states.modifyState(LoadType.PREPEND, NotLoading(true));
      }
      if(page.nextKey == null) {
        _states = _states.modifyState(LoadType.APPEND, NotLoading(true));
      }

      if(mounted && insertApplied) {
        // print(jsonEncode(page.data));
        print('PageSize' + widget.pagingConfig.pageSize.toString());
        print('ItemSize' + page.data.length.toString());
        _localValueChanged(page.toPagingData(_states));
      }

      if (mounted && _states.append is Loading) {
        print('Mounted---????!!!!!');
        insert(++loadId, LoadType.APPEND, page);
      }
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
    print('Widget Updated!!!!!!');
  }

  void _doLoad(LoadType type) async {
    switch(type) {
      case LoadType.REFRESH:
        break;
      case LoadType.APPEND:
        print('Append');
        //fetch from the data base and break
        _doRemoteLoad(LoadType.APPEND);
        await for (Page<K, T> t in pagingSource.take(_initialPageIndex + 1 * widget.pagingConfig.pageSize)) {

          break;
        }

        break;
      case LoadType.PREPEND:
        break;
    }
  }

  void _localValueChanged(PagingData<T> event) {
    //we need to load from remote here
    setState(() { value = event; });
    snapShot = event;
  }
  
  void _remoteValueChanged() {
  }

  void dispatchChanges() {
  }
  
  void _registerScrollListener() {
    final scrollController = _scrollView?.controller;
    scrollController?.removeListener(_scrollListener);
    scrollController?.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    _scrollView = widget.builder(context, value, widget.child);
    if(_scrollView!.controller == null) {
      throw Exception("Specify a scrollController");
    }
    _registerScrollListener();
    return _scrollView!;
  }

}