import 'package:flutter/material.dart';

void showCustomDialog(
    BuildContext context, String message, String message2, onTap) {
  showDialog(
    context: context,
    barrierColor: Colors.white.withOpacity(0.25),
    builder: (BuildContext cxt) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 26, horizontal: 20),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 89,
                padding: EdgeInsets.symmetric(vertical: 22),
                decoration: BoxDecoration(
                    color: Color(0xFFFBF7F7),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Center(
                  child: Container(
                    width: 210,
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 7,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onTap();
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                      color: Color(0xFFFBF7F7),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      message2,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  // onTap();
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Center(
                    child: Text(
                      'Отмена',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
