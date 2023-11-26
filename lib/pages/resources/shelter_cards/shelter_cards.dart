import 'package:net/config/imported.dart';

class ShelterCards extends StatefulWidget {
  const ShelterCards(
      {required this.charityName,
      required this.url,
      required this.zipCode,
      Key? key})
      : super(key: key);
  final String zipCode;
  final String charityName;
  final String url;

  @override
  State<ShelterCards> createState() => _ShelterCardState();
}

class _ShelterCardState extends State<ShelterCards> {
  bool isFavourite = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: ListTile(
          leading: Text(widget.zipCode),
          title: Text(widget.charityName),
          subtitle: Text(widget.url),
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
}
