import 'package:net/config/imported.dart';

class Gui {
  static AppBar header(String text) {
    return AppBar(
      backgroundColor: Config.green,
      foregroundColor: Colors.white,
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(fontSize: 30, shadows: [
            Shadow(
              blurRadius: 10,
              color: Color.fromARGB(125, 0, 0, 0),
              offset: Offset(0, 1),
            )
          ]),
          text: text,
        ),
      ),
      centerTitle: true,
    );
  }

  static OutlinedButton button(String text, Function() callback) {
    return OutlinedButton(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Config.green,
      ),
      onPressed: () => {callback()},
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: 58,
            child: Center(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 32, shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Color.fromARGB(125, 0, 0, 0),
                      offset: Offset(0, 2),
                    )
                  ]),
                  text: text,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  static TextButton labelButton(String text, double size) {
    return TextButton(
      onPressed: () => {},
      child: Center(
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: size,
              color: Colors.black,
            ),
            text: text,
          ),
        ),
      ),
    );
  }

  static GestureDetector iconButton(
      String text, Icon icon, Function() callback) {
    return GestureDetector(
        onTap: () => {callback()},
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            icon,
            Text(
              text,
              style: TextStyle(fontSize: 24),
            ),
          ],
        ));
  }

  static TextField textInput(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLength: 32,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 28,
        color: Colors.black,
        shadows: [
          Shadow(
            blurRadius: 12,
            color: Color.fromARGB(55, 0, 0, 0),
            offset: Offset(0, 1),
          ),
        ],
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          borderSide: BorderSide(
            color: Colors.white,
            strokeAlign: 15,
            width: 1,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 28,
          color: Colors.black,
          shadows: [
            Shadow(
              blurRadius: 12,
              color: Color.fromARGB(55, 0, 0, 0),
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }

  static Padding pad(double amt) {
    return Padding(
      padding: EdgeInsets.only(top: amt, bottom: 0, left: 0, right: 0),
    );
  }

  static RichText label(String text, double size) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(
          fontSize: size,
          color: Colors.black,
          shadows: const [
            Shadow(
              blurRadius: 12,
              color: Color.fromARGB(55, 0, 0, 0),
              offset: Offset(0, 1),
            ),
          ],
        ),
        text: text,
      ),
    );
  }
}
