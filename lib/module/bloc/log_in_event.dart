part of 'log_in_bloc.dart';

/**
 * 执行各类事件
 */
@immutable
abstract class LogInEvent {
  const LogInEvent();
}

///优化，（这是一个事件），初始化事件,这边目前不需要传什么值
class LogInInitEvent extends LogInEvent {}

///切换NavigationRail的tab
class SwitchTabEvent extends LogInEvent {
  final int selectedIndex;

  const SwitchTabEvent({@required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

///展开NavigationRail,这个逻辑比较简单,就不用传参数了
class IsExtendEvent extends LogInEvent {
  const IsExtendEvent();

  @override
  List<Object> get props => [];
}
