
import 'package:domi/main.dart';
import 'package:domi/models/general/city.dart';
import 'package:domi/re_use/domi_register_login.dart';
import 'package:domi/re_use/theme.dart';
import 'package:domi/repositories/general_repository.dart';
import 'package:domi/screens/register/name_and_lastname.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProvidenceCity extends StatefulWidget {
  @override
  _ProvidenceCityState createState() => _ProvidenceCityState();
}

class _ProvidenceCityState extends State<ProvidenceCity> {
  ValueNotifier<List<City>> _cities = ValueNotifier<List<City>>([]);
  City? _selectedCity;

  @override
  void initState() {
    final register = context.read(registerProvider);
    GeneralRepository.getCities(
            register.selectedCountry!
            .id!)
        .then((value) {
      if (value.isNotEmpty) {
        _selectedCity = value.first;
        _cities.value = value;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _cities.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: inDomiYellow,
        body: DomiRegisterLogin(
          image: indomiMiniLogo,
          column: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/icons/020-location@3x.png"),
                  height: 93,
                  width: 81,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "¿En qué ciudad estás?:",
                  style: TextStyle(color: inDomiBluePrimary, fontSize: 15),
                ),
                SizedBox(
                  height: 19,
                ),
                Container(
                  height: 38,
                  width: 270,
                  alignment: Alignment.center,
                  child: ValueListenableBuilder<List<City>>(
                      valueListenable: _cities,
                      builder: (context, value, child) {
                        return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(19)),
                              primary: Colors.white,
                              elevation: 0,
                            ),
                            onPressed: () {
                              _showContainer(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    value.isEmpty
                                        ? "Elegir ciudad"
                                        : _selectedCity!.name!,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: inDomiGreyBlack,
                                    )),
                                Icon(Icons.keyboard_arrow_down,
                                    color: inDomiGreyBlack)
                              ],
                            ));
                      }),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 38,
                  width: 270,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(19)),
                      primary: inDomiBluePrimary,
                      elevation: 0,
                    ),
                    onPressed: () {
                      if (_selectedCity == null) {
                        return;
                      }
                      context.read(registerProvider).selectedCity = _selectedCity;
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => NameAndLastname(),
                      ));
                    },
                    child: Text("Siguiente",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _showContainer(BuildContext context) {
    String filter = "";

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: StatefulBuilder(
            builder: (context, setStateX) {
              return Container(
                height: 570,
                width: 323,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 21,
                      left: 18,
                      right: 18,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Seleccione su ciudad",
                          style:
                              TextStyle(fontSize: 15, color: inDomiBluePrimary),
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 274,
                          height: 38,
                          decoration: BoxDecoration(
                              color: Color(0xffF5F5F5),
                              borderRadius: BorderRadius.circular(19)),
                          child: TextFormField(
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 16, top: 8),
                                border: InputBorder.none,
                                isDense: true,
                                hintText: "Buscar",
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                  size: 24,
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 15, color: Color(0xffD1D1D1))),
                            onChanged: (value) {
                              setStateX(() {
                                filter = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ValueListenableBuilder<List<City>>(
                            valueListenable: _cities,
                            builder: (context, value, child) {
                              final filteredCities = filter.isEmpty
                                  ? value
                                  : value
                                      .where((element) => element.name!
                                          .toLowerCase()
                                          .contains(filter.toLowerCase()))
                                      .toList();
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: filteredCities.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _selectedCity = filteredCities[index];
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: Colors.black12))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            "${filteredCities[index].name} / ${filteredCities[index].stateCode} / ${filteredCities[index].countryCode}",
                                            style: TextStyle(
                                                color: Color(0xff707071),
                                                fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Cerrar",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xffD1D1D1),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
