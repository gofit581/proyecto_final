import 'package:entrenador/core/entities/Routine.dart';
import 'package:entrenador/core/entities/TrainingDay.dart';
import 'package:entrenador/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';


class CompleteRoutineScreen extends StatefulWidget {
  const CompleteRoutineScreen({super.key, required this.currentRoutine});

  static const String name = 'CompleteRoutine';
  final Routine currentRoutine;

  @override
  State<CompleteRoutineScreen> createState() => _CompleteRoutineScreenState();
}

class _CompleteRoutineScreenState extends State<CompleteRoutineScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Rutina Actual',
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRoutineCard(
              title: 'Título de la Rutina',
              content: widget.currentRoutine.title,
            ),
            const SizedBox(height: 8),
            _buildRoutineCard(
              title: 'Objetivo',
              content: widget.currentRoutine.typeOfTraining?.name ?? 'Sin objetivo',
            ),
            const SizedBox(height: 8),
            _buildRoutineCard(
              title: 'Duración',
              content: '${widget.currentRoutine.duration} semanas',
            ),
            const SizedBox(height: 8),
            _buildRoutineCard(
              title: 'Pausa entre ejercicios',
              content: '${widget.currentRoutine.rest} segundos',
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: screenHeight * 0.6,
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.currentRoutine.exercises.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, weekIndex) {
                        return _buildWeekCard(context, weekIndex);
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.currentRoutine.exercises.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: _currentPage == index ? 12.0 : 8.0,
                        height: _currentPage == index ? 12.0 : 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? const Color(0xFF1616B4)
                              : Colors.grey[400],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineCard({required String title, required String content}) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Colors.blueGrey[50],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1616B4),
                ),
              ),
              const SizedBox(height: 6),
              //const Divider(thickness: 1.0,),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildWeekCard(BuildContext context, int weekIndex) {
    List<TrainingDay> week = widget.currentRoutine.exercises[weekIndex];

    return SizedBox(
      width: double.infinity,
      child: Card(
        color:Colors.blueGrey[50],
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SEMANA ${weekIndex + 1}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color.fromARGB(255, 22, 22, 180),
                  ),
                ),
                const SizedBox(height: 16),
                _buildExerciseList(week),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseList(List<TrainingDay> week) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (var dayIndex = 0; dayIndex < week.length; dayIndex++)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DÍA ${dayIndex + 1}',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 22, 22, 180),
              ),
            ),
            const SizedBox(height: 8),
            
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Ejercicio',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Series',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Repeticiones',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                
                for (var exercise in week[dayIndex].exercises)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          exercise.title!,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          exercise.series.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          exercise.repetitions.toString(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 16),

            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Observación',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        week[dayIndex].observation,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
    ],
  );
  }
}