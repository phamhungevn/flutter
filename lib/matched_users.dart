import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../models/match_cart_model.dart';
import 'Common/footer.dart';
import 'Drawer/drawer.dart';

class MatchedUsers extends StatelessWidget {
  const MatchedUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var length = context.read<MatchCartModel>().getTotal();
    return Scaffold(
      drawer: MyDrawer.provider(),
      body: CustomScrollView(
        slivers: [
          _MyAppBar(),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _MyListItem(index),
                childCount: length),
          ),
        ],
      ),
      bottomNavigationBar: const NavigationBottom(),
    );
  }
}

class _MyAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      toolbarHeight: 50,
      title: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Text('Danh sách có mặt',
          //  textAlign: TextAlign.center,
          //  style: Theme.of(context).textTheme.headline2
        ),
      ),
      floating: true,
      // actions: [
      // IconButton(
      //   icon: const Icon(Icons.shopping_cart),
      //   onPressed: () => Navigator.pushNamed(context, '/cart'),
      // ),
      //   ],
    );
  }
}

class _MyListItem extends StatelessWidget {
  final int index;

  const _MyListItem(this.index);

  @override
  Widget build(BuildContext context) {
    var item = context.read<MatchCartModel>().getByPosition(index);
    var textTheme = Theme.of(context).textTheme.titleLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: LimitedBox(
        maxHeight: 70,
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                    item.userImage[0].uRL,
                  )  //item.color,
              ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(item.name, style: textTheme, textAlign: TextAlign.left)
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Text(item.phone, style: textTheme, textAlign: TextAlign.left)
                  ]),
                ],
              ),
            ),
            const SizedBox(width: 24),
            //_AddButton(item: item),
          ],
        ),
      ),
    );
  }
}
