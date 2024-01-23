import 'package:flutter/material.dart';
import 'package:todo/pages/add_todo.dart';
import 'package:todo/services/todo_service.dart';
import 'package:todo/utils/snakbar_helper.dart';
import 'package:todo/widgets/todo_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List items = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('ToDo List')),
      ),
      body: Visibility(
        visible: items.isNotEmpty,
        replacement: Center(
            child: Text('No ToDo Item',
                style: Theme.of(context).textTheme.headline4)),
        child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              return ToDoCard(
                  index: index,
                  item: item,
                  navigateToEditPage: navigateToEditPage,
                  deleteById: deleteById);
            }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add Task'),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddToDo(),
        ));
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  Future<void> navigateToEditPage(Map item) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddToDo(todo: item),
        ));
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  Future<void> fetchToDo() async {
    final responce = await ToDoService.fetchToDo();
    if (responce != null) {
      setState(() {
        items = responce;
      });
    } else {
      showErrorMesaage(context, message: 'Something went wrong');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await ToDoService.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMesaage(context, message: 'Deletion Failed');
    }
  }
}
