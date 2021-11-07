String handlingAuthError(code) {
  switch (code) {
    case "weak-password":
      return 'The password provided is too weak !';
      break;
    case "wrong-password":
      return 'Your password is wrong !';
      break;
    case "email-already-in-use":
      return 'The account already exists for that email !';
      break;
    case "user-not-found":
      return 'No user found for that email !';
      break;
    case "invalid-email":
      return 'Invalid email !';
      break;
    case "network-request-failed":
      return 'Check your connection !';
      break;
    default:
      return 'An undefined Error happened !';
  }
}
