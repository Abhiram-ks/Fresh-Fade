import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../../auth/data/datasource/auth_local_datasource.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  final AuthLocalDatasource localDB;
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  DeleteAccountBloc({required this.localDB, required this.auth, required this.googleSignIn, }) : super(DeleteAccountInitial()) {
    on<DeleteAccountAlertBoxEvent>((event, emit) {
      emit(DeleteAccountAlertBox());
    });
    on<DeleteAccountConfirmEvent>((event, emit) async {
      emit(DeleteAccountLoading());
      try {
        
        final String? uid = await localDB.get();
        if (uid == null || uid.isEmpty) {
          emit(
            DeleteAccountFailure(error: 'Session expired. Please login again.'),
          );
          return;
        }

        final User? currentUser = auth.currentUser;
        if (currentUser == null) {
          log('currentUser is null');
          emit(DeleteAccountFailure(error: 'No user logged in'));
          return;
        }

        await currentUser.delete();
        await googleSignIn.signOut();
        await localDB.delete();
        await localDB.deleteAll();
        emit(DeleteAccountSuccess());
      
      } catch (e) {
        log('error: $e');
        emit(DeleteAccountFailure(error: 'Failed to delete account: ${e.toString()}'));
      }
    });
  }
}
