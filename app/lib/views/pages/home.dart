import 'package:flutter/material.dart';
import 'package:app/views/layout.dart';
import 'package:app/widgets/custom_button.dart';
import 'package:app/views/pages/select_face_shape.dart';

class Home extends StatelessWidget {
  static final String routeName = '/homeRoute';
  Home({Key key}) : super(key: key);

  @override
  build(BuildContext context) {
    return Layout(
        title: 'Style Me',
        header: 'Home',
        drawerItems: buildDefaultDrawerItems(context),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  const Text(
                    "Let's get stylish!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                        fontSize: 24.0,
                        fontFamily: 'Klavika'),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 35.0),
                    child: const Text("Your progress")
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 35.0),
                    child: CustomButton(icon: Icon(Icons.check), text: "Select or take picture", enabled: false)
                  ),
                  Padding(padding: const EdgeInsets.only(top: 35.0),
                    child: CustomButton(icon: Icon(Icons.check), text: "Select your face shape", enabled: true, action: SelectFaceShape(),)
                  ),
                  Padding(padding: const EdgeInsets.only(top: 35.0),
                    child: CustomButton(icon: Icon(Icons.check), text: "Select a hair style", enabled: false,)
                  ),
                  Padding(padding: const EdgeInsets.only(top: 35.0),
                    child: CustomButton(icon: Icon(Icons.add), text: "Colour your hair", enabled: false,)
                  ),
                  Padding(padding: const EdgeInsets.only(top: 35.0),
                    child: CustomButton(icon: Icon(Icons.access_time), text: "Save your results", enabled: false,)
                  ),
                  Padding(padding: const EdgeInsets.only(top: 35.0),
                    child: CustomButton(icon: Icon(Icons.access_time), text: "Compare results", enabled: false,)
                  ),
                  Padding(padding: const EdgeInsets.only(top: 35.0),
                    child: CustomButton(icon: Icon(Icons.access_time), text: "Upload hair style", enabled: false,)
                  ),
                ],
              ),
            )
          )
        )
      );
  }
}
