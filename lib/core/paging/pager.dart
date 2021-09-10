
import 'dart:async';
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
import 'package:synchronized/synchronized.dart';

/// @author Paul Okeke
/// A Paging Library

typedef PagingBuilder<T> = Widget Function(BuildContext context, T value, Widget? child);

class Pager<K, T> extends StatefulWidget {
  Pager({
    Key? key,
    required this.source,
    required this.builder,
    this.pagingConfig = const PagingConfig.fromDefault(),
    this.child,
    this.scrollController
  }) : super(key: key);

  final PagingSource<K, T> source;

  final PagingBuilder<PagingData<T>> builder;

  final PagingConfig pagingConfig;

  final Widget? child;

  final ScrollController? scrollController;


  @override
  State<StatefulWidget> createState() => _PagerState<K,T>();

}

class _PagerState<K, T> extends State<Pager<K, T>> {

  final List<Page<K, T>> _pages = [];

  int _initialPageIndex = 0;
  int loadId = 0;
  int preFetchedCounter = 0;
  LoadStates _states = LoadStates.idle();
  PagingData<T> snapShot = PagingData([]);
  LoadStates? sourceStates = LoadStates.idle();
  LoadStates? mediatorStates = LoadStates.idle();

  final lock = Lock();

  late PagingData<T> value;

  ScrollController? _scrollController;

  PagingSource<K, T>? _pagingSource;
  RemoteMediator<K, T>? _remoteMediator;

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
    _pagingSource = widget.source;
    _remoteMediator = _pagingSource?.remoteMediator;
    _remoteMediator?.addListener(_remoteValueChanged);
    super.initState();
    requestRemoteLoad(LoadType.REFRESH).then((value) => "");
    _doInitialLoad();
  }

  @override
  void dispose() {
    _remoteMediator?.removeListener(_remoteValueChanged);
    ///_scrollController?.dispose();
    super.dispose();
  }

  List<T> transformPages() {
    return _pages.fold(<T>[], (List<T> previousValue, element) {
      previousValue.addAll(element.data);
      return previousValue;
    });
  }

  void updateState() {
    _states = _states.combineStates(sourceStates!, mediatorStates!);
    print("Updating State $sourceStates");
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

  Future<void> requestRemoteLoad(LoadType loadType) async {
    if(mediatorStates?.append.endOfPaginationReached == true) return;

    mediatorStates = mediatorStates?.modifyState(loadType, Loading());
    updateState();
    final result = await _remoteMediator?.load(loadType, PagingState(_pages, widget.pagingConfig));

    if(result is MediatorSuccess && result.endOfPaginationReached == true) {
      mediatorStates = mediatorStates?.modifyState(loadType, NotLoading(true));
      updateState();
      return;
    }
    if(result is MediatorSuccess  && loadType == LoadType.REFRESH) {
      mediatorStates = mediatorStates?.modifyState(loadType, NotLoading(result.endOfPaginationReached));
      print("Successful and clearing");
      _pages.clear();
      _doInitialLoad();
    }
    if(result is MediatorSuccess && loadType == LoadType.APPEND) {
      mediatorStates = mediatorStates?.modifyState(loadType, NotLoading(result.endOfPaginationReached));
      //check if the lastKey is null
      if(_pages.length > 0 && _pages.last.nextKey == null) {
        //we should invalidate for a reload
        _doLoad(LoadType.APPEND, invalidate: true);
      }
    }
    if(result is MediatorError) {
      mediatorStates = mediatorStates?.modifyState(loadType, Error(result.exception));
      updateState();
    }
  }

  void _doInitialLoad() async {
    final params = loadParams(LoadType.REFRESH, null);
    loadId = 0;
    setLoading();
    _pages.clear();
    await for (Page<K, T> page in  widget.source.localSource(params)) {
      final insertApplied = insert(loadId++, LoadType.REFRESH, page);

      sourceStates = sourceStates?.modifyState(LoadType.REFRESH, NotLoading(page.nextKey == null))
          .modifyState(LoadType.APPEND, NotLoading(page.nextKey == null))
          .modifyState(LoadType.PREPEND, NotLoading(page.nextKey == null));

      if(insertApplied) updateState();

      int loadRound =  widget.pagingConfig.preFetchDistance ~/ widget.pagingConfig.pageSize;
      // while(preFetchedCounter < loadRound) {
      //   _doLoad(LoadType.APPEND);
      //   preFetchedCounter++;
      // }
      break;
    }
  }

  void _doLoad(LoadType type, {bool invalidate = false}) async {
    switch(type) {
      case LoadType.APPEND : {
        await lock.synchronized(() async {

          final lastPage = (_pages.isNotEmpty) ? _pages.last : null;
          final nextKey = invalidate ? lastPage?.prevKey : lastPage?.nextKey;
          final params = loadParams(LoadType.APPEND, nextKey);

          int mLoadId = loadId + 1;

          if(sourceStates?.append.endOfPaginationReached == true
              && mediatorStates?.append.endOfPaginationReached == true) {
            print("Done Loading ===>>> Page End");
            return;
          }

          print("Previous Key is ${lastPage?.prevKey}, Next Key $nextKey");
          if(nextKey != null ) {
            //update the state
            sourceStates = sourceStates?.modifyState(LoadType.REFRESH, NotLoading(true))
                .modifyState(LoadType.APPEND, Loading(endOfPaginationReached: true))
                .modifyState(LoadType.PREPEND, NotLoading(true));

            updateState();

            await for (Page<K, T> nextPage in widget.source.localSource(params)) {
              final insertApplied = (nextPage.nextKey != nextKey) ? insert(mLoadId, LoadType.APPEND, nextPage) : true;
              print("Page says nextKey is ${nextPage.nextKey} PageSize ${nextPage.data.length} is it inserted $insertApplied");
              if (nextPage.nextKey == null) {
                sourceStates = sourceStates?.modifyState(LoadType.REFRESH, NotLoading(true))
                    .modifyState(LoadType.APPEND, NotLoading(true))
                    .modifyState(LoadType.PREPEND, NotLoading(true));
              }

              if (insertApplied) updateState();
              break;
            }
          }
          if(_remoteMediator != null && mediatorStates?.append.endOfPaginationReached == false && !invalidate) {
            //check if this has been loaded
            await requestRemoteLoad(LoadType.APPEND);
          }
        });
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
        if(_pages.last.data.length < widget.pagingConfig.pageSize) {
          _pages.removeLast();
          _pages.add(page);
        } else {
          _pages.add(page);
          _initialPageIndex++;
        }
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
    if(oldWidget.builder is ScrollView) {
      _scrollController = (oldWidget.builder as ScrollView).controller;
    }
    if(_pagingSource == widget.source) {
      print("A New Data");

    } else {
      _states = LoadStates.idle();
      sourceStates = LoadStates.idle();
      mediatorStates = LoadStates.idle();
      _pagingSource = widget.source;
      _initialPageIndex = -1;
      loadId = 0;
      preFetchedCounter = 0;
      _remoteMediator = _pagingSource?.remoteMediator;
      _doInitialLoad();
      requestRemoteLoad(LoadType.REFRESH);
    }
  }


  void _localValueChanged(PagingData<T> event) {
    if(mounted) {
      setState(() { value = event; });
      snapShot = event;
    }else {
      print("Not mounted $_states");
    }
  }
  
  void _remoteValueChanged() {

  }

  void dispatchChanges() {

  }

  void _scrollListener() {
    if(_scrollController?.position.pixels == _scrollController?.position.maxScrollExtent) {
      print("it's the time to load more");
      _doLoad(LoadType.APPEND);
    }
  }
  
  void _registerScrollListener() {
    final scrollController = _scrollController ?? widget.scrollController;
    scrollController?.removeListener(_scrollListener);
    scrollController?.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    Widget builder = widget.builder(context, value, widget.child);
    if (builder is ScrollView) {
      _scrollController = builder.controller;
    } else {
      _scrollController = widget.scrollController;
    }
    _registerScrollListener();
    return builder;
  }

}