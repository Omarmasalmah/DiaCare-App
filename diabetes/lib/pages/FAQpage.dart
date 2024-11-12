import 'package:flutter/material.dart';

class DiabetesFAQPage extends StatefulWidget {
  const DiabetesFAQPage({super.key});

  @override
  DiabetesFAQPageState createState() => DiabetesFAQPageState();
}

class DiabetesFAQPageState extends State<DiabetesFAQPage> {
  final List<Map<String, String>> faq = [
    {
      'question': 'ما هو مرض السكري؟',
      'answer':
          'السكري هو مرض مزمن يحدث عندما يكون مستوى السكر (الجلوكوز) في الدم مرتفعًا جدًا. يأتي الجلوكوز من الطعام ويحتاج الجسم إلى هرمون الإنسولين الذي يساعد على إدخال السكر إلى الخلايا للحصول على الطاقة. في السكري، لا ينتج الجسم كمية كافية من الإنسولين أو لا يستخدمه بشكل فعال، مما يؤدي إلى تراكم السكر في الدم.'
    },
    {
      'question': 'ما الفرق بين السكري من النوع الأول والنوع الثاني؟',
      'answer':
          'السكري من النوع الأول عادةً ما يُشخَّص في الطفولة أو الشباب ويحدث عندما يهاجم الجهاز المناعي خلايا البنكرياس المنتجة للإنسولين. أما السكري من النوع الثاني، فيتطور غالبًا في سن البلوغ ويرتبط بعوامل مثل السمنة وقلة النشاط، ويحدث عندما يصبح الجسم مقاومًا للإنسولين أو عندما يقل إنتاج الإنسولين.'
    },
    {
      'question': 'ما هي أعراض مرض السكري؟',
      'answer':
          'تشمل الأعراض الشائعة العطش المفرط، التبول المتكرر، الشعور بالتعب، فقدان الوزن غير المبرر، الرؤية الضبابية، والجروح التي تلتئم ببطء. بعض الأشخاص قد لا يشعرون بأي أعراض خاصة في النوع الثاني من السكري.'
    },
    {
      'question': 'كيف يمكنني إدارة السكري؟',
      'answer':
          'يعتمد التحكم بالسكري على تناول نظام غذائي صحي، ممارسة الرياضة بانتظام، مراقبة مستوى السكر في الدم، والالتزام بتعليمات الطبيب بشأن الأدوية أو الإنسولين. يمكن أن تساعد تغييرات نمط الحياة في التحكم في مستوى السكر وتقليل خطر المضاعفات.'
    },
    {
      'question': 'هل يمكن لمرضى السكري تناول السكر؟',
      'answer':
          'نعم، يمكن لمرضى السكري تناول السكر باعتدال كجزء من نظام غذائي متوازن، ولكن من المهم مراقبة مستوى السكر في الدم والتأكد من أن الاستهلاك لا يسبب ارتفاعات كبيرة. من الأفضل استشارة الطبيب حول التوجيهات الغذائية الشخصية.'
    },
    {
      'question': 'ما هي مضاعفات مرض السكري إذا لم يتم التحكم فيه؟',
      'answer':
          'يمكن أن يؤدي عدم التحكم بالسكري إلى مضاعفات خطيرة، مثل مشاكل القلب والأوعية الدموية، الفشل الكلوي، مشاكل العين (مثل اعتلال الشبكية)، تلف الأعصاب، وبتر الأطراف. الإدارة الجيدة للسكري تساعد في تقليل خطر هذه المضاعفات.'
    },
    {
      'question': 'كيف يمكنني مراقبة مستوى السكر في المنزل؟',
      'answer':
          'يمكن مراقبة مستوى السكر باستخدام جهاز قياس الجلوكوز في الدم. توصي التوجيهات الطبية بفحص مستويات السكر في أوقات محددة، مثل قبل وبعد الوجبات وأثناء النشاط البدني. بعض الأشخاص يستخدمون أنظمة المراقبة المستمرة التي توفر معلومات لحظية حول مستويات السكر.'
    },
    {
      'question': 'هل يجب على مرضى السكري ممارسة الرياضة؟',
      'answer':
          'نعم، تُعد الرياضة جزءًا مهمًا من إدارة السكري، حيث تساعد في تحسين حساسية الجسم للإنسولين وخفض مستوى السكر في الدم. يُنصح بممارسة 150 دقيقة على الأقل من النشاط البدني المعتدل أسبوعيًا. يجب استشارة الطبيب قبل البدء ببرنامج رياضي لضمان السلامة.'
    },
    {
      'question': 'هل هناك أطعمة يجب تجنبها كليًا؟',
      'answer':
          'يفضل تجنب الأطعمة ذات السكريات المضافة والكربوهيدرات المكررة، مثل الحلويات والمشروبات الغازية، لأنها قد تؤدي إلى ارتفاعات سريعة في مستوى السكر. يمكن تناول الكربوهيدرات المعقدة والبروتينات والألياف التي تساعد على تنظيم مستوى السكر.'
    },
    {
      'question': 'هل السكري مرض وراثي؟',
      'answer':
          'الوراثة تلعب دورًا في زيادة خطر الإصابة بالسكري، خاصة النوع الثاني. إذا كان أحد الوالدين أو الإخوة مصابًا، فإن احتمال الإصابة يكون أعلى.'
    },
  ];

  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'أسئلة شائعة عن السكري',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
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
