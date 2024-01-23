import 'package:flutter/material.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/utils/snakbar_helper.dart';

class AddToDo extends StatefulWidget {
  final Map? todo;
  const AddToDo({super.key, this.todo});

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit ToDo' : 'Add ToDo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            minLines: 5,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: isEdit ? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(isEdit ? 'Update' : 'Submit'),
              ))
        ]),
      ),
    );
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('You can not call update wothout todo data');
      return;
    }
    final id = todo['_id'];
    final isSuccess = await ToDoService.updateToDo(id, body);
    if (isSuccess) {
      showSuccessMesaage(context, message: 'Creation Success');
    } else {
      showErrorMesaage(context, message: 'Creation failed');
    }
  }

  Future<void> submitData() async {
    final isSuccess = await ToDoService.submitData(body);
    if (isSuccess) {
      showSuccessMesaage(context, message: 'Creation Success');
    } else {
      showErrorMesaage(context, message: 'Creation failed');
    }
  }

  Map get body {
    final title = titleController.text;
    final description = descriptionController.text;
    return {"title": title, "description": description, "is_completed": false};
  }
}
