import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart'; // Thêm dòng này để sử dụng DocumentList

Client client = Client()
    .setEndpoint('https://cloud.appwrite.io/v1')
    .setProject('66e68c93000194b108c5')
    .setSelfSigned(
        status: true); // For self signed certificates, only use for development

const String db = "66e68f010026fb7c7c70";
const String userCollection = "66e68f0f0013d95af2d3";

Account account = Account(client);
final Databases databases = Databases(client);

// save phone number to databae (while creating a new account)
Future<bool> savePhoneToDb(
    {required String phoneno, required String userId}) async {
  try {
    final response = await databases.createDocument(
        databaseId: db,
        collectionId: userCollection,
        documentId: userId,
        data: {
          "phone_no": phoneno,
          "userId": userId,
        });

    print(response);
    return true;
  } on AppwriteException catch (e) {
    print("Cannot save to user database :$e");
    return false;
  }
}

// check whether phone number exitst in DB or not
Future<String> checkPhoneNumber({required String phoneno}) async {
  try {
    final DocumentList matchUser = await databases.listDocuments(
        databaseId: db,
        collectionId: userCollection,
        queries: [Query.equal("phone_no", phoneno)]);
    if (matchUser.total > 0) {
      final Document user = matchUser.documents[0];

      if (user.data["phone_no"] != null || user.data["phone_no"] != "") {
        return user.data["userId"];
      } else {
        print("no user exits on db");
        return "user_not_exist";
      }
    } else {
      print("no user exits on db");
      return "user_not_exist";
    }
  } on AppwriteException catch (e) {
    print("erro onreading databse $e");
    return "user_not_exist";
  }
}

// create a phone session, send otp to the phone number
Future<String> createPhoneSession({required String phone}) async {
  try {
    final userId = await checkPhoneNumber(phoneno: phone);
    if (userId == "user_not_exist") {
      // creating a new account
      final Token data =
          await account.createPhoneToken(userId: ID.unique(), phone: phone);

      //save the new user to user collection
      savePhoneToDb(phoneno: phone, userId: data.userId);
      return data.userId;
    }

    // if user is an existing user
    else {
      // create phone token for existing user
      final Token data =
          await account.createPhoneToken(userId: userId, phone: phone);
      return data.userId;
    }
  } catch (e) {
    print("error on create phone session :$e");
    return "login_error";
  }
}

// login with otp
Future<bool> loginWithOtp({required String otp, required String userId}) async {
  try {
    final Session session =
        await account.updatePhoneSession(userId: userId, secret: otp);
    print(session.userId);
    return true;
  } catch (e) {
    print("error on login with otp:$e");
    return false;
  }
}

// to check whether the session exist or not
Future<bool> checkSessions() async {
  try {
    final Session session = await account.getSession(sessionId: "current");
    print("session exist ${session.$id}");
    return true;
  } catch (e) {
    print("session does not exist please login");
    return false;
  }
}
