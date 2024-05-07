

import 'dart:math';

import 'package:calculator/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 String userQuestion ='';
 String userAnswer = '';
  bool pressedNummber = false;
  String beforeSign = '';
  bool pressedOperator = false;
  final List<String> buttons = 
  [
    'C', 'DEL', '%', '/',
    '9', '8', '7', 'x',
    '6', '5', '4', '-',
    '3', '2', '1', '+',
    '0', '.', 'ASN', '=',

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Column(
        children: <Widget> [
          Expanded(
            child: Container(
               child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget> [
                  const SizedBox(height: 50,),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    child: Text(userQuestion, style: const TextStyle(fontSize: 30),),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Text(userAnswer, style: const TextStyle(fontSize: 30)),
                  )
                ],
               ),
            )
          ),
          Expanded(
            flex: 2,
              child: SizedBox(
                child: GridView.builder(
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), 
                  itemBuilder: (BuildContext context, int index){
                    if(index == 0)  {
                      return MyButton(
                        buttonTapped: () => {
                          setState(() {
                           beforeSign  = '';
                           userQuestion = '';
                           userAnswer = '0';
                          }),
                        },
                        buttonText: buttons[index],
                        color: Colors.green,
                        textColor: Colors.white,                      
                      );
                    } else if(index == 1) {
                      return MyButton(
                        buttonTapped: () => {
                          setState(() {
                            userQuestion=userQuestion.substring(0, userQuestion.length - 1);
                            
                            
                            if(!isOperator(userQuestion[userQuestion.length - 1]) && isOperator(beforeSign)) {
                              equalPressed();
                            } else {
                              if(isOperator(beforeSign)) {
                                userQuestion = userQuestion.substring(0, userQuestion.length - 1);
                                equalPressed();
                                userQuestion += beforeSign;
                              }
                            }
                          })
                        },
                        buttonText: buttons[index],
                        color: Colors.red,
                        textColor: Colors.white, 
                      );
                    }
                    else if(index == buttons.length - 1) {
                      return  MyButton(
                        buttonTapped: () => {
                          setState(() {
                            equalPressed();
                          })
                        },
                        buttonText: buttons[index],
                        color: Colors.deepPurple,
                        textColor: Colors.white, 
                      );
                    }
                    return MyButton(
                      buttonTapped: () => {
                        setState(() {
                          if(isOperator(buttons[index]) && userQuestion.length > 1) {
                            beforeSign = buttons[index];
                          }
                          if(userQuestion.isEmpty && notAvailabelSign(buttons[index])) {
                            userQuestion = '';
                          }else {
                            userQuestion+=buttons[index];
                          }
                          
                          if(isOperator(beforeSign) && !isOperator(buttons[index])) {
                            equalPressed();
                          }
                          
                        }),
                      },
                      buttonText: buttons[index], 
                      color: isOperator(buttons[index]) ? Colors.deepPurple :  Colors.deepPurple[50],
                      textColor: isOperator(buttons[index]) ? Colors.white : Colors.deepPurple,
                  
                    );
                  },
                ),
              ),
            ) 
        ],
      ),
    );
  }
  bool isOperator(String x) {
    return x == '+' || x == '-' || x == 'x' || x == '/' || x == '%';
  }

  void equalPressed() {
    userQuestion = userQuestion.replaceAll('x', '*');
    Parser p  = Parser();
    Expression exp  = p.parse(userQuestion);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    userAnswer = eval.toString();
    userQuestion = userQuestion.replaceAll('*', 'x');
  }
  bool notAvailabelSign(String s) {
    return s == 'x' || s == '/' || s=='%';
  }
}


