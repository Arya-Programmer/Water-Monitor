import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class WaveAnimation extends StatefulWidget {
  final int? filledPercentage;
  const WaveAnimation({Key? key, this.filledPercentage}) : super(key: key);

  @override
  State<WaveAnimation> createState() => _WaveAnimationState();
}

class _WaveAnimationState extends State<WaveAnimation> with TickerProviderStateMixin {
  _WaveAnimationState({ Key? key });

  late AnimationController firstController;
  late Animation<double> firstAnimation;

  late AnimationController secondController;
  late Animation<double> secondAnimation;

  late AnimationController thirdController;
  late Animation<double> thirdAnimation;

  late AnimationController fourthController;
  late Animation<double> fourthAnimation;

  @override
  void initState() {
    super.initState();

    firstController = AnimationController(
      vsync: this, duration: Duration(milliseconds: 1500));
    firstAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
      CurvedAnimation(parent: firstController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          firstController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          firstController.forward();
        }
      });

    secondController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    secondAnimation = Tween<double>(begin: 1.8, end: 2.4).animate(
      CurvedAnimation(parent: secondController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          secondController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          secondController.forward();
        }
      });

    thirdController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    thirdAnimation = Tween<double>(begin: 1.5, end: 2.4).animate(
        CurvedAnimation(parent: thirdController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          thirdController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          thirdController.forward();
        }
      });

    fourthController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1500));
    fourthAnimation = Tween<double>(begin: 1.9, end: 2.1).animate(
        CurvedAnimation(parent: fourthController, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          fourthController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          fourthController.forward();
        }
      });


    Timer(Duration(seconds: 2), () {
      firstController.forward();
    });

    Timer(Duration(milliseconds: 1600), () {
      secondController.forward();
    });

    Timer(Duration(milliseconds: 800), () {
      thirdController.forward();
    });

    fourthController.forward();

  }

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    thirdController.dispose();
    fourthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size);
    return Scaffold(
      backgroundColor: Color(0xff2B2C56),
      body: Stack(
        children: [
          Center(
            child: Text("${widget.filledPercentage}%",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                wordSpacing: 3,
                color: Colors.white.withOpacity(.7)),
              textScaleFactor: 7),
          ),
          CustomPaint(
            painter: MyPainter(
              firstAnimation.value,
              secondAnimation.value,
              thirdAnimation.value,
              fourthAnimation.value,
              (widget.filledPercentage ?? 1)
            ),
            child: SizedBox(
              height: size.height,
              width: size.width,
            ),
          ),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double firstValue;
  final double secondValue;
  final double thirdValue;
  final double fourthValue;
  int filledPercentage;

  MyPainter(
    this.firstValue,
    this.secondValue,
    this.thirdValue,
    this.fourthValue,
    this.filledPercentage
  );

  @override
  void paint(Canvas canvas, Size size) {
    filledPercentage = ((-6)*filledPercentage)+300 as int;

    var first = (size.height / firstValue)+filledPercentage;
    var second = (size.height / secondValue)+filledPercentage;
    var third = (size.height / thirdValue)+filledPercentage;
    var fourth = (size.height / fourthValue)+filledPercentage;

    var paint = Paint()
      ..color = Color(0xff3B6ABA).withOpacity(.8)
      ..style = PaintingStyle.fill;

    var path = Path()
      ..moveTo(0, first)
      ..cubicTo(size.width * .4, second, size.width * .7,
          third, size.width, fourth)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}