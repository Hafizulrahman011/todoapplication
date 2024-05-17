import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:todoapp/pages/task_page.dart';


class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: buildContent(context),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildImage(),
        SizedBox(height: 24),
        buildTitle(),
        SizedBox(height: 16),
        buildDescription(),
        SizedBox(height: 32),
        buildButton(context),
      ],
    );
  }

  Widget buildImage() {
    return SvgPicture.asset(
      'images/notelist.svg',
      height: 200,
    );
  }

  Widget buildTitle() {
    return Text(
      'Welcome to NoteList',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildDescription() {
    return Text(
      'Organize your task efficiently and easily. Get started by creating your first todolist!',
      style: TextStyle(
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskPage()),
        );
      },
      child: Text('Get Started'),
    );
  }
}
