import 'package:domi/main.dart';
import 'package:domi/provider/service/service_history_provider.dart';
import 'package:domi/re_use/utils/loading_sliver.dart';
import 'package:domi/screens/domi_home/service/service_description.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:domi/screens/service/widgets/service_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceHistoryPage extends StatefulWidget {
  DomiSliverAppBar? sliverAppBar;

  ServiceHistoryPage({this.sliverAppBar});

  @override
  _ServiceHistoryPageState createState() => _ServiceHistoryPageState();
}

class _ServiceHistoryPageState extends State<ServiceHistoryPage> {
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    context.read(serviceHistoryProvider.notifier).getHistory();
    _scrollController.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      context.read(serviceHistoryProvider.notifier).getHistory();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, child) {
          final data = watch(serviceHistoryProvider).results;
          final user = watch(authProvider).userData!.user;
          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              if (widget.sliverAppBar != null) widget.sliverAppBar!,
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ServiceDescriptionPage(data[index])));
                      },
                      child: ServiceHistoryItem(
                          service: data[index], showDomiTax: user.isDomi)),
                );
              }, childCount: data.length)),
              if (watch(serviceHistoryProvider.notifier).isLoading)
                LoadingSliver()
            ],
          );
        },
      ),
    );
  }
}
