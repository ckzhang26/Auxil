import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CardItem extends StatefulWidget {
  const CardItem(
      {required this.charityName,
      required this.url,
      required this.zipCode,
      Key? key})
      : super(key: key);
  final String zipCode;
  final String charityName;
  final String url;

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
        child: ListTile(
          leading: Text(widget.zipCode),
          title: Text(widget.charityName),
          subtitle: GestureDetector(
              onDoubleTap: () {
                launch(context);
              },
              child: Text(widget.url)),
          trailing: IconButton(
              onPressed: () {
                setState(() {
                  isFavourite = !isFavourite;
                });
              },
              icon: isFavourite
                  ? const Icon(Icons.star)
                  : const Icon(Icons.star_border)),
        ),
      ),
    );
  }

  launch(BuildContext context) async {
    final Uri url = Uri.parse(widget.url);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not launch $url'),
            duration:
                const Duration(seconds: 3), // Adjust the duration as needed.
          ),
        );
      }
    }
  }
}
