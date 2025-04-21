import 'package:diabetes/generated/l10n.dart';
import 'package:flutter/material.dart';

class DiabetesFAQPage extends StatefulWidget {
  const DiabetesFAQPage({super.key});

  @override
  DiabetesFAQPageState createState() => DiabetesFAQPageState();
}

class DiabetesFAQPageState extends State<DiabetesFAQPage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faq = [
      {
        'question': S.of(context).translate('whatIsDiabetes'),
        'answer': S.of(context).translate('whatIsDiabetesAnswer')
      },
      {
        'question': S.of(context).translate('differenceType1Type2'),
        'answer': S.of(context).translate('differenceType1Type2Answer')
      },
      {
        'question': S.of(context).translate('symptomsOfDiabetes'),
        'answer': S.of(context).translate('symptomsOfDiabetesAnswer')
      },
      {
        'question': S.of(context).translate('manageDiabetes'),
        'answer': S.of(context).translate('manageDiabetesAnswer')
      },
      {
        'question': S.of(context).translate('diabeticEatSugar'),
        'answer': S.of(context).translate('diabeticEatSugarAnswer')
      },
      {
        'question':
            S.of(context).translate('diabetesComplicationsUncontrolled'),
        'answer':
            S.of(context).translate('diabetesComplicationsUncontrolledAnswer')
      },
      {
        'question': S.of(context).translate('monitorBloodSugarHome'),
        'answer': S.of(context).translate('monitorBloodSugarHomeAnswer')
      },
      {
        'question': S.of(context).translate('exerciseForDiabetics'),
        'answer': S.of(context).translate('exerciseForDiabeticsAnswer')
      },
      {
        'question': S.of(context).translate('foodsToAvoid'),
        'answer': S.of(context).translate('foodsToAvoidAnswer')
      },
      {
        'question': S.of(context).translate('isDiabetesHereditary'),
        'answer': S.of(context).translate('isDiabetesHereditaryAnswer')
      }
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Diabetes FAQ',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 23, 167, 42),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionPanelList.radio(
            expandedHeaderPadding: EdgeInsets.zero,
            initialOpenPanelValue: _expandedIndex,
            animationDuration: const Duration(milliseconds: 500),
            children: faq.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, String> item = entry.value;
              return ExpansionPanelRadio(
                value: index,
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  return ListTile(
                    title: Text(
                      item['question']!,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isExpanded ? Colors.blueAccent : Colors.black,
                      ),
                    ),
                  );
                },
                body: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    item['answer']!,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
