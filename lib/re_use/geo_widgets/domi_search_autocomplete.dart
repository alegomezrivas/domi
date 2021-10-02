import 'dart:async';
import 'dart:convert';

import 'package:domi/core/network/api_keys.dart';
import 'package:domi/provider/config/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class IndomiSearchAutocomplete extends StatefulWidget {
  final String hintText;
  final ValueChanged<Map<String, dynamic>>? onSelectAnPlace;
  final String country;
  final bool showAddressBook;

  IndomiSearchAutocomplete(
      {this.hintText = "",
      this.onSelectAnPlace,
      this.country = "Colombia",
      this.showAddressBook = false});

  @override
  _IndomiSearchAutocompleteState createState() =>
      _IndomiSearchAutocompleteState();
}

class _IndomiSearchAutocompleteState extends State<IndomiSearchAutocomplete> {
  String _sessionToken = Uuid().v4();
  List<dynamic> _placeList = [];
  bool _mounted = true;
  Timer? _debounce;
  bool selected = false;
  TextEditingController _controller = TextEditingController();
  FocusNode _textNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance!.addPostFrameCallback((_) {
    //   _textNode.requestFocus();
    // });
    Future.delayed(Duration(milliseconds: 250), (){
      _textNode.requestFocus();
    });
    if (widget.showAddressBook) {
      Future.microtask(() {
        if (context.read(addressProvider).results.isEmpty) {
          context.read(addressProvider.notifier).getAddressBook();
        }
      });
    }
  }

  @override
  void dispose() {
    _textNode.dispose();
    _debounce?.cancel();
    _mounted = false;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 5,
                width: 70,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            TextFormField(
              focusNode: _textNode,
              controller: _controller,
              decoration: InputDecoration(
                  hintText: widget.hintText,
                  contentPadding: EdgeInsets.only(top: 5, left: 10)),
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  getSuggestion(_controller.text);
                });
              },
            ),
            if (_controller.text.isEmpty && widget.showAddressBook)
              Consumer(
                builder: (context, watch, child) {
                  return Expanded(
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              if (widget.onSelectAnPlace != null) {
                                widget.onSelectAnPlace!({
                                  "name": watch(addressProvider)
                                      .results[index]
                                      .address,
                                  "geometry": {
                                    "location": {
                                      "lat": watch(addressProvider)
                                          .results[index]
                                          .location!
                                          .latitude,
                                      "lng": watch(addressProvider)
                                          .results[index]
                                          .location!
                                          .longitude,
                                    }
                                  }
                                });
                              }
                            },
                            title: Text(
                                watch(addressProvider).results[index].name ??
                                    ""),
                            subtitle: Text(
                                watch(addressProvider).results[index].address ??
                                    ""),
                          );
                        },
                        itemCount: watch(addressProvider).results.length),
                  );
                },
              ),
            Container(
                height: 200,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        if (!selected) {
                          selected = true;
                          try {
                            if (widget.onSelectAnPlace != null) {
                              final details = await getPlaceDetails(
                                  _placeList[index]["place_id"]);
                              details["name"] = _placeList[index]
                                      ["description"] ??
                                  details["name"];
                              widget.onSelectAnPlace!(details);
                            }
                          } catch (e) {
                            selected = false;
                          }
                        }
                      },
                      title: Text(_placeList[index]["description"] ?? ""),
                      subtitle: Text(_placeList[index]["secondary_text"] ?? ""),
                    );
                  },
                  itemCount: _placeList.length,
                ))
          ],
        ),
      ),
    );
  }

  void getSuggestion(String input) async {
    if (input.isEmpty) {
      return;
    }
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    input = input + ", ${widget.country}";
    String request =
        '$baseURL?input=${Uri.encodeComponent(input.replaceAll("-", " ").replaceAll("  ", " "))}&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      if (_mounted) {
        setState(() {
          final decoded = jsonDecode(response.body)['predictions'];
          if (decoded != null) {
            _placeList = decoded;
          }
        });
      }
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
    String request =
        '$baseURL?place_id=$placeId&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken&fields=formatted_address,name,geometry';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      if (_mounted) {
        final decoded = jsonDecode(response.body)['result'];
        if (decoded != null) {
          return decoded;
        }
      }
      return Future.error("No se ha podido obtener los datos de la dirección");
    } else {
      return Future.error("No se ha podido obtener los datos de la dirección");
    }
  }
}
