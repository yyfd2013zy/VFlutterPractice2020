import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:v_flutter_practice_2020/module/bloc/log_in_bloc.dart';

class PageLogIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ///界面绑定Bloc
    return BlocProvider(
      create: (BuildContext context) => LogInBloc()..add(LogInInitEvent()),
      child: BodyPage(),
    );
  }
}

class BodyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bloc')),
      body: totalPage(),
    );
  }
}

Widget totalPage() {
  return Row(
    children: [
      navigationRailSide(),
      Expanded(child: Center(
        child: BlocBuilder<LogInBloc, LogInState>(builder: (context, state) {
          ///在这里通过BlocBuilder 将state关联起来了，进行界面刷新
          return Text("selectedIndex:" + state.selectedIndex.toString());
        }),
      ))
    ],
  );
}

//增加NavigationRail组件为侧边栏
Widget navigationRailSide() {
  //顶部widget
  Widget topWidget = Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: NetworkImage(
                    "https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=3383029432,2292503864&fm=26&gp=0.jpg"),
                fit: BoxFit.fill),
          )),
    ),
  );

  //底部widget
  Widget bottomWidget = Container(
    child: BlocBuilder<LogInBloc, LogInState>(
      builder: (context, state) {
        return FloatingActionButton(
          onPressed: () {
            ///添加NavigationRail展开,收缩事件
            context.bloc<LogInBloc>().add(IsExtendEvent());
          },

          ///看这看这：刷新组件！
          child: Icon(state.isExtended ? Icons.send : Icons.navigation),
        );
      },
    ),
  );

  return BlocBuilder<LogInBloc, LogInState>(builder: (context, state) {
     return NavigationRail(
      backgroundColor: Colors.white12,
      elevation: 3,
      ///看这看这：刷新组件！
      extended: state.isExtended,
      labelType: state.isExtended ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
      //侧边栏中的item
      destinations: [
        NavigationRailDestination(
            icon: Icon(Icons.add_to_queue),
            selectedIcon: Icon(Icons.add_to_photos),
            label: Text("测试一")),
        NavigationRailDestination(
            icon: Icon(Icons.add_circle_outline),
            selectedIcon: Icon(Icons.add_circle),
            label: Text("测试二")),
        NavigationRailDestination(
            icon: Icon(Icons.bubble_chart),
            selectedIcon: Icon(Icons.broken_image),
            label: Text("测试三")),
      ],
      //顶部widget
      leading: topWidget,
      //底部widget
      trailing: bottomWidget,
      selectedIndex: state.selectedIndex,
      onDestinationSelected: (int index) {
        ///添加切换tab事件
        context.bloc<LogInBloc>().add(SwitchTabEvent(selectedIndex: index));
      },
    );
  });
}
