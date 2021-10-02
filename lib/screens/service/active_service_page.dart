import 'package:domi/provider/service/active_services_provider.dart';
import 'package:domi/screens/home/configuration_drawer/domi_drawer.dart';
import 'package:domi/screens/home/service/delivery_status.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:domi/screens/service/widgets/service_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveServicePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final data = watch(activeServicesProvider).results;
    return Scaffold(
        body: SafeArea(
      child: CustomScrollView(
        slivers: [
          DomiSliverAppBar("Ordenes activas"),
          SliverPadding(padding: EdgeInsets.only(top: 10)),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return ServiceItem(
                service: data[index],
                domiType: DomiType.user,
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DeliveryStatus(data[index].id)));
                });
          }, childCount: data.length))
        ],
      ),
    ));
  }
}
