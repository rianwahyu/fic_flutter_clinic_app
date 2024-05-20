import 'package:dartz/dartz.dart';
import 'package:flutter_fic_frontend/core/constants/variables.dart';
import 'package:flutter_fic_frontend/data/models/response/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  Future<Either<String, AuthResponseModel>> login(
      String email, String password) async {
    final url = Uri.parse('${Variables.baseUrl}/api/login');
    final response = await http.post(
      url, 
      body: {
      'email:' email, 
      'password': password 
      }
    );
  }
}
