import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/icon_broken.dart';
import 'view/app_components.dart';

class CounterApp1 extends ChangeNotifier {
  int i = 0;

  change() {
    i++;
    notifyListeners();
    print('counter $i');
  }
}

class Test extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test'),
      ),
      body: Consumer<CounterApp1>(
        builder: (context, provider, child) {
          return Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(provider.i.toString()),
                SizedBox(height: 20,),
                IconButton(
                  icon: Icon(IconBroken.Info_Circle,),
                  onPressed: (){
                    provider.change();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
