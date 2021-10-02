import 'package:domi/core/enum/service_enums.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/screens/register/domiciliary_form/domi_sliver_app_bar.dart';
import 'package:flutter/material.dart';

class ServiceCompletedPage extends StatelessWidget {
  final ServiceStatus serviceStatus;

  ServiceCompletedPage(this.serviceStatus);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            DomiSliverAppBar("Estado del servicio"),
            SliverToBoxAdapter(
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      getStatusMessage(),
                      style: TextStyle(
                          color: inDomiBluePrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String getStatusMessage() {
    print(serviceStatus);
    switch (serviceStatus) {
      case ServiceStatus.completed:
        return "¡Este servicio a finalizado!";
      case ServiceStatus.canceled:
        return "Este servicio ha sido cancelado";
      default:
        return "";
    }
  }
}
