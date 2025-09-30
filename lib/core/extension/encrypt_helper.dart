// import 'package:encrypt/encrypt.dart';

// String _ivKey = 'asd123ISLAMaPP****';
// String _passKey = 'asd123ISLAMaPP****';

// extension EncryptionToString on String {
//   String? decrypt() {
//     try {
//       final iv = IV.fromUtf8(_ivKey);
//       final key = Key.fromUtf8(_passKey);
//       final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
//       final encryptedData = Encrypted.from64(this);
//       return encrypter.decrypt(encryptedData, iv: iv);
//     } catch (e) {
//       return null;
//     }
//   }

//   String encrypt() {
//     final iv = IV.fromUtf8(_ivKey);
//     final key = Key.fromUtf8(_passKey);
//     final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
//     final encryptedData = encrypter.encrypt(this, iv: iv);
//     return encryptedData.base64;
//   }
// }
