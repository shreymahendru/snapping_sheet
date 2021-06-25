import 'package:example/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

void main() {
  runApp(SnappingSheetExampleApp());
}

class SimpleSnappingSheet extends StatelessWidget {
  final ScrollController listViewController = new ScrollController();

  final controller = SnappingSheetController();

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      child: Background(
        onPressed: () async {
          controller.snapToPosition(
            SnappingPosition.factor(
              grabbingContentOffset: GrabbingContentOffset.bottom,
              positionFactor: 0.99,
            ),
          );

          this
              .listViewController
              .animateTo(1400, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
        },
      ),
      lockOverflowDrag: false,
      controller: controller,
      snappingPositions: [
        SnappingPosition.factor(
          positionFactor: 0.1,
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
        SnappingPosition.factor(
          positionFactor: 0.5,
          grabbingContentOffset: GrabbingContentOffset.bottom,
        ),
        SnappingPosition.factor(
          grabbingContentOffset: GrabbingContentOffset.bottom,
          positionFactor: 0.99,
        ),
      ],
      grabbing: GrabbingWidget(),
      grabbingHeight: 75,
      sheetAbove: null,
      onSnapCompleted: (positionData, position) {
        print(positionData.relativeToSheetHeight);
        print(positionData.relativeToSnappingPositions);

        if (positionData.relativeToSnappingPositions == 0) {
          this.listViewController.jumpTo(0);
        }
        print(position);
        print(position);
      },
      sheetBelow: SnappingSheetContent(
        draggable: true,
        childScrollController: listViewController,
        child: Container(
          color: Colors.white,
          child: ListView.builder(
            controller: listViewController,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(15),
                color: Colors.green[200],
                height: 100,
                child: Center(
                  child: Text(index.toString()),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Widgets below are just helper widgets for this example

class Background extends StatelessWidget {
  final VoidCallback onPressed;

  const Background({Key? key, required this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[200],
        child: TextButton(
          child: Text("Press"),
          onPressed: onPressed,
        ));
  }
}

class GrabbingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(blurRadius: 25, color: Colors.black.withOpacity(0.2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            width: 100,
            height: 7,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            color: Colors.grey[200],
            height: 2,
            margin: EdgeInsets.all(15).copyWith(top: 0, bottom: 0),
          )
        ],
      ),
    );
  }
}

class SnappingSheetExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Snapping Sheet Examples',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[700],
          elevation: 0,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        primarySwatch: Colors.grey,
      ),
      home: PageWrapper(),
    );
  }
}

class PageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Example",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return Menu();
                }),
              ),
            },
          )
        ],
      ),
      body: SimpleSnappingSheet(),
    );
  }
}
