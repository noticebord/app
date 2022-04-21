import 'package:flutter/material.dart';

class NewNoticePage extends StatefulWidget {
  const NewNoticePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewNoticePageState();
}

class _NewNoticePageState extends State<NewNoticePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _tabController.addListener(() {
      tabIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Notice'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.save))
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [
            const Tab(text: 'Notice'),
            const Tab(text: 'Team Notice'),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        const Center(child: Text('Create notices.')),
        const Center(child: Text('Create team notices.')),
      ],)

    );
  }
}
