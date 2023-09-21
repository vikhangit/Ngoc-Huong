import 'package:flutter/material.dart';

class CustomFloatingButton extends StatefulWidget {
  const CustomFloatingButton({super.key});

  @override
  State<CustomFloatingButton> createState() => _CustomFloatingButtonState();
}
bool showChat = false;

class _CustomFloatingButtonState extends State<CustomFloatingButton> {
  void handleShowChat(){
    setState(() {
      showChat = !showChat;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
            bottom: 0,
            right: 5,
            child: Column(
              children: [
                Visibility(
                 visible: showChat,
                  child: Container(
                  width: 60,
                  height: 60,
                  child: TextButton(
                      onPressed: () {
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.amber),
                          padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0.0)),
                          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(9999))
                          ))
                      ),
                      child: Image.asset("assets/images/facebook.png", height: MediaQuery.of(context).size.height)),
                ),),
                Visibility(
                  visible: showChat,
                  child: Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(top: 10),
                  child: TextButton(
                      onPressed: () {
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.amber),
                          padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0.0)),
                          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(9999))
                          ))
                      ),
                      child: Image.asset("assets/images/zalo-icon.png", height: MediaQuery.of(context).size.height)),
                ),),
                Container(
                  width: 60,
                  height: 60,
                  margin: const EdgeInsets.only(top: 10),
                  child: TextButton(
                      onPressed: () {
                        handleShowChat();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.amber),
                          padding:
                          MaterialStateProperty.all(const EdgeInsets.all(0.0)),
                          shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(9999))
                          ))
                      ),
                      child: Image.asset( "assets/images/${showChat ? "cancel"  : "chat-icon"}.png", height: 30,)),
                )
              ],
            )),

      ],
    );
  }
}
