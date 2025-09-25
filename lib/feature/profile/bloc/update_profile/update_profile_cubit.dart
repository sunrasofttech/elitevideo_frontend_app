import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:elite/constant/app_urls.dart';
import 'package:http/http.dart';
import 'package:elite/main.dart';
import 'package:elite/utils/header.dart';
part 'update_profile_state.dart';

class UpdateProfileCubit extends Cubit<UpdateProfileState> {
  UpdateProfileCubit() : super(UpdateProfileInitial());

  updateProfile({
    String? email,
    String? name,
    String? mobileNo,
    bool? isPaidMember,
    String? subscriptionId,
    bool? isSubscription,
    String? subscriptionEndDate,
    String? activeDate,
    File? profilePicture,
  }) async {
    emit(UpdateProfilLoadingState());
    try {
      var uri = Uri.parse("${AppUrls.baseUrl}/api/ott/user/$userId");
      var request = MultipartRequest("PUT", uri);

      request.headers.addAll(
        Header.header,
      );

      Future<void> addFile(String fieldName, File? file) async {
        if (file != null) {
          final mimeType = lookupMimeType(file.path);
          if (mimeType != null) {
            request.files.add(
              await MultipartFile.fromPath(
                fieldName,
                file.path,
                contentType: MediaType.parse(mimeType),
              ),
            );
          } else {
            log("Unable to determine MIME type for file: ${file.path}");
          }
        }
      }

      await addFile("profile_picture", profilePicture);

      Map<String, String> fields = {
        if (email != null) "email": email,
        if (name != null) "name": name,
        if (mobileNo != null) "mobile_no": mobileNo.toString(),
        if (isPaidMember != null) "is_paid_member": isPaidMember.toString(),
        if (subscriptionId != null) "subscription_id": subscriptionId.toString(),
        if (isSubscription != null) "is_subscription": isSubscription.toString(),
        if (subscriptionEndDate != null) "subscription_end_date": subscriptionEndDate.toString(),
        if (activeDate != null) "is_active": activeDate.toString(),
      };

      request.fields.addAll(fields);

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      log("message == $responseData");
      final result = jsonDecode(responseData);

      log("Result: $result");
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (result['status'] == true) {
          emit(UpdateProfileLoadedState());
        } else {
          emit(UpdateProfileErrorState("${result['message']}"));
        }
      } else {
        emit(UpdateProfileErrorState("Server error: ${response.statusCode}"));
      }
    } on SocketException {
      emit(UpdateProfileErrorState("Check Internet Connection"));
    } catch (e) {
      emit(UpdateProfileErrorState(e.toString()));
    }
  }
}
