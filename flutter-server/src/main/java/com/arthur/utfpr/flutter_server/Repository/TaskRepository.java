package com.arthur.utfpr.flutter_server.Repository;


import com.arthur.utfpr.flutter_server.Model.Task;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
}
