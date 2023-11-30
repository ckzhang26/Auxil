// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:net/config/gui.dart';
import 'package:url_launcher/url_launcher.dart';

class CardItem extends StatefulWidget {
  const CardItem(
      {this.charityName,
      this.url,
      this.zipCode,
      this.address,
      this.cityTown,
      this.facilityName,
      this.state,
      this.telephoneNumber,
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
                        if (isFavourite) {
                          // it already is a favorite, remove it
                        } else {
                          // it isnt a favorite, add it
                        }
                        isFavourite = !isFavourite;
                      });
                    },
                    icon: isFavourite
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
}
