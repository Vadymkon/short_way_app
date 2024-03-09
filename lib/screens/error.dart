import 'package:flutter/material.dart';

void errorMessage(BuildContext context, String errorMessage) {
  showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(22))),
          child: Padding(
              padding: const EdgeInsets.all(18),
              child: Container(
                width: 260.0,
                // height: 230.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xFFFFFF),
                  borderRadius:
                  BorderRadius.all(Radius.circular(50.0)),
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(maxLines: 3,errorMessage ,style: Theme.of(context).textTheme.labelMedium),
                      ElevatedButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: const Text(maxLines: 1,'ok')),
                    ]

                ),))
  ));
}