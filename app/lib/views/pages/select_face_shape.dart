import 'package:flutter/material.dart';
import 'package:app/views/layout.dart';
import 'package:app/widgets/face_card.dart';
import 'package:app/widgets/custom_radio_item.dart';

class SelectFaceShape extends StatelessWidget {
  static final String routeName = '/selectFaceShapeRoute';
  SelectFaceShape({Key key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Layout(
        title: 'Style Me',
        header: 'Select Face Shape',
        drawerItems: buildDefaultDrawerItems(context),
        body: Scrollbar(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child:
              CustomRadio()
              //Column(children: [CustomRadio()],)
              // Column(
              //   children: [
              //     CustomRadio(),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(vertical: 40.0),
              //       child: MaterialButton(
              //         disabledColor: Colors.grey[600],
              //         disabledTextColor: Colors.white,
              //         onPressed: () {
              //           // send request to authenticate data with Users API
              //           Scaffold.of(context)
              //               .showSnackBar(SnackBar(content: Text('Processing Data')));
              //         },
              //         color: Color.fromARGB(255, 74, 169, 242),
              //         minWidth: double.infinity,
              //         child: Text('Sign up'),
              //       ),
              //     ),
              //   ],
              // )
          )
        )
      );
  }
}
