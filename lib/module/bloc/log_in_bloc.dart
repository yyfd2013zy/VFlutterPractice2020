import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'log_in_event.dart';
part 'log_in_state.dart';

/**
 * 主要的逻辑代码
 */
class LogInBloc extends Bloc<LogInEvent, LogInState> {
  LogInBloc() : super(LogInState().init());

  @override
  Stream<LogInState> mapEventToState(LogInEvent event,) async* {
    ///main_view中添加的事件，会在此处回调，此处处理完数据，将数据yield，BlocBuilder就会刷新组件
    if(event is LogInInitEvent){
      yield await init();
    }else if (event is SwitchTabEvent) {
      ///获取到event事件传递过来的值,咱们拿到这值塞进MainState中
      ///直接在state上改变内部的值,然后yield,只能触发一次BlocBuilder,它内部会比较上次MainState对象,如果相同,就不build
      yield switchTap(event);
    } else if (event is IsExtendEvent) {
      yield isExtend();
    }
  }

  ///初始化操作,在网络请求的情况下,需要使用如此方法同步数据
  Future<LogInState> init() async {
    return state.clone();
  }

  ///切换tab
  LogInState switchTap(SwitchTabEvent event) {
    return state.clone()..selectedIndex = event.selectedIndex;
  }

  ///是否展开
  LogInState isExtend() {
    return state.clone()..isExtended = !state.isExtended;
  }


}
