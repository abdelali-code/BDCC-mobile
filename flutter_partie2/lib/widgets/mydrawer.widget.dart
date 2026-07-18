import 'package:flutter/material.dart';
import 'package:flutter_synthese/global/global.parameter.dart';
import 'package:flutter_synthese/widgets/drawer.header.widget.dart';
import 'package:flutter_synthese/widgets/drawer.item.widget.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const MyDrawerHeaderWidget(),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(
                height: 2,
                color: Colors.deepOrange,
              ),
              itemCount: GlobalParameters.menus.length,
              itemBuilder: (context, index) => DrawerItemWidget(
                GlobalParameters.menus[index]['title'] as String,
                GlobalParameters.menus[index]['route'] as String,
                GlobalParameters.menus[index]['icon'] as Icon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
