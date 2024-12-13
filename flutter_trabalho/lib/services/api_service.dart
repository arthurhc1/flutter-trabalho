import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_trabalho/model/task.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://10.0.2.2:8080/api/tasks")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("")
  Future<List<Task>> fetchTasks();

  @POST("")
  Future<Task> createTask(@Body() Task task);

  @DELETE("/{id}")
  Future<void> deleteTask(@Path("id") int id);

  @PUT("/{id}")
  Future<Task> updateTask(@Path("id") int id, @Body() Task task);
}
