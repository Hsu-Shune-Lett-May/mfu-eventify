import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'hive_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final HiveService _hiveService = HiveService();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Get cached user from Hive (works offline)
  UserModel? get cachedUser => _hiveService.getUser();

  Future<UserCredential?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(name);

    final userModel = UserModel(
      uid: credential.user!.uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );

    // Save to Firestore
    await _firestore.collection('users').doc(userModel.uid).set({
      ...userModel.toMap(),
      'createdAt': FieldValue.serverTimestamp(),  // use server timestamp in Firestore
    });

    // Cache in Hive locally
    await _hiveService.saveUser(userModel);

    return credential;
  }

  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Fetch user profile from Firestore and cache it in Hive
    await _fetchAndCacheUser(credential.user!.uid);

    return credential;
  }

  // Fetch user from Firestore and save to Hive
  Future<void> _fetchAndCacheUser(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final userModel = UserModel.fromMap(doc.data()!);
        await _hiveService.saveUser(userModel);
      }
    } catch (_) {
      // If Firestore fetch fails, we still have Firebase Auth user info
      final user = _auth.currentUser;
      if (user != null) {
        final fallback = UserModel(
          uid: user.uid,
          name: user.displayName ?? 'MFU Student',
          email: user.email ?? '',
          createdAt: DateTime.now(),
        );
        await _hiveService.saveUser(fallback);
      }
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _hiveService.clearUser();  // clear Hive cache on logout
    await _auth.signOut();
  }
} 