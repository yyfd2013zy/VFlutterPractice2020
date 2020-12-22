part of 'log_in_bloc.dart';
/**
 * 状态数据放在这里保存，中转
 */
/*@immutable
abstract class LogInState {}

class LogInInitial extends LogInState {}*/

//上面是插件生成的代码模板，简单功能可以不用上面的模板
class LogInState {
  int selectedIndex;
  bool isExtended;
  LogInState({this.selectedIndex, this.isExtended});

  ///优化state类，添加初始化方法
  LogInState init() {
    return LogInState()
      ..selectedIndex = 0
      ..isExtended = false;
  }

  ///clone方法,此方法实现参考fish_redux的clone方法
  ///也是对官方Flutter Login Tutorial这个demo中copyWith方法的一个优化
  ///Flutter Login Tutorial（https://bloclibrary.dev/#/flutterlogintutorial）
  LogInState clone() {
    return LogInState()
      ..selectedIndex = selectedIndex
      ..isExtended = isExtended;
  }

}
