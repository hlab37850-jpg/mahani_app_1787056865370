import '../data/task.dart';
import '../data/task_repository.dart';

class TaskService {
  final TaskRepository _repo = TaskRepository.instance;

  Future<List<Task>> fetchAllTasks() => _repo.getAllTasks();

  Future<int> addTask(Task task) => _repo.insertTask(task);

  Future<int> updateTask(Task task) => _repo.updateTask(task);

  Future<int> deleteTask(int id) => _repo.deleteTask(id);
}
