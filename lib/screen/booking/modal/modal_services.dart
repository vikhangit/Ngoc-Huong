import 'package:flutter/material.dart';

class ModalService extends StatefulWidget {
  final String id;
  final String title;
  final Map activeCN;
  const ModalService(
      {super.key,
      required this.id,
      required this.title,
      required this.activeCN});

  @override
  State<ModalService> createState() => _ModalServiceState();
}

String activeId = "";
String activeTitle = "";
String activeMaKho = "";

class _ModalServiceState extends State<ModalService> {
  void chooseFuction(String id, String title) {
    setState(() {
      activeId = id;
      activeTitle = title;
    });
  }

  @override
  void dispose() {
    activeId = "";
    activeTitle = "";
    super.dispose();
  }

  void showAlertDialog(BuildContext context, String err) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () => Navigator.pop(context, 'OK'),
    );
    AlertDialog alert = AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          return SizedBox(
            // height: 30,
            width: MediaQuery.of(context).size.width,
            child: Text(
              style: const TextStyle(height: 1.6),
              err,
            ),
          );
        },
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.title;
    return SizedBox(
      child: Column(
        children: [
          Container(
            height: 50,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dịch vụ ${title.toLowerCase()}",
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 25,
                  height: 25,
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(0)),
                          shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))))),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black,
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
