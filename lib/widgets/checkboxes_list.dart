import 'package:flutter/material.dart';
import 'package:grandmaster/widgets/brand_checkbox_listtile.dart';

class CheckboxesList extends StatelessWidget {
  const CheckboxesList(
      {Key? key, this.checkboxes, required this.changeCheckbox, this.onTap})
      : super(key: key);
  final Map<String, bool>? checkboxes;
  final changeCheckbox;
  final Function(dynamic)? onTap;
  @override
  Widget build(BuildContext context) {
    if (checkboxes == null) {
      return Text('no checkboxes');
    }
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: checkboxes?.length,
        itemBuilder: (context, index) {
          if (checkboxes?.keys.elementAt(index).split('_')[1].trim() == '')
            return Container();
          return Column(
            children: [
              BrandCheckboxListTile(
                title: checkboxes?.keys.elementAt(index).split('_')[1],
                value: checkboxes?.values.elementAt(index),
                onChanged: (val) {
                  var localCheckboxes = {...checkboxes!};
                  print(checkboxes?.keys.elementAt(index));
                  print(checkboxes?.values.elementAt(index));
                  localCheckboxes.update(
                      checkboxes!.keys.elementAt(index), (value) => val);
                  changeCheckbox(localCheckboxes);
                },
                onTap: () {
                  if (onTap != null)
                    onTap!(checkboxes?.keys.elementAt(index).split('_')[0]);
                },
              ),
              SizedBox(
                height: 16,
              )
            ],
          );
        });
  }
}
