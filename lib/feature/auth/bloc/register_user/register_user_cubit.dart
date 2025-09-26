import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:elite/main.dart';
part 'register_user_state.dart';

class RegisterUserCubit extends Cubit<RegisterUserState> {
  RegisterUserCubit() : super(RegisterUserInitial());

  registerUser({
    String? name,
    String? mobileNo,
    String? email,
    String? password,
  }) async {
    try {
      emit(RegisterUserLoadingState());
      var response = await post(
        Uri.parse(AppUrls.registerUrl),
        headers: {
          "Content-Type": "application/json",
        },
        body: json.encode(
          {
            "name": name,
            "mobile_no": mobileNo,
            "email": email,
            "password": password,
            "deviceToken": token,
          },
        ),
      );
      final result = jsonDecode(response.body);
      log("registerUser = > $result ${response.statusCode}");
      final requestBody = {
        "name": name,
        "mobile_no": mobileNo,
        "email": email,
        "password": password,
        "deviceToken": token,
      };

      final curl = '''
curl -X POST ${AppUrls.registerUrl} \\
  -H "Content-Type: application/json" \\
  -d '${json.encode(requestBody)}'
''';

      log("CURL COMMAND:\n$curl");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(
            RegisterUserLoadedState(),
          );
        } else {
          emit(RegisterUserErrorState(result["message"]));
        }
      } else {
        emit(RegisterUserErrorState(result["message"]));
      }
    } on SocketException {
      emit(RegisterUserErrorState("Check Internet Connection"));
    } catch (e, s) {
      print("catch error $e, $s");
      emit(
        RegisterUserErrorState(
          "catch error $e, $s",
        ),
      );
    }
  }
}
