import 'package:flutter/material.dart';

/// Reprend l'exemple "Quiz Page" du support de cours :
/// un StatefulWidget qui affiche une question à la fois, incrémente
/// le score via setState(), puis affiche le score final en %.
class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  int currentQuestion = 0;
  int score = 0;

  final List<Map<String, Object>> quiz = [
    {
      'title': 'Flutter utilise le langage',
      'answers': [
        {'answer': 'Java', 'correct': false},
        {'answer': 'Dart', 'correct': true},
        {'answer': 'Kotlin', 'correct': false},
      ],
    },
    {
      'title': 'Flutter est développé par',
      'answers': [
        {'answer': 'Google', 'correct': true},
        {'answer': 'Facebook', 'correct': false},
        {'answer': 'Microsoft', 'correct': false},
      ],
    },
    {
      'title': 'Le widget racine le plus courant est',
      'answers': [
        {'answer': 'MaterialApp', 'correct': true},
        {'answer': 'RootWidget', 'correct': false},
        {'answer': 'AppRoot', 'correct': false},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor: Colors.orange,
      ),
      body: (currentQuestion >= quiz.length)
          ? _buildScorePage()
          : _buildQuestionPage(),
    );
  }

  Widget _buildScorePage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Score : ${(score / quiz.length * 100).round()} %',
            style: const TextStyle(color: Colors.deepOrange, fontSize: 22),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
            onPressed: () {
              setState(() {
                currentQuestion = 0;
                score = 0;
              });
            },
            child: const Text(
              'Recommencer ...',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPage() {
    final answers =
        quiz[currentQuestion]['answers'] as List<Map<String, Object>>;

    return ListView(
      children: [
        ListTile(
          title: Center(
            child: Text(
              'Question : ${currentQuestion + 1}/${quiz.length}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
        ListTile(
          title: Text(
            '${quiz[currentQuestion]['title']} ?',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        ...answers.map((answer) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
              ),
              onPressed: () {
                setState(() {
                  if (answer['correct'] == true) ++score;
                  ++currentQuestion;
                });
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  answer['answer'] as String,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
