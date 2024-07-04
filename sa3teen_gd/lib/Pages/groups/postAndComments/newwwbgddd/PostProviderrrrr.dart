import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gp_screen/Pages/groups/postAndComments/newwwbgddd/ApiServicepostsssss.dart';
import 'package:gp_screen/Pages/groups/postAndComments/newwwbgddd/PostModellll.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<void> fetchPosts(int groupId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _posts = await ApiService().getPosts(groupId,
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIwODIzNjc0LCJpYXQiOjE3MTk1Mjc2NzQsImp0aSI6ImRlODZmMmUwM2RiOTRjOGJiOWQ3ZTVlMTZiYTcwYzY3IiwidXNlcl9pZCI6Mn0.ezPy5Xh-ItL9SH3h9REnioVGgn1WKlDtH-y2un_muGU');
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPost(
      int groupId, String accessToken, String description, File? image) async {
    final url = 'http://10.0.2.2:8000/groups/$groupId/posts/';
    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..fields['description'] = description;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }
    request.headers['Authorization'] = 'Bearer $accessToken';

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        final newPost = Post.fromJson(jsonDecode(response.body));
        _posts.add(newPost);
        await ApiService().getPosts(groupId,
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIwODIzNjc0LCJpYXQiOjE3MTk1Mjc2NzQsImp0aSI6ImRlODZmMmUwM2RiOTRjOGJiOWQ3ZTVlMTZiYTcwYzY3IiwidXNlcl9pZCI6Mn0.ezPy5Xh-ItL9SH3h9REnioVGgn1WKlDtH-y2un_muGU");
        notifyListeners();
      } else {
        print('Failed to create post');
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  Future<void> deletePost(BuildContext context, int groupId, int postId) async {
    final accessToken =
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIwNDY1MjcyLCJpYXQiOjE3MTkxNjkyNzIsImp0aSI6IjljNGRiYzU3MWE4NjRkMmE4MjcyMGFhZjkwMWM3NTRiIiwidXNlcl9pZCI6NX0.OQJa3dfTJq-qYMJYPDziYBrHHYnBcNs9melKysxWyEw'

        // 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzIwODIzNjc0LCJpYXQiOjE3MTk1Mjc2NzQsImp0aSI6ImRlODZmMmUwM2RiOTRjOGJiOWQ3ZTVlMTZiYTcwYzY3IiwidXNlcl9pZCI6Mn0.ezPy5Xh-ItL9SH3h9REnioVGgn1WKlDtH-y2un_muGU'
        ;
    final url = 'http://10.0.2.2:8000/groups/$groupId/posts/$postId/';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 204) {
      _posts.removeWhere((post) => post.id == postId);
      fetchPosts(groupId);
      notifyListeners();
    } else {
      print(response.body);
      _showErrorDialog(context, '${response.body}');
    }
  }
}

void _showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Error'),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text('Okay'),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        ),
      ],
    ),
  );
}

Future<dynamic?> _sendMessageToBackend(
    String title,
    String description,
    String privacy,
    File? image,
    String password,
    String subject,
    String accessToken) async {
  var uri = Uri.parse('http://10.0.2.2:8000/groups/');

  var request = http.MultipartRequest('POST', uri)
    ..fields['title'] = title
    ..fields['description'] = description
    ..fields['type'] = privacy
    ..fields['password'] = password
    ..fields['subject'] = subject;

  // If you need to send an image file
  if (image != null) {
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
  }

  // Add the access token to the headers
  request.headers['Authorization'] = 'Bearer $accessToken';

  try {
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    print('Response status: ${response.statusCode}'); // Log status code
    print('Response body: ${response.body}'); // Log response body

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      print('Request success with status: ${response.statusCode}');
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('Error sending message: $e');
  }
  return null;
}
