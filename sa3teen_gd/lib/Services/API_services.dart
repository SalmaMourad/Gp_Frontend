import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



late String accesstokenfinal ;
String finalurlforall='https://sa3teengd.azurewebsites.net';
// String finalurlforall='http://10.0.2.2:8000';

// String accesstokenfinal= "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIxNzAwOTk2LCJpYXQiOjE3MjA0MDQ5OTYsImp0aSI6ImQ2MGU1NzZlYTI1MzQzNGI5MDBlMGFjMmFiNjU4ZjRiIiwidXNlcl9pZCI6MjJ9.tc4TdwRy5ldAubxW-b5ntBium7Tw_7Tn5F_MMM01Mh0";
//  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIxNjg0MDk2LCJpYXQiOjE
// class Api_services {
class Api_services extends ChangeNotifier {
  List<Map<String, dynamic>> _todoList = [];
  List<int> todolistids = [];
  List<Map<String, dynamic>> todoListDetails = [];
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> listScheduledetails = [];

  List<Map<String, dynamic>> get todoList => _todoList;

// Helper function to convert TimeOfDay to string

  static final Map<String, String> headers = {
    "Content-Type": "application/json",
  };

  // static final String baseUrl = 'http://$serverIP/';
  static final String baseUrl = 'https://sa3teengd.azurewebsites.net/';
  static const localIp = 'localhost:8000';

  //ToDo Change the IP before going LIVE
  static const serverIP = localIp;

  static Future<http.Response?> postRequest(String apiUrl,
      Map<String, String> headers, Map<dynamic, dynamic> body) async {
    try {
      final res = await http.post(Uri.parse(baseUrl + apiUrl),
          headers: headers, body: jsonEncode(body));
      print('Response status: ${res.statusCode}');
      print('Response body: ${res.body}');
      return res;
    } catch (error) {
      print('Error in post request');
      print('Error in post request');
      print('Error in post request');
      print('Error in post request');
      print('Error in post request');
      print('Error in post request');
      print('Error in post request');
      print(error);
    }
    return null;
  }

  // dont forget to change the post in line 44 to get and change the provided error cases
  static Future<http.Response?> getRequest(String apiUrl,
      Map<String, String> headers,) async {
    final res = await http
        .get(Uri.parse(baseUrl + apiUrl), headers: headers
      // , body: jsonEncode(body)
    )
        .then((value) {
      print(value.statusCode);
      print(value.body);
      return value;
    }).catchError((error) {
      print(error);
      return error;
    });
    return res;
  }

  static Future<http.Response?> deleteRequest(String apiUrl,
      Map<String, String> headers) async {
    try {
      final response = await http.delete(
        Uri.parse(baseUrl + apiUrl),
        headers: headers,
      );
      print(response.statusCode);
      print(response.body);
      return response;
    } catch (error) {
      print('Error in HTTP DELETE request: $error');
      return null;
    }
  }

  static Future<http.Response?> putRequest(String apiUrl,
      Map<String, String> headers, Map<dynamic, dynamic> body) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl + apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );
      print(response.statusCode);
      print(response.body);
      return response;
    } catch (error) {
      print('Error in HTTP PUT request: $error');
      return null;
    }
  }

  static Future<http.Response?> patchRequest(String apiUrl,
      Map<String, String> headers, Map<dynamic, dynamic> body) async {
    try {
      final response = await http.patch(
        Uri.parse(baseUrl + apiUrl),
        headers: headers,
        body: jsonEncode(body),
      );
      print(response.statusCode);
      print(response.body);
      return response;
    } catch (error) {
      print('Error in HTTP PATCH request: $error');
      return null;
    }
  }


  static Future<bool> login(String username, String password) async {
    try {
      final response = await postRequest('login/', headers, {
        'username': username.trim(),
        'password': password,
      });

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        // Login successful
        print('Login successful');
        accesstokenfinal = jsonDecode(response.body)['access'];
        print('Access token: $accesstokenfinal');
        return true;
      } else {
        // Login failed
        print('Login failed');

        accesstokenfinal = " ";
        print('Access token: $accesstokenfinal');
        return false;
      }
    } catch (error) {
      // Exception occurred during login request
      print('Error during login: $error');

      return false;
    }
  }

  //post methood
  static sginup(String firstName,
      String lastName,
      String userName,
      String email,
      String password,
      String confirmPasword,
      String phoneNumber) async {
    String api = 'signup/';
    var response = await postRequest(api, headers, {
      'first_name': firstName,
      'last_name': lastName,
      'username': userName,
      'phone_number': phoneNumber.trim(),
      'email': email.trim(),
      'password': password,
      'password_confirm': confirmPasword
    });
    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      // Login successful
      print('Sign up successful');
      return true;
    } else {
      // Login failed
      print('Sign up failed');
      return false;
    }
  }

  static Future<bool> createToDoList(String title, String accessToken) async {
    try {
      // Define your headers including the access token
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json', // Example content type
      };

      // Prepare your request body
      Map<String, dynamic> body = {
        'title': title,
      };

      // Convert the body map to a JSON string


      // Make the POST request
      // final response = await http.post(
      //   Uri.parse('todolist/'), // Replace with your API endpoint
      //   headers: headers,
      //   body: jsonBody,
      // );

      String api = 'todolist/';
      var response = await postRequest(api, headers, body);

      // Check the response status code
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        // Todo list creation successful
        print('Create To Do List successful');
        return true;
      } else {
        // Todo list creation failed
        print(
            'Create To Do List failed with status code: ${response!
                .statusCode}');
        return false;
      }
    } catch (error) {
      // Exception occurred during HTTP request
      print('Error during Create To Do List: $error');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> listAllToDoList(String accessToken) async {
    List<Map<String, dynamic>> todoListDetails = [];
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      String api = 'todolist/listall/';
      var response = await getRequest(api, headers);
      print('gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg');

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        List<dynamic> jsonData = jsonDecode(response.body);

        // Clear the previous details
        todoListDetails.clear();

        jsonData.forEach((map) {
          List<Map<String, dynamic>> tasks = [];
          if (map['tasks'] != null && map['tasks'] is Iterable) {
            for (var task in map['tasks']) {
              tasks.add({
                'id': task['id'],
                'title': task['title'],
                'priority': task['priority'],
                'status': task['status'],
                'due_date': task['due_date'],
              });
            }
          }
          print('8888888888888888888888888888888888888888888888888888888888');
          print(tasks);
          print('8888888888888888888888888888888888888888888888888888888888');
          print(jsonData);
          print('8888888888888888888888888888888888888888888888888888888888');
          print(todoListDetails);
          print('8888888888888888888888888888888888888888888888888888888888');

          todoListDetails.add({
            'id': map['id'],
            'title': map['title'],
            'tasks': tasks,
          });
        });

        print(todoListDetails);
        print("00000000000000000000000000000");

        print('To Do List returned successfully');
        return todoListDetails;
      } else {
        print('To Do List failed');
        return [];
      }
    } catch (error) {
      print('Error To Do List Does not exist: $error');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> deleteToDoList(int id,
      String accessToken) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      String api = 'todolist/$id/'; // Adjust API endpoint to include ID
      var response = await deleteRequest(api, headers);

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201 ||
              response.statusCode == 204)) {
        // Successfully deleted, parse JSON response if needed
        List<dynamic> jsonData = jsonDecode(response.body);
        // Handle response as needed

        print('To Do List removed successfully');
        return jsonData.cast<Map<String, dynamic>>();
      } else {
        // Deletion failed
        print('Delete from To Do List failed');
        return [];
      }
    } catch (error) {
      print('Error deleting To Do List: $error');
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> deleteTask(String listId, String taskId,
      String accessToken) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      String api = 'todolist/$listId/tasks/$taskId/';
      var response = await deleteRequest(api, headers);

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201 ||
              response.statusCode == 204)) {
        // Print the response body to understand its structure
        print('Response body: ${response.body}');

        // Parse JSON response body
        List<dynamic> jsonData = jsonDecode(response.body);
        print('Decoded JSON data: $jsonData');

        // Remove the task from _todoList by matching the task ID
        jsonData.forEach((map) {
          if (map is Map<String, dynamic>) {
            _todoList.removeWhere((task) => task['id'] == map['id']);
          } else {
            print('Unexpected item in jsonData: $map');
          }
        });

        print(_todoList);
        print("00000000000000000000000000000");
        print('Task removed successfully');
        return _todoList;
      } else {
        print('Delete task failed');
        return [];
      }
    } catch (error) {
      print('Delete error: task does not exist: $error');
      return [];
    }
  }

  static Future<bool> updateTask(int todoListid,
      int taskId,
      String title,
      String? dueDate,
      String accessToken) async {
    try {
      // Define your headers including the access token
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // Prepare your request body
      Map<String, dynamic> body = {
        'id': taskId,
        'title': title,
        'due_date': dueDate,
      };

      // Make the PUT request
      String api = 'todolist/$todoListid/tasks/$taskId/';
      var response = await putRequest(api, headers, body);

      // Check the response status code
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        // Task update successful
        print('Update Task successful');
        return true;
      } else {
        // Task update failed
        print('Update Task failed with status code: ${response!.statusCode}');
        return false;
      }
    } catch (error) {
      // Exception occurred during HTTP request
      print('Error during Update Task: $error');
      return false;
    }
  }


  static Future<bool> createTask(int todoListid, String title, String? priority,
      bool? status, String? dueDate, String accessToken) async {
    try {
      // Define your headers including the access token
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // Prepare your request body
      Map<String, dynamic> body = {
        'id': todoListid,
        'title': title,
        'priority': priority,
        'status': status,
        'due_date': dueDate,
      };

      // Make the POST request
      String api = 'todolist/$todoListid/tasks/';
      var response = await postRequest(api, headers, body);

      // Check the response status code
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        // Task creation successful
        print('Create Task successful');
        return true;
      } else {
        // Task creation failed
        print('Create Task failed with status code: ${response!.statusCode}');
        return false;
      }
    } catch (error) {
      // Exception occurred during HTTP request
      print('Error during Create Task: $error');
      return false;
    }
  }

  static Future<bool> updateTaskStatus(int todoListid, int taskId, bool status,
      String accessToken) async {
    try {
      // Define your headers including the access token
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // Prepare your request body
      Map<String, dynamic> body = {
        'status': status,
      };

      // Make the PATCH request
      String api = 'todolist/$todoListid/tasks/$taskId/';
      var response = await patchRequest(api, headers, body);

      // Check the response status code
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 204)) {
        // Status update successful
        print('Update Task Status successful');
        return true;
      } else {
        // Status update failed
        print('Update Task Status failed with status code: ${response!
            .statusCode}');
        return false;
      }
    } catch (error) {
      // Exception occurred during HTTP request
      print('Error during Update Task Status: $error');
      return false;
    }
  }

  static Future<bool> updateTaskPriority(int todoListid, int taskId,
      String priority, String accessToken) async {
    try {
      // Define your headers including the access token
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // Prepare your request body
      Map<String, dynamic> body = {
        'priority': priority,
      };

      // Make the PATCH request
      String api = 'todolist/$todoListid/tasks/$taskId/';
      var response = await patchRequest(api, headers, body);

      // Check the response status code
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 204)) {
        // Status update successful
        print('Update Task Status successful');
        return true;
      } else {
        // Status update failed
        print('Update Task Status failed with status code: ${response!
            .statusCode}');
        return false;
      }
    } catch (error) {
      // Exception occurred during HTTP request
      print('Error during Update Task Status: $error');
      return false;
    }
  }

  Future<bool> addSchedule(String title,
      String day,
      TimeOfDay startTime,
      TimeOfDay endTime,
      String description,
      int reminderTime,
      String color,
      String accessToken) async {
    try {
      // Define your headers including the access token
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      String timeOfDayToString(TimeOfDay time) {
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString()
            .padLeft(2, '0')}:00';
      }

      String startTimeStr = timeOfDayToString(startTime);
      String endTimeStr = timeOfDayToString(endTime);

      // Prepare your request body
      Map<String, dynamic> body = {
        'title': title,
        'day': day,
        'start_time': startTimeStr, // Use converted string here
        'end_time': endTimeStr, // Use converted string here
        'description': description,
        'reminder_time': reminderTime,
        'color': color,
      };

      // Make the PATCH request
      String api = 'schedules/';
      var response = await postRequest(api, headers, body);

      // Check the response status code
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        // Status update successful
        print('Add To Schedule successful');
        print(response.body);
        listScheduledetails.add(jsonDecode(response.body));
        notifyListeners();
        return true;
      } else {
        // Status update failed
        print(
            'Add To Schedule failed with status code: ${response!.statusCode}');

        return false;
      }
    } catch (error) {
      // Exception occurred during HTTP request
      print('Error during Add To Schedule Status: $error');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> listSchedule(String accessToken) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      String api = 'schedules/';
      var response = await getRequest(api, headers);
      print('Request sent to $api');

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        List<dynamic> jsonData = jsonDecode(response.body);
        listScheduledetails.clear();

        for (dynamic map in jsonData) {
          listScheduledetails.add({
            'id': map['id'],
            'title': map['title'],
            'day': map['day'],
            'start_time': map['start_time'],
            'end_time': map['end_time'],
            'description': map['description'],
            'reminder_time': map['reminder_time'],
            'color': map['color'],
            'user': map['user'],
          });
          print('88888888888888888888888888888888888888888');
          print(map);
          print('88888888888888888888888888888888888888888');
        }

        notifyListeners();
        print('Schedules returned successfully');
        return listScheduledetails;
      } else {
        print('Failed to fetch schedules');
        return [];
      }
    } catch (error) {
      print('Error fetching schedules: $error');
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> DeleteSlot(int slotid,
      String accessToken) async {
    try {
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };
      String api = 'schedules/$slotid/';
      var response = await deleteRequest(api, headers);
      print('aseeeeebbbbbaaaa333333y');
      print(response!.statusCode);
      print(response.body);
      if (
      (response.statusCode == 200 || response.statusCode == 201 ||
          response.statusCode == 204)) {
        // Print the response body to understand its structure
        print('Response body: ${response.body}');

        // Parse JSON response body

        listScheduledetails.removeWhere((task) => task['id'] == slotid);
        notifyListeners();
        // Remove the task from _todoList by matching the task ID

        print("00000000000000000000000000000");
        print('Schedules Slot removed successfully');
        print(
            'afteeer if conditionnnnnnnnnnnnnn0000000000000000000011111111111111111');

        return listScheduledetails;
      }

      else {
        print(
            'elseeee  conditionnnnnnnnnnnnnn0000000000000000000011111111111111111');

        print('Schedules Slot failed');
        return [];
      }
    } catch (error) {
      print('Delete error: Schedules Slot: $error');
      return [];
    }
  }


  Future<bool> UpdateSlot(int slotid,
      String title,
      String day,
      String startTime,
      String endTime,
      String? description,
      int? reminderTime,
      String color,
      String accessToken,) async {
    try {
      // Define your headers including the access token
      Map<String, String> headers = {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      };

      // Prepare your request body
      Map<String, dynamic> body = {
        'title': title,
        'day': day,
        'start_time': startTime,
        'end_time': endTime,
        'description': description,
        'reminder_time': reminderTime,
        'color': color,
      };
      for (var i = 0; i < listScheduledetails.length; i++) {
        if (listScheduledetails[i]['id'] == slotid) {
          listScheduledetails[i] = body;
          listScheduledetails[i]['id'] = slotid;
          notifyListeners();
        }
      }

      // Make the PUT requestF
      String api = 'schedules/$slotid/';
      var response = await putRequest(api, headers, body);

      // Check the response status code
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        // Slot update successful
        print('Update Slot successful');

        return true;
      } else {
        // Slot update failed
        print('Update Slot failed with status code: ${response!.statusCode}');
        return false;
      }
    } catch (error) {
      // Exception occurred during HTTP request
      print('Error during Update Slot: $error');
      return false;
    }
  }

  Future<bool> forgetpassword(String email) async {
    try {

      String api = 'reset/password-reset/';




      final response = await postRequest(api, headers, {
        'email': email.trim(),
      });

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        // Login successful
        print('Forget password successful');
        return true;
      } else {
        // Login failed
        print('Forget password failed');
        return false;
      }
    } catch (error) {
      // Exception occurred during login request
      print('Error during forget password: $error');
      return false;
    }
  }


}
