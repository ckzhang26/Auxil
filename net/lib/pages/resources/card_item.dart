// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:net/user/mongodb.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class CardItem extends StatefulWidget {
  CardItem(
      {this.charityName,
      required this.resultType,
      this.url,
      this.zipCode,
      this.address,
      this.cityTown,
      this.facilityName,
      this.state,
      this.telephoneNumber,
      this.isFavorite = false,
      Key? key})
      : super(key: key);
  final String? zipCode;
  final String? charityName;
  final String? url;
  final String? facilityName;
  final String? address;
  final String? cityTown;
  final String? state;
  final String? telephoneNumber;
  final String resultType;
  bool isFavorite = false;

  @override
  State<CardItem> createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {
  bool isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.charityName != null && widget.charityName!.isNotEmpty)
                Text(
                  widget.charityName!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  overflow: TextOverflow.visible,
                ),
              if (widget.facilityName != null &&
                  widget.facilityName!.isNotEmpty)
                Text(
                  widget.facilityName!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                  overflow: TextOverflow.visible,
                ),
              if (widget.address != null && widget.address!.isNotEmpty)
                Text(
                  widget.address!,
                  overflow: TextOverflow.ellipsis,
                ),
              if (widget.cityTown != null &&
                  widget.state != null &&
                  widget.zipCode != null &&
                  widget.cityTown!.isNotEmpty &&
                  widget.state!.isNotEmpty &&
                  widget.zipCode!.isNotEmpty)
                Text(
                  "${widget.cityTown!} ${widget.state!} ${widget.zipCode!} ",
                  overflow: TextOverflow.ellipsis,
                ),
              if (widget.zipCode != null && widget.zipCode!.isNotEmpty)
                Text(
                  widget.zipCode!,
                  overflow: TextOverflow.ellipsis,
                ),
              if (widget.telephoneNumber != null &&
                  widget.telephoneNumber!.isNotEmpty)
                Text(widget.telephoneNumber!),
              if (widget.url != null && widget.url!.isNotEmpty)
                GestureDetector(
                  onDoubleTap: () async {
                    Gui.notify(context, "Redirecting...");
                    if (!await launchLink()) {
                      Gui.notify(context, "Failed to redirect");
                    }
                  },
                  child: const Text("Double tap to be redirected"),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        // indexing via "facilityName"?
                        if (widget.isFavorite) {
                          // it already is a favorite, remove it
                          userRemoveFromFavorites(context, widget.resultType,
                              widget.charityName ?? '');
                          widget.isFavorite = false;
                        } else {
                          // it isnt a favorite, add it
                          userAddToFavorites(context, widget.resultType);
                          widget.isFavorite = true;
                        }
                        // widget.isFavorite = !widget.isFavorite;
                      });
                    },
                    icon: widget.isFavorite
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border),
                    color: Colors.red,
                    iconSize: 30,
                  ),
                ],
              )
            ],
          )),
    );
  }

  Future<bool> launchLink() async {
    final Uri url = Uri.parse(widget.url ?? '');
    return await launchUrl(url);
  }

  void userAddToFavorites(BuildContext context, String resultType) {
    var data;
    switch (resultType) {
      case 'shelter':
        data = {
          "charityName": widget.charityName,
          "url": widget.url,
          "zipCode:": widget.zipCode
        };
        MongoDB.user.shelter.add(jsonEncode(data));
        break;
      case 'healthcare':
        data = {
          "facility_name": widget.facilityName,
          "address": widget.address,
          "citytown": widget.cityTown,
          "zip_code": widget.zipCode,
          "telephone_number": widget.telephoneNumber
        };
        MongoDB.user.healthcare.add(jsonEncode(data));
        break;
      case 'veterinary':
        data = {
          "facility_name": widget.facilityName,
          "address": widget.address
        };
        MongoDB.user.veterinary.add(jsonEncode(data));
        break;
      case 'job':
        data = {
          "facility_name": widget.facilityName,
          "url": widget.url,
          "address": widget.address,
          "telephone_number": widget.telephoneNumber,
        };
        MongoDB.user.job.add((jsonEncode(data)));
        break;
    }
    MongoDB.saveLocalUser();
  }

  void userRemoveFromFavorites(
      BuildContext context, String resultType, String name) {
    switch (resultType) {
      case 'shelter':
        MongoDB.user.shelter.removeWhere((element) =>
            widget.charityName == jsonDecode(element)['charityName']);
        break;
      case 'healthcare':
        MongoDB.user.healthcare.removeWhere((element) =>
            widget.facilityName == jsonDecode(element)['facility_name']);
        break;
      case 'job':
        MongoDB.user.job.removeWhere((element) =>
            widget.facilityName == jsonDecode(element)['facility_name']);
        break;
      case 'veterinary':
        MongoDB.user.veterinary.removeWhere((element) =>
            widget.facilityName == jsonDecode(element)['facility_name']);
        break;
    }
    MongoDB.saveLocalUser();
  }
}
